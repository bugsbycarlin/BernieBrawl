
local composer = require("composer")
local animation = require("plugin.animation")
local snow = require("Source.Utilities.snow")
local scriptMaker = require("Source.Utilities.scriptMaker")
local doorTemplate = require("Source.Utilities.door")

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
  {min=0, max=1200, type="goons", num=3, pace=4000, max_bads=3},
  {min=1200, max=2700, type="goons", num=5, pace=4000, max_bads=3},
  {min=2700, max=4000, type="shop", num=5, arrow={x=2948, y=360}, max_bads=3},
  {min=4000, max=5600, type="goons", num=5, pace=4000, max_bads=3},
  {min=5600, max=7200, type="goons", num=0, pace=4000, max_bads=3},
  {min=7200, max=8500, type="warren", num=5, max_bads=3},
  {min=8500, max=9800, type="shop", num=0, arrow={x=8980, y=330}, max_bads=3},
  {min=9800, max=12000, type="goons", num=7, pace=5000, max_bads=4}, --7
  {min=10100, max=12000, type="hotel", num=0, arrow={x=11000, y=320}, max_bads=3},
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

  self.current_zone = 8
  self.player_furthest_x = 0
  self.time_since_last_bad = 0
  self.warren_has_appeared = false
  self.player_starting_x = 9700

  self.goon_type = "suit"

  self.stage_music = audio.loadStream("Sound/robot_loop.mp3")

  return object
end

function level:addDoors()
  local door_margin = 40
  self.doors = {
    {x=2915, y=394, width=70, height=120, type="regular", action=nil},
    {x=8937, y=371, width=81, height=136, type="regular", action=nil},
    {x=10939, y=331, width=131, height=179, type="hotel", action=nil},
    {x=410, y=379, width=72, height=122, type="regular", action=function()
      self:addDoorBad(410, candidate.default_ground_target, 379 - candidate.default_ground_target + door_margin)
    end},
    {x=757, y=380, width=70, height=120, type="regular", action=function()
      self:addDoorBad(757, candidate.default_ground_target, 380 - candidate.default_ground_target + door_margin)
    end},
    {x=11479, y=376, width=79, height=133, type="regular", action=function()
      self:addDoorBad(11479, candidate.default_ground_target, 376 - candidate.default_ground_target + door_margin)
    end},
    {x=10449, y=374, width=79, height=132, type="regular", action=function()
      self:addDoorBad(10449, candidate.default_ground_target, 374 - candidate.default_ground_target + door_margin)
    end},
    {x=10013, y=373, width=78, height=131, type="regular", action=function()
      self:addDoorBad(10013, candidate.default_ground_target, 373 - candidate.default_ground_target + door_margin)
    end},
  }
  for i = 1,#self.doors do
    door = self.doors[i]
    if door.type == "regular" then
      door_object = doorTemplate:create(self.game.bgGroup, self.game.effects, self.player, door.x, door.y, door.width, door.height, 300, nil, door.action, nil)
      self.game.effects:add(door_object)
    elseif door.type == "hotel" then
      door_object = doorTemplate:create(self.game.bgGroup, self.game.effects, self.player, door.x, door.y, door.width, door.height, -1, "hotel_door_open", door.action, function()
        return self.current_zone == 9
      end)
      self.game.effects:add(door_object)
    end

    -- if door.action ~= nil then
    --   door.action()
    -- end
  end
end

function level:buildLevel()

  game = self.game

  parallax_background = display.newImageRect(game.parallaxBackgroundGroup, "Art/primary_parallax_background.png", 12000, 800)
  parallax_background.anchorX = 0
  parallax_background.x = 0
  parallax_background.y = 0
  parallax_background.anchorY = 0

  background = display.newImageRect(game.bgGroup, "Art/primary_background.png", 12000, 800)
  background.anchorX = 0
  background.x = 0
  background.y = 0
  background.anchorY = 0

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 7150
  traffic_cone.y = 783

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 7200
  traffic_cone.y = 785

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 7250
  traffic_cone.y = 785

  park_edging = display.newImageRect(game.foregroundGroup, "Art/park_edging.png", 1092, 61)
  park_edging.anchorX = 0
  park_edging.anchorY = 0
  park_edging.x = 7324
  park_edging.y = 738

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 8475
  traffic_cone.y = 787

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 8527
  traffic_cone.y = 785

  traffic_cone = display.newImageRect(game.foregroundGroup, "Art/traffic_cone.png", 43, 53)
  traffic_cone.x = 8575
  traffic_cone.y = 785

  self.snow_effect = snow:create(game.foregroundGroup, 4000)
