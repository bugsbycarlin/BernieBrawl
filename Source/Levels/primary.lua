
local composer = require("composer")
local snow = require("Source.Utilities.snow")

level = {}
level.__index = level

-- your max_x is artificially set at the right side of the current zone.
-- your min_x is set at either 0, or your highest right value minus 1000.
-- min_x also won't go over 10,000, so you can always walk around the hotel area.
-- I don't want to have to worry about whether you can go back and revisit shops,
-- so they're intentionally set so that once you cross the next boundary, you
-- can't actually backtrack to them anyway.
-- camera maxes are also set to match.
local zones = {
  {min=0, max=1200, type="goons", num=5, pace=4000, max_bads=3},
  {min=1200, max=2700, type="goons", num=5, pace=4000, max_bads=3},
  {min=2700, max=4000, type="shop", num=0, arrow={x=2948, y=0}, max_bads=3},
  {min=4000, max=5600, type="goons", num=5, pace=4000, max_bads=3},
  {min=5600, max=7200, type="goons", num=5, pace=4000, max_bads=3},
  {min=7200, max=8500, type="warren", num=5, max_bads=3},
  {min=8500, max=10100, type="shop", num=0, max_bads=3},
  {min=10100, max=12000, type="goons", num=8, pace=5000, max_bads=4},
  {min=10100, max=12000, type="hotel", num=0, max_bads=3},
}

function level:create(game)

  local object = {}
  setmetatable(object, level)

  self.candidates = {}
  self.candidates["warren"] = require("Source.Candidates.Warren")
  self.candidates["suit"] = require("Source.Candidates.Suit")

  self.warren = nil

  self.game = game
  self.player = game.player

  self.current_zone = 0
  self.player_furthest_x = 0
  self.time_since_last_bad = 0
  self.warren_has_appeared = false
  self.player_starting_x = 184

  self.goon_type = "suit"

  return object
end

function level:buildLevel()

  game = self.game

  parallax_background = display.newImageRect(game.parallaxBackgroundGroup, "Art/primary_parallax_background.png", 12000, 800)
  parallax_background.anchorX = 0
  parallax_background.x = 0
  parallax_background.anchorY = 1
  parallax_background.y = display.contentHeight / game.game_scale

  background = display.newImageRect(game.mainGroup, "Art/primary_background.png", 12000, 800)
  background.anchorX = 0
  background.x = 0
  background.anchorY = 1
  background.y = display.contentHeight / game.game_scale

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 7150
  traffic_cone.y = 383

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 7200
  traffic_cone.y = 385

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 7250
  traffic_cone.y = 385

  park_edging = display.newImageRect(game.foregroundGroup, "Art/park_edging.png", 1092, 61)
  park_edging.anchorX = 0
  park_edging.anchorY = 0
  park_edging.x = 7324
  park_edging.y = 362

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 8475
  traffic_cone.y = 387

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 8527
  traffic_cone.y = 382

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 8575
  traffic_cone.y = 385

  self.snow_effect = snow:create(game.foregroundGroup, 4000)
  print("I have happened")

end


function level:addBad(val)

  game = self.game
  player = self.player

  local start_x = math.min(player.max_x + 180, player.x + 700)
  dice = math.random(1, 99)
  if dice > 80 then
    start_x = player.x - 400
  elseif dice > 40 then
    start_x = player.x + 300
  end
  if val ~= nil then
    start_x = val
  end
  
  local fighter = self.candidates[self.goon_type]:create(start_x, display.contentCenterY, game.mainGroup, game.min_x, game.max_x, game.min_z, game.max_z, game.effects)
  if dice > 33 then
    fighter:setZ(300)
  end
  fighter.target = player
  fighter.side = "bad"
  fighter:enable()

  table.insert(game.fighters, fighter)

  fighter.fighters = game.fighters

  self.time_since_last_bad = system.getTimer()

  return fighter
end

function level:addWarren()
  game = self.game

  warren_has_appeared = true

  warren = self.candidates["warren"]:create(8100, display.contentCenterY, game.mainGroup, game.min_x, game.max_x, game.min_z, game.max_z, game.effects)
  warren.target = game.player
  warren.side = "bad"
  warren.xScale = -1

  table.insert(game.fighters, warren)

  warren.fighters = game.fighters

  self.time_since_last_bad = system.getTimer()

  return warren
end