end

function level:prepareToActivate()
  self:addDoors()
  self.player:enable()
  timer.performWithDelay(2500, function() self.game:activateGame() end)
end

function level:addDoorBad(x, y, z)
  local fighter = self.candidates[self.goon_type]:create(x, y, game.mainGroup, game.min_x, game.max_x, game.min_z, game.max_z, game.effects)
  fighter:setZ(z)
  fighter.target = player
  fighter.side = "bad"
  fighter:enable()
  fighter:enableAutomatic()
  fighter.yScale = 0.9
  animation.to(fighter, {yScale=1}, {time=300, easing=easing.linear})

  table.insert(game.fighters, fighter)

  fighter.fighters = game.fighters
  self.player.fighters = game.fighters

  self.time_since_last_bad = system.getTimer()
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
  
  local fighter = self.candidates[self.goon_type]:create(start_x, candidate.default_ground_target, game.mainGroup, game.min_x, game.max_x, game.min_z, game.max_z, game.effects)
  if dice > 33 then
    fighter:setZ(300)
  end
  fighter.target = player
  fighter.side = "bad"
  fighter:enable()

  table.insert(game.fighters, fighter)

  fighter.fighters = game.fighters
  self.player.fighters = game.fighters

  self.time_since_last_bad = system.getTimer()

  return fighter
end

function level:addWarren()
  game = self.game

  self.warren_has_appeared = true

  warren = self.candidates["warren"]:create(8100, candidate.default_ground_target, game.mainGroup, game.min_x, game.max_x, game.min_z, game.max_z, game.effects)
  warren.target = game.player
  warren.side = "bad"
  warren.xScale = -1

  table.insert(game.fighters, warren)

  warren.fighters = game.fighters
  self.player.fighters = game.fighters

  self.time_since_last_bad = system.getTimer()

  return warren
end

function level:checkLevel()

  if game.state ~= "leaving" and audio.isChannelPlaying(1) == false and audio.isChannelPlaying(2) == false then
    audio.play(self.stage_music, {channel=2, loops=-1})
  end

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

  print(audio.isChannelPlaying(2))
  -- check the hotel
  -- this only works if it comes before resetinput in the game loop
  if game.state == "active" and game.keydown.up == true and player.x > 11000 - 60 and player.x < 11000 + 60 and player.z < player.min_z + 5 then
    game.state = "leaving"
    for i = 1, #fighters do
      fighters[i]:disable()
    end
    animation.to(game.view, {alpha=0}, {time=2000, easing=easing.linear})
    audio.fadeOut({channel=2, time=2000})
    timer.performWithDelay(2000, function()
      -- audio.stop(2)
      -- audio.dispose(self.stage_music)
      game:gotoGame("smoke_filled_room")
    end)
  end

  -- check if the zone needs to be progressed
  if self.current_zone == 0
    or (zones[self.current_zone].type == "goons" and zones[self.current_zone].num <= 0 and num_active_bads == 0) 
    or (zones[self.current_zone].type == "shop" and player.x > zones[self.current_zone].max - 200) then
    self.current_zone = self.current_zone + 1
    self.time_since_last_bad = system.getTimer()
    
    -- here do the arrow effect
    if self.current_zone > 1 then
      if self.current_zone < #zones or player.x < 10600 then
        effects:addArrow(game.uiGroup, display.contentWidth - 64, display.contentCenterY, 128, 0, 3000)
      elseif self.current_zone == #zones and player.x > 11400 then
        effects:addArrow(game.uiGroup, 64, display.contentCenterY, 128, 180, 3000)
      elseif self.current_zone == #zones and player.x >= 10600 then
        effects:addArrow(game.uiGroup, display.contentCenterX, 64, 128, -90, 3000)
      end
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
    game.state = "pre_fight_2"
    timer.performWithDelay(1000, function()
      effects:addTemporaryText("THE RIVAL", display.contentCenterX, display.contentCenterY, 25, {0,0,0}, game.supertextGroup, 1000)
    end)
    timer.performWithDelay(1500, function()
      self.warren = self:addWarren() 
      player:disable()
      player.script_side = "left"
      self.warren.script_side = "right"
    end)
    timer.performWithDelay(2500, function()
      game.state = "pre_fight_3"
    end)

    timer.performWithDelay(3000, function() 

      script_end_time = scriptMaker:makeScript(
          effects,
          game.foregroundGroup,
          2000, -- default length
          500, -- default padding
          14, -- default font size
          {
            {name=self.warren, text="You said a woman could never be president!", padding=-250},
            {name=player, text="Bull!", length=1000, padding=500},
            {name=player, text="And you said you'd never take Super PAC money"},
            {name=self.warren, text="But you can't get the job done, Bernie"},
            {name=self.warren, text="So I have a plan to take your lane"},
            {name=self.warren, text="And step one is to mess you up."},
            {name=player, text="Fine, you want a childish playground fight?"},
            {name=player, text="We're on a playground.", length=1500},
            {name=player, text="Let's fight.", length=1500, padding=0},
          })
        timer.performWithDelay(script_end_time, function()
          player:enable()
          self.warren:enable()
          self.warren:enableAutomatic()
          zones[self.current_zone].num = 0
          game.state = "active"
          game.uiGroup.isVisible = true
        end)
    end)
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
    game.uiGroup.isVisible = false

    if player.x > self.warren.x then
      player.script_side = "right"
      self.warren.script_side = "left"
    end

    script_end_time = scriptMaker:makeScript(
          effects,
          game.foregroundGroup,
          2000, -- default length
          500, -- default padding
          14, -- default font size
          {
            {name=player, text="..."},
            {name=player, text="It's over, Liz."},
            {name=self.warren, text="Yeah, I know."},
            {name=self.warren, text="I don't have a plan for this. What now?"},
            {name=player, text="You want to be VP?"},
            {name=self.warren, text="What about AOC?"},
            {name=player, text="*She's* gonna be the first woman president."},
            {name=player, text="But you could be VP. How bout it?"},
            {name=player, text="And hey.", length=1000},
            {name=player, text="If I kick the bucket, you're president.", padding=1500},
            {name=self.warren, text="Hmm.", length=1000, action=function()
              self.warren:disable()
              self.warren.sprite:setFrame(1)
            end},
            {name=player, text="What say we kick Donald Trump in the nuts together?", font_size=12},
            {name=self.warren, text="I still have a plan for that."},
            {name=player, text="Okay, get to work on it.", padding=0, action=function() 
              self.warren:enable()
              self.warren.ground_target = 3000
              self.warren:jumpingAction()
              self.warren.y_vel = -10
            end},
          })
        timer.performWithDelay(script_end_time, function()
          game.state = "active"
          self.warren:disable()
          new_fighters = {}
          self.warren.side = "good"
          player:restingAction()
          player.target = nil
          self.warren.target = nil
          for i = 1, #fighters do
            if fighters[i] ~= self.warren then
              table.insert(new_fighters, fighters[i])
            end
          end
          game.fighters = new_fighters
          game.uiGroup.isVisible = true
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

  -- update in case we re-assigned earlier in this method
  fighters = game.fighters
  -- update min x for good guys, and max x for everyone and the camera
  self.player_furthest_x = math.max(self.player_furthest_x, player.x)
  for i = 1, #fighters do
    if fighters[i].side == "good" then
      fighters[i].min_x = math.min(10000, self.player_furthest_x - 1000)
    end
    fighters[i].max_x = zones[self.current_zone].max
  end
  camera.max_x = zones[self.current_zone].max - display.contentWidth - 200
  camera.min_x = self.player.min_x
end

function level:checkEnding()

end

return level