function level:checkLevel()

  self.snow_effect:update()

  game = self.game
  player = self.player
  fighters = game.fighters
  camera = game.camera
  effects = game.effects
  state = game.state

  -- remove dead bads from the stage
  local new_fighters = {}
  for i = 1, #fighters do
    fighter = fighters[i]
    if fighter ~= game.player and fighter.action == "blinking" and fighter.blinking_start_time ~= nil and system.getTimer() - fighter.blinking_start_time > 3000 then
      fighter:disable()
      display.remove(fighter)
    else
      table.insert(new_fighters, fighter)
    end
  end
  game.fighters = new_fighters
  fighters = game.fighters
  for i = 1, #fighters do
    fighters[i].fighters = game.fighters
  end

  -- count bads and active bads
  num_bads = 0
  num_active_bads = 0
  for i = 1, #fighters do
    if fighters[i].side == "bad" then
      num_bads = num_bads + 1
      if fighters[i].health > 0 then
        num_active_bads = num_active_bads + 1
      end
    end
  end

  -- check if the zone needs to be progressed, and update max_x for all fighters and the camera.
  if self.current_zone == 0
    or (zones[self.current_zone].type == "goons" and zones[self.current_zone].num <= 0 and num_active_bads == 0) 
    or (zones[self.current_zone].type == "shop" and player.x > zones[self.current_zone].max - 200) then
    self.current_zone = self.current_zone + 1
    self.time_since_last_bad = system.getTimer()
    
    -- here do the arrow effect
    if self.current_zone > 1 then
      effects:addArrow(game.uiGroup, display.contentWidth - 64, display.contentCenterY, 128, 0, 3000)
      if zones[self.current_zone].arrow ~= nil then
        effects:addArrow(game.foregroundGroup, zones[self.current_zone].arrow.x, zones[self.current_zone].arrow.y, 64, 90, -1)
      end
    end
  end

  -- don't check the rest if we somehow haven't left zone 0
  if self.current_zone == 0 then
    return
  end

  if zones[self.current_zone].type == "goons" 
    and (system.getTimer() - self.time_since_last_bad > zones[self.current_zone].pace or num_active_bads == 0)
    and zones[self.current_zone].num > 0
    and num_active_bads < zones[self.current_zone].max_bads
    and self.player_furthest_x >= zones[self.current_zone].min then
    fighter = self:addBad()
    fighter:enableAutomatic()
    zones[self.current_zone].num = zones[self.current_zone].num - 1
  end

  -- warren pre sequence

  if zones[self.current_zone].type == "warren" and game.state == "active" and self.warren_has_appeared == false and player.x > zones[self.current_zone].min + 300 then
    player:restingAction()
    game.state = "pre_fight_1"
    game.uiGroup.isVisible = false
  end

  if zones[self.current_zone].type == "warren" and game.state == "pre_fight_1" and player.x < zones[self.current_zone].min + 600 then
    if player.move_decay == 0 or player.move_decay > 9 then
      player:moveAction(player.max_x_velocity * 0.7, 0)
    end
  end

  if zones[self.current_zone].type == "warren" and game.state == "pre_fight_1" and self.warren_has_appeared == false and player.x >= zones[self.current_zone].min + 600 and player.x_vel == 0 then
    for i = 1,130,1 do
      effects:addRedSpeedLine(display.contentCenterY, game.speedlineGroup)
    end
    do_full_scene = true
    if do_full_scene then
      game.state = "pre_fight_2"
      timer.performWithDelay(1000, function()
        effects:addTemporaryText("THE TRAITOR", display.contentCenterX, display.contentCenterY, 25, {0,0,0}, game.supertextGroup, 1000)
      end)
      timer.performWithDelay(1500, function() 
        self.warren = self:addWarren() 
        player:disable()
        timer.performWithDelay(1500, function()
          bubble = textBubble:create(self.warren, game.foregroundGroup, "You said a woman could never be president!", "left", -50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(3500, function()
          bubble = textBubble:create(player, game.foregroundGroup, "Bull!", "right", 50, -105, 1000)
          effects:add(bubble)
        end)
        timer.performWithDelay(5000, function()
          bubble = textBubble:create(player, game.foregroundGroup, "And you said you'd never take Super PAC money.", "right", 50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(7500, function()
          bubble = textBubble:create(self.warren, game.foregroundGroup, "You can't get the job done, Bernie.", "left", -50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(10000, function()
          bubble = textBubble:create(self.warren, game.foregroundGroup, "So I have a plan to take your lane.", "left", -50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(12500, function()
          bubble = textBubble:create(self.warren, game.foregroundGroup, "Step one is to mess you up.", "left", -50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(15000, function()
          bubble = textBubble:create(player, game.foregroundGroup, "Fine, you want a childish playground fight?", "right", 50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(17500, function()
          bubble = textBubble:create(player, game.foregroundGroup, "We're on a playground.", "right", 50, -105, 1000)
          effects:add(bubble)
        end)
        timer.performWithDelay(19000, function()
          bubble = textBubble:create(player, game.foregroundGroup, "Let's fight.", "right", 50, -105, 1500)
          effects:add(bubble)
        end)
          timer.performWithDelay(1000, function() 
          game.state = "pre_fight_3" 
        end)
        timer.performWithDelay(20500, function()
          player:enable()
          self.warren:enable()
          self.warren:enableAutomatic()
          zones[self.current_zone].num = 0
          game.state = "active"
          game.uiGroup.isVisible = true
        end)
      end)
    else
      self.warren = self:addWarren() 
      self.warren:enable()
      self.warren:enableAutomatic()
      zones[self.current_zone].num = 0
      game.state = "active"
      game.uiGroup.isVisible = true
    end
  end

  if zones[self.current_zone].type == "warren" and game.state == "pre_fight_2" and self.warren_has_appeared == false then
    for i = 1,15,1 do
      effects:addRedSpeedLine(display.contentCenterY, game.speedlineGroup)
    end
  end

  -- post warren
  if game.state == "active" and zones[self.current_zone].type == "warren" and self.warren_has_appeared == true and num_active_bads == 0 and self.warren.action == "blinking" then
    self.warren:disableAutomatic()
    self.warren.health = 1
    self.warren.action = "dizzy"
    self.warren.rotation = 0
    self.warren.y = self.warren.y - 60
    player:celebratingAction()
    game.state = "post_fight_1"

    b_side = "right"
    w_side = "left"
    b_x = 50
    w_x = -50
    if player.x > self.warren.x then
      b_side = "left"
      w_side = "right"
      b_x = -50
      w_x = 50
    end
    timer.performWithDelay(0, function()
      bubble = textBubble:create(player, game.foregroundGroup, "...", b_side, b_x, -105, 2000)
      effects:add(bubble)
    end)
    timer.performWithDelay(2500, function()
      bubble = textBubble:create(player, game.foregroundGroup, "It's over for you, Liz.", b_side, b_x, -105, 2000)
      effects:add(bubble)
    end)
    timer.performWithDelay(5000, function()
      bubble = textBubble:create(self.warren, game.foregroundGroup, "Yeah, I know.", w_side, w_x, -105, 2000)
      effects:add(bubble)
    end)
    timer.performWithDelay(7500, function()
      bubble = textBubble:create(self.warren, game.foregroundGroup, "I didn't plan for this. What now?", w_side, w_x, -105, 2000)
      effects:add(bubble)
    end)
    timer.performWithDelay(10000, function()
      bubble = textBubble:create(player, game.foregroundGroup, "> Warren is my VP", b_side, b_x, -105, 3000)
      effects:add(bubble)
    end)
    timer.performWithDelay(10000, function()
      bubble = textBubble:create(player, game.foregroundGroup, "AOC is my VP", b_side, b_x, -85, 3000)
      effects:add(bubble)
    end)
    timer.performWithDelay(13500, function()
      bubble = textBubble:create(player, game.foregroundGroup, "You want to be the VP?", b_side, b_x, -105, 2000)
      effects:add(bubble)
    end)
    timer.performWithDelay(16000, function()
      bubble = textBubble:create(player, game.foregroundGroup, "You can still kick Trump in the nuts.", b_side, b_x, -105, 2000)
      effects:add(bubble)
    end)
    timer.performWithDelay(18500, function()
      self.warren:disable()
      self.warren.sprite:setFrame(1)
      bubble = textBubble:create(self.warren, game.foregroundGroup, "I'd like that.", w_side, w_x, -105, 2000)
      effects:add(bubble)
    end)
    timer.performWithDelay(20500, function()
      self.warren:enable()
      self.warren.ground_target = 3000
      self.warren:jumpingAction()
      self.warren.y_vel = -10
      bubble = textBubble:create(player, game.foregroundGroup, "Let's get to work!", b_side, b_x, -105, 2000)
      effects:add(bubble)
    end)
    timer.performWithDelay(22500, function()
      game.state = "active"
      self.warren:disable()
      new_fighters = {}
      self.warren.side = "good"
      player:restingAction()
      player.target = nil
      self.warren.target = nil
      for i = 1, #fighters do
        if fighter ~= warren then
          table.insert(new_fighters, warren)
        end
      end
      game.fighters = new_fighters
      fighters = game.fighters
      display.remove(self.warren)
      self.warren = nil
      effects:removeType("smoke_trail")
      self.current_zone = self.current_zone + 1
      self.time_since_last_bad = system.getTimer()
      effects:addArrow(game.uiGroup, display.contentWidth - 64, display.contentCenterY, 128, 0, 3000)
      if zones[self.current_zone].arrow ~= nil then
        effects:addArrow(game.foregroundGroup, zones[self.current_zone].arrow.x, zones[self.current_zone].arrow.y, 64, 90, -1)
      end
    end)
  end
  if game.state == "post_fight_1" and player.action ~= "celebrating" then
    player:celebratingAction()
    if player.health <= 0 then
      player.health = 1
    end
  end

  -- update min x for good guys, and max x for everyone and the camera
  self.player_furthest_x = math.max(self.player_furthest_x, player.x)
  for i = 1, #fighters do
    if fighters[i].side == "good" then
      fighters[i].min_x = math.min(10000, self.player_furthest_x - 1000)
    end
    fighters[i].max_x = zones[self.current_zone].max
  end
  camera.max_x = zones[self.current_zone].max - display.contentWidth - 200
end

function level:checkEnding()

end

return level