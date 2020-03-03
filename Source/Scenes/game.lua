
local composer = require("composer")

local scene = composer.newScene()

local function gotoGame()
  composer.gotoScene("Source.Scenes.gameIntermediary", {effect = "fade", time = 2000})
end

-- local function gotoPostfight()
--   composer.removeScene("Source.Scenes.postfight")
--   composer.gotoScene("Source.Scenes.postfight", {effect = "fade", time = 2000})
-- end

-- local function gotoGameover()
--   composer.gotoScene("Source.Scenes.gameover", {effect = "fade", time = 2000})
-- end

local function gotoPostfight()
  composer.removeScene("Source.Scenes.postfight")
  composer.gotoScene("Source.Scenes.postfight", {effect = "crossFade", time = 2000})
end

local function pause(event)
  composer.gotoScene("Source.Scenes.pause")
  paused = true

  return true
end

local healthBar = require("Source.Utilities.healthBar")
local snow = require("Source.Utilities.snow")
local effects = require("Source.Utilities.effects")

number_sheet =
{
    frames = {
    
        { x=0, y=0, width=568, height=320,},
        { x=0, y=320, width=568, height=320,},
        { x=0, y=640, width=568, height=320,},
        { x=0, y=960, width=568, height=320,},
        { x=0, y=1280, width=568, height=320,},
        { x=0, y=1600, width=568, height=320,},
        { x=0, y=1920, width=568, height=320,},
        { x=0, y=2240, width=568, height=320,},
        { x=0, y=2560, width=568, height=320,},
        { x=0, y=2880, width=568, height=320,},

    },

    sheetContentWidth = 568,
    sheetContentHeight = 4096
}
local numbers = graphics.newImageSheet("Art/number_sheet.png", number_sheet)

candidates = {}
candidates["warren"] = require("Source.Candidates.Warren")
candidates["trump"] = require("Source.Candidates.Trump")
candidates["biden"] = require("Source.Candidates.Biden")
candidates["sanders"] = require("Source.Candidates.Sanders")
candidates["bro"] = require("Source.Candidates.Bro")
candidates["suit"] = require("Source.Candidates.Suit")

local paused = false

local show_hitboxes = false

local keyboard_use = true

local state

local game_scale = 0.75

local min_x = 0
local max_x = 12000
local min_z = -90
local max_z = 100

local time_since_last_bad
local max_bads_at_once = 2
local warren_has_appeared = false

local camera = {
  x = 0,
  y = 0,
  move = true,
  speed = 0.2,
  min_x = 0,
  max_x = max_x - display.contentWidth - 200,
  min_y = -163,
  max_y = 0,
  target_center_x = display.contentCenterX,
  target_center_y = display.contentCenterY + 120,

  setToTarget = function(self, drift, object_x, object_y, reference, groups, parallax_values)
    diff_x = object_x - self.target_center_x
    diff_y = object_y - self.target_center_y

    if drift then
      -- blend with old camera position
      self.x = math.min(self.max_x, math.max(self.min_x, self.speed * diff_x + (1 - self.speed) * self.x))
      self.y = math.min(self.max_y, math.max(self.min_y, self.speed * diff_y + (1 - self.speed) * self.y))
    else
      -- set new camera position
      self.x = math.min(self.max_x, math.max(self.min_x, diff_x))
      self.y = math.min(self.max_y, math.max(self.min_y, diff_y))
    end

    -- assign to groups
    for i = 1,#groups do
      groups[i].x = -1 * parallax_values[i] * self.x
      groups[i].y = -1 * self.y
    end
  end,
}

-- your max_x is artificially set at the right side of the current zone.
-- your min_x is set at either 0, or your highest right value minus 1000.
-- min_x also won't go over 10,000, so you can always walk around the hotel area.
-- I don't want to have to worry about whether you can go back and revisit shops,
-- so they're intentionally set so that once you cross the next boundary, you
-- can't actually backtrack to them anyway.
-- camera maxes are also set to match.
local zones = {
  {min=0, max=1200, type="goons", num=4, pace=4000},
  {min=1200, max=2700, type="goons", num=5, pace=4000},
  {min=2700, max=4000, type="shop", num=0, arrow={x=2948, y=0}},
  {min=4000, max=5600, type="goons", num=5, pace=4000},
  {min=5600, max=7200, type="goons", num=5, pace=4000},
  {min=7200, max=8500, type="warren", num=5},
  {min=8500, max=10100, type="shop", num=0},
  {min=10100, max=12000, type="goons", num=8, pace=5000},
  {min=10100, max=12000, type="hotel", num=0},
}
local current_zone = 0
local player_furthest_x = 0
local time_since_last_bad = 0
-- 184
local player_starting_x = 184

local keydown = {
  left=false,
  right=false,
  up=false,
  down=false,
  a=false,
  s=false,
  d=false,
}

local keyup = {
  left=false,
  right=false,
  up=false,
  down=false,
}

local stage_music = audio.loadStream("Sound/robot_loop.mp3")

local iowa_snow
local effects_thingy

local sceneGroup
local contentGroup
local bgGroup
local mainGroup
local foregroundGroup
local shoppingGroup
local uiGroup
local hitBoxGroup

-- local sky
local parallax_background
local background

local announcement_text

local red_button
local green_button
local blue_button
local pause_button

local player_checkmark
local opponent_checkmark

local shop_selection = 0

local fighters = {}

local punch_sound

local physics = require( "physics" )
physics.start()

local player
local other_fighters

local function activateGame()
  for i = 1, #fighters do
    if fighters[i] ~= player then
      fighters[i]:enableAutomatic()
    end
  end
  state = "active"
end


local function checkPlayerActions()
  if state ~= "active" then
    if state == "ending" then
      red_button.alpha = 0.0
      green_button.alpha = 0.0
      blue_button.alpha = 0.0
      right_panel.alpha = 0.0
    else
      red_button.alpha = 0.5
      green_button.alpha = 0.5
      blue_button.alpha = 0.5
      right_panel.alpha = 0.5
    end
  elseif player.action ~= "resting" and player.action ~= "blocking" then
    red_button.alpha = 0.5
    green_button.alpha = 0.5
    if player.action ~= "jumping" then
      blue_button.alpha = 0.5
      right_panel.alpha = 0.5
    else
      blue_button.alpha = 1.0
      right_panel.alpha = 1.0
    end
  elseif player.action == "blocking" then
    red_button.alpha = 0.5
    green_button.alpha = 1.0
    blue_button.alpha = 1.0
    right_panel.alpha = 1.0
  else
    red_button.alpha = 1.0
    green_button.alpha = 1.0
    blue_button.alpha = 1.0
    right_panel.alpha = 1.0
  end
end

local function showHitBoxes()
  for i = hitBoxGroup.numChildren, 1, -1 do
    hitBoxGroup[i]:removeSelf()
    hitBoxGroup[1] = nil
  end
  for i = 1,#fighters do
    frame = fighters[i].sprite.frame
    -- if frame > #fighters[i].frames then
    --   frame = 1
    -- end
    local hitIndex = fighters[i].hitIndex[frame]
    -- if i == 2 then
    --   print(frame)
    -- end
    if hitIndex ~= nil and #hitIndex > 0 then
      for j = 1, #hitIndex do
        x,y = fighters[i]:localToContent(hitIndex[j].x, hitIndex[j].y)
        local circle = display.newCircle(hitBoxGroup, x, y, hitIndex[j].radius)
        circle.alpha = 0.5
        purpose = hitIndex[j].purpose
        if purpose == "attack" then
          circle:setFillColor( 0.8, 0.5, 0.5 )
        elseif purpose == "defense" then
          circle:setFillColor( 0.5, 0.5, 0.8 )
        elseif purpose == "vulnerability" then
          circle:setFillColor( 0.5, 0.8, 0.5 )
        end
      end
    end
  end
end

local function debugGrid()
  for x = 0, 12000, 50 do
    line = display.newLine(foregroundGroup, x, -400, x, 800)
    line:setStrokeColor(0.5, 0.5, 0.5, 0.5)
  end

  for y = -400, 800, 50 do
    line = display.newLine(foregroundGroup, 0, y, 12000, y)
    line:setStrokeColor(0.5, 0.5, 0.5, 0.5)
  end

  for x = 0, 12000, 200 do
    for y = -400, 800, 200 do
      text = display.newText(
        foregroundGroup,
        x .. "," .. y,
        x, y,
        "Georgia-Bold", 8)
      text.anchorX = 0
      text.anchorY = 0
      text:setTextColor(0.5, 0.5, 0.5)
      text.alpha = 0.5
    end
  end
end

local function addBad(val)

  local start_x = math.min(player.max_x + 180, player.x + 700)
  dice = math.random(1, 99)
  if dice > 80 then
    start_x = player.x - 700
  elseif dice > 40 then
    start_x = player.x + 300
  end
  if val ~= nil then
    start_x = val
  end
  
  local fighter = candidates[composer.getVariable("opponent")]:create(start_x, display.contentCenterY, mainGroup, min_x, max_x, min_z, max_z, effects_thingy)
  if dice > 33 then
    fighter:setZ(300)
  end
  fighter.target = player
  fighter.side = "bad"
  fighter.fighters = fighters
  fighter:enable()

  table.insert(fighters, fighter)

  time_since_last_bad = system.getTimer()

  return fighter
end

local function addWarren()
  warren_has_appeared = true

  local fighter = candidates["warren"]:create(8300, display.contentCenterY, mainGroup, min_x, max_x, min_z, max_z, effects_thingy)
  fighter.target = player
  fighter.side = "bad"
  fighter.fighters = fighters
  fighter:enable()

  table.insert(fighters, fighter)

  time_since_last_bad = system.getTimer()

  return fighter
end

local function checkZonesAndEnemies()

  -- remove dead bads from the stage
  local new_fighters = {}
  for i = 1, #fighters do
    fighter = fighters[i]
    if fighter ~= player and fighter.action == "blinking" and fighter.blinking_start_time ~= nil and system.getTimer() - fighter.blinking_start_time > 3000 then
      fighter:disable()
      display.remove(fighter)
    else
      table.insert(new_fighters, fighter)
    end
  end
  fighters = new_fighters
  for i = 1, #fighters do
    fighters[i].fighters = fighters
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
  if current_zone == 0
    or (zones[current_zone].type == "goons" and zones[current_zone].num <= 0 and num_active_bads == 0) 
    or (zones[current_zone].type == "warren" and num_bads == 0) 
    or (zones[current_zone].type == "shop" and player.x > zones[current_zone].max - 200) then
    current_zone = current_zone + 1
    time_since_last_bad = system.getTimer()
    if zones[current_zone].type == "goons" then
      print("Adding the special first goon for zone " .. current_zone .. " (which has type " .. zones[current_zone].type .. ")")
      fighter = addBad(math.max(zones[current_zone].min + 400, player.x + 700))
      fighter:enableAutomatic()
      zones[current_zone].num = zones[current_zone].num - 1
      num_active_bads = num_active_bads + 1
    end
    -- if current_zone == 1 then
    --   time_since_last_bad = system.getTimer() - zones[current_zone].pace
    -- end
    -- here do the arrow effect
    if current_zone > 1 then
      effects_thingy:addArrow(uiGroup, display.contentWidth - 64, display.contentCenterY, 128, 0, 3000)
      if zones[current_zone].arrow ~= nil then
        effects_thingy:addArrow(foregroundGroup, zones[current_zone].arrow.x, zones[current_zone].arrow.y, 64, 90, -1)
      end
    end
  end

  if current_zone > 0 then
    if zones[current_zone].type == "goons" 
      and (system.getTimer() - time_since_last_bad > zones[current_zone].pace or num_active_bads == 0)
      and zones[current_zone].num > 0
      and num_active_bads < max_bads_at_once then
      print("adding regular dude")
      fighter = addBad()
      fighter:enableAutomatic()
      zones[current_zone].num = zones[current_zone].num - 1
    end

    -- if the zone is warren, and warren has not appeared, add warren
    if zones[current_zone].type == "warren" and warren_has_appeared == false and player.x >= zones[current_zone].min + 200 then
      fighter = addWarren()
      fighter:enableAutomatic()
      zones[current_zone].num = 0
    end
  end

  -- update min x for good guys, and max x for everyone and the camera
  player_furthest_x = math.max(player_furthest_x, player.x)
  for i = 1, #fighters do
    if fighters[i].side == "good" then
      fighters[i].min_x = math.min(10000, player_furthest_x - 1000)
    end
    fighters[i].max_x = zones[current_zone].max
  end
  camera.max_x = zones[current_zone].max - display.contentWidth - 200
end

local function checkEnding()

  other_fighters_awake = false
  for i = 1, #other_fighters do
    if other_fighters[i].health > 0 then
      other_fighters_awake = true
    end
  end

  player_awake = (player.health > 0)

  if player_awake == false or other_fighters_awake == false then
    state = "ending"
    for i = 1, #fighters do
      fighters[i]:disableAutomatic()
    end

    Runtime:removeEventListener("touch", swipe)
    if keyboard_use == false then
      Runtime:removeEventListener("key", debugKeyboard)
    else
      Runtime:removeEventListener("key", properKeyboard)
    end

    player_wins = composer.getVariable("player_wins")
    opponent_wins = composer.getVariable("opponent_wins")
    round = composer.getVariable("round")

    round = round + 1

    if player_awake == true and other_fighters_awake == false then -- a win
      timer.performWithDelay(1000, function() player:celebratingAction() end)
      player_wins = player_wins + 1
      if player_wins > 1 then
        player_wins = 0
        opponent_wins = 0
        round = 1
        composer.setVariable("winning_fighter", player.short_name)
        composer.setVariable("ko_fighter", player.target.short_name)
        composer.setVariable("gameover", false)
        timer.performWithDelay(4000, function()
          ko_x, ko_y = player.target:localToContent(0,0)
          -- print("player victory")
          -- print(ko_x)
          -- print(ko_y)
          -- print(camera.x)
          -- print(camera.y)
          composer.setVariable("ko_location", {x=ko_x,y=ko_y, xScale=player.target.xScale})
          gotoPostfight()
        end)
      else
        timer.performWithDelay(4000, gotoGame)
      end
    elseif other_fighters_awake == true and player_awake == false then -- a loss
      for i = 1, #other_fighters do
        if other_fighters[i].health > 0 then
          timer.performWithDelay(1000, function() other_fighters[i]:celebratingAction() end)
        end
      end
      opponent_wins = opponent_wins + 1
      if opponent_wins > 1 then
        player_wins = 0
        opponent_wins = 0
        round = 1
        composer.setVariable("winning_fighter", player.target.short_name)
        composer.setVariable("ko_fighter", player.short_name)
        composer.setVariable("gameover", true)
        timer.performWithDelay(4000, function() 
          ko_x, ko_y = player:localToContent(0,0)
          -- print("opponent victory")
          -- print(ko_x)
          -- print(ko_y)
          -- print(camera.x)
          -- print(camera.y)
          composer.setVariable("ko_location", {x=ko_x,y=ko_y, xScale=player.xScale})
          gotoPostfight()
        end)
      else
        timer.performWithDelay(4000, gotoGame)
      end
    elseif player_awake == false and other_fighters_awake == false then -- a draw
      -- do something
      timer.performWithDelay(4000, gotoGame)
    end

    composer.setVariable("player_wins", player_wins)
    composer.setVariable("opponent_wins", opponent_wins)
    composer.setVariable("round", round)
  end
end

local key_history = {}
local function checkInput()

  if state == "active" and keydown.up and player.x > 2948 - 60 and player.x < 2948 + 60 and player.z < player.min_z + 5 then
    -- player.disable()
    shoppingGroup.isVisible = true
    state = "shopping"

  elseif state == "shopping" then

    -- blah
    if keydown.up then
      shop_selection = shop_selection - 1
      if shop_selection < 0 then
        shop_selection = 2
      end
    elseif keydown.down then
      shop_selection = shop_selection + 1
      if shop_selection > 2 then
        shop_selection = 0
      end
    end

    temporary_shop_selector.y = display.contentCenterY + 30 * shop_selection

    if keydown.enter and shop_selection == 2 then
      -- player.enable()
      shoppingGroup.isVisible = false
      shop_selection = 0
      state = "active"
    end
  elseif state == "active" then

    if keydown.left and keydown.up then
      table.insert(key_history, "left-up")
      player:moveAction(-1 * player.max_x_velocity * 0.7, -1 * player.max_y_velocity)
    elseif keydown.right and keydown.up then
      table.insert(key_history, "right-up")
      player:moveAction(player.max_x_velocity * 0.7, -1 * player.max_y_velocity)
    elseif keydown.up then
      table.insert(key_history, "up")
      -- player:moveAction(0, -1 * player.max_y_velocity)
      player:zMoveAction(-1 * player.max_z_velocity * 0.7)
    elseif keydown.down then
      table.insert(key_history, "down")
      player:zMoveAction(player.max_z_velocity * 0.7)
      -- player:moveAction(0, player.max_y_velocity)
    elseif keydown.left then
      table.insert(key_history, "left")
      player:moveAction(-1 * player.max_x_velocity * 0.7, 0)
    elseif keydown.right then
      table.insert(key_history, "right")
      player:moveAction(player.max_x_velocity * 0.7, 0)
    end

    if keydown.a == true and player.action == "resting" then
      table.insert(key_history, "a")
      player:blockingAction()
    elseif keydown.a == false and player.action == "blocking" then
      player:restingAction()
    end

    if keydown.s == true then
      table.insert(key_history, "s")
      if player.action == "resting" then
        player:punchingAction()
      elseif player.action == "jumping" then
        player:jumpAttackAction()
      end
    end

    if keydown.d == true then
      table.insert(key_history, "d")
      if player.action == "resting" then
        player:kickingAction()
      elseif player.action == "jumping" then
        player:jumpAttackAction()
      end
    end

    key_output = ""
    for i = 1,#key_history do
      key_output = key_output .. "," .. key_history[i]
    end
    -- print(key_output)
    -- print(key_history[#key_history - 2])

    if #key_history > 3 then
      if key_history[#key_history - 2] == "a" and key_history[#key_history - 1] == "d" and key_history[#key_history] == "up" then
        player:specialAction()
        key_history = {}
      end
    end

    if #key_history > 5 then
      new_key_history = {}
      for i = 2,#key_history do
        table.insert(new_key_history, key_history[i])
      end
      key_history = new_key_history
    end
  end

  keydown = {
    left=false,
    right=false,
    up=false,
    down=false,
    s=false,
    d=false,
    enter=false,
  }

  keyup = {
    left=false,
    right=false,
    up=false,
    down=false,
  }
end

local function gameLoop()
  if audio.isChannelPlaying(1) == false and audio.isChannelPlaying(2) == false then
    audio.play(stage_music, {channel=2, loops=-1})
  end

  if state == "active" or state == "shopping" then
    -- checkEnding()
    checkInput()
  end

  if state == "active" or state == "waiting" then
    checkZonesAndEnemies()
  end

  if camera.move then
    camera:setToTarget(true, player.x, player.y + player.z, contentGroup, {parallaxBackgroundGroup, mainGroup, bgGroup, foregroundGroup}, {0.2, 1,1,1})
  end

  iowa_snow:update()
  effects_thingy:update()

  -- print("Number of fighters is " .. #fighters)

  -- sort draw order for fighters
  -- todo: fix everything else in this list, effects, etc
  local display_objects = {}
  for i = 1, #fighters do
    table.insert(display_objects, fighters[i])
  end
  for i = 1, #effects_thingy.effect_list do
    item = effects_thingy.effect_list[i]
    if item.type == "projectile" then
      table.insert(display_objects, item.sprite)
    end
  end
  table.sort(display_objects,  
    function(a, b)
      return a.z < b.z
    end
  )
  for i = 1, #display_objects do
    mainGroup:insert(display_objects[i])
  end

  -- update health bars
  for i = 1, #fighters do
    if fighters[i].healthbar ~= nil then
      if (fighters[i].health < fighters[i].visible_health - 5) then
        fighters[i].visible_health = 0.2 * fighters[i].health + 0.8 * fighters[i].visible_health
        fighters[i].healthbar:setHealth(fighters[i].visible_health / fighters[i].max_health * 100)
      elseif (fighters[i].health < fighters[i].visible_health) then
        fighters[i].visible_health = fighters[i].visible_health - 1
        fighters[i].healthbar:setHealth(fighters[i].visible_health / fighters[i].max_health * 100)
      end
    end
  end

  -- to do: ditch bros from the fighters list, or recycle them

  checkPlayerActions()

  if show_hitboxes == true then
    showHitBoxes()
  end
end

local function player_blue_button(event)
  if state == "active" then
    player:kickingAction()
  end
  return true
end

local function player_green_button(event)
  if state == "active" then
    player:punchingAction()
  end
  return true
end

local function player_s_button(event)
  if event.phase == "began" and state == "active" then
    player:specialAction()
  end
  return true
end

local function player_red_button(event)
  if state == "active" then
    if (event.phase == "began") and player.action == "resting" then
      player:blockingAction()
    elseif (event.phase == "ended" or event.phase == "cancelled") then
      if player.action == "blocking" then
        player:restingAction()
      end
    end
  end

  return true  -- Prevents touch propagation to underlying objects
end

local function properKeyboard(event)
  if state ~= "active" and state ~= "shopping" then
    return
  end

  -- if event.keyName == "h" then
  --   if player.action == "resting" then
  --     player:blockingAction()
  --   end
  -- end
  -- if event.keyName == "j" then
  --   player_green_button(event)
  -- end
  -- if event.keyName == "k" then
  --   player_blue_button(event)
  -- end

  -- if event.keyName == "p" then
  --   composer.setVariable("player_wins", 1)
  --   player.target.health = 0
  -- end

  if event.keyName == "left" then
    if event.phase == "down" then
      keydown.left = true
    elseif event.phase == "up" then
      keydown.left = false
      keyup.left = true
    end
  end

  if event.keyName == "right" then
    if event.phase == "down" then
      keydown.right = true
    elseif event.phase == "up" then
      keydown.right = false
      keyup.right = true
    end
  end

  if event.keyName == "up" then
    if event.phase == "down" then
      keydown.up = true
    elseif event.phase == "up" then
      keydown.up = false
      keyup.up = true
    end
  end

  if event.keyName == "down" then
    if event.phase == "down" then
      keydown.down = true
    elseif event.phase == "up" then
      keydown.down = false
      keyup.down = true
    end
  end

  if event.keyName == "a" then
    if event.phase == "down" then
      keydown.a = true
    elseif event.phase == "up" then
      keydown.a = false
    end
  end

  if event.keyName == "s" then
    if event.phase == "down" then
      keydown.s = true
    elseif event.phase == "up" then
      keydown.s = false
    end
  end

  if event.keyName == "d" then
    if event.phase == "down" then
      keydown.d = true
    elseif event.phase == "up" then
      keydown.d = false
    end
  end

  if event.keyName == "enter" then
    if event.phase == "down" then
      keydown.enter = true
    elseif event.phase == "up" then
      keydown.enter = false
    end
  end

  if event.keyName == "x" and event.phase == "up" then
    if show_hitboxes == true then
      show_hitboxes = false
      hitBoxGroup.isVisible = false
    else
      show_hitboxes = true
      hitBoxGroup.isVisible = true
    end
  end

  return true
end

local function debugKeyboard(event)
  if state ~= "active" then
    return
  end

  if event.keyName == "h" then
    if player.action == "resting" then
      player:blockingAction()
    end
  end
  if event.keyName == "j" then
    player_green_button(event)
  end
  if event.keyName == "k" then
    player_blue_button(event)
  end

  if event.keyName == "p" then
    composer.setVariable("player_wins", 1)
    player.target.health = 0
  end


  if event.keyName == "x" and event.phase == "up" then
    if show_hitboxes == true then
      show_hitboxes = false
      hitBoxGroup.isVisible = false
    else
      show_hitboxes = true
      hitBoxGroup.isVisible = true
    end
  end

  return true
end

local swipe_event = {}
local function swipe(event)

  if state ~= "active" then
    return
  end

  if (event.phase == "began") then
    -- Set touch focus on the fighter
    -- display.currentStage:setFocus( fighter )
    
    -- Store initial offset position
    swipe_event.initialX = event.x
    swipe_event.initialY = event.y
  elseif (event.phase == "moved") then
    -- nothing
  elseif (event.phase == "ended" or event.phase == "cancelled") then
    -- -- if the block touch ended outside the blocking event, it still needs to be canceled
    -- if player.action == "blocking" then
    --   player:restingAction()
    -- end

    if (swipe_event.initialX == nil) then
      swipe_event.initialX = event.x
    end
    if (swipe_event.initialY == nil) then
      swipe_event.initialY = event.y
    end
    local touchOffsetX = (event.x - swipe_event.initialX) / 5
    local touchOffsetY = (event.y - swipe_event.initialY) / 1.5

    player:moveAction(touchOffsetX, touchOffsetY)

    -- Release touch focus on the fighter
    -- display.currentStage:setFocus( nil )
  end

  return true  -- Prevents touch propagation to underlying objects
end


-- local function backgroundAnimation()
--   if (background_1.isVisible == true) then
--     background_1.isVisible = false
--     background_2.isVisible = true
--   else
--     background_1.isVisible = true
--     background_2.isVisible = false
--   end
-- end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
  sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  contentGroup = display.newGroup()
  sceneGroup:insert(contentGroup)

  contentGroup.xScale = game_scale
  contentGroup.yScale = game_scale

  -- skyGroup = display.newGroup()
  -- contentGroup:insert(skyGroup)

  parallaxBackgroundGroup = display.newGroup()
  contentGroup:insert(parallaxBackgroundGroup)

  bgGroup = display.newGroup()
  contentGroup:insert(bgGroup)

  mainGroup = display.newGroup()
  contentGroup:insert(mainGroup)

  foregroundGroup = display.newGroup()
  contentGroup:insert(foregroundGroup)

  hitBoxGroup = display.newGroup()
  contentGroup:insert(hitBoxGroup)

  shoppingGroup = display.newGroup()
  sceneGroup:insert(shoppingGroup)
  shoppingGroup.isVisible = false

  uiGroup = display.newGroup()
  sceneGroup:insert(uiGroup)

  -- sky = display.newImageRect(skyGroup, "Art/iowa_sky.png", iowa_stage_width, 512)
  -- sky.x = display.contentCenterX
  -- sky.y = display.contentHeight
  -- sky.anchorY = 1

  parallax_background = display.newImageRect(parallaxBackgroundGroup, "Art/primary_parallax_background.png", 12000, 800)
  parallax_background.anchorX = 0
  parallax_background.x = 0
  -- parallax_background.x = display.contentCenterX
  parallax_background.anchorY = 1
  parallax_background.y = display.contentHeight / game_scale

  background = display.newImageRect(mainGroup, "Art/primary_background.png", 12000, 800)
  -- background.x = display.contentCenterX
  background.anchorX = 0
  background.x = 0
  -- background.y = display.contentHeight + 20
  background.anchorY = 1
  background.y = display.contentHeight / game_scale

  -- traffic_cone = display.newImageRect(foregroundGroup, "Art/traffic_cone.png", 128, 128)
  -- traffic_cone.x = background.x - 676
  -- traffic_cone.y = background.y - 52

  -- traffic_cone_2 = display.newImageRect(foregroundGroup, "Art/traffic_cone.png", 128, 128)
  -- traffic_cone_2.x = background.x + 698
  -- traffic_cone_2.y = background.y - 49

  temporary_shop = display.newImageRect(shoppingGroup, "Art/temporary_shop.png", 568, 320)
  temporary_shop.x = display.contentCenterX
  temporary_shop.y = display.contentCenterY

  temporary_shop_selector = display.newImageRect(shoppingGroup, "Art/temporary_shop_selector.png", 568, 320)
  temporary_shop_selector.x = display.contentCenterX
  temporary_shop_selector.y = display.contentCenterY


  effects_thingy = effects:create(sceneGroup)
  effects_thingy.fighters = fighters

  local candidate = composer.getVariable("candidate")
  local opponent = composer.getVariable("opponent")
  local location = composer.getVariable("location")


  player = candidates[candidate]:create(player_starting_x, display.contentCenterY, mainGroup, min_x, max_x, min_z, max_z, effects_thingy)
  player.healthbar = healthBar:create(60, 10, 0.8, uiGroup)
  player.shake_screen_on_contact = true
  player.fighters = fighters
  player.flexible_target = true
  player.side = "good"
  fighters[1] = player

  -- fighters[2] = candidates[opponent]:create(384, display.contentCenterY, mainGroup, min_x, max_x, min_z, max_z, effects_thingy)
  -- fighters[2].xScale = -1
  -- fighters[2].healthbar = healthBar:create(display.contentWidth - 240 - 10, 10, 0.8, uiGroup)

  -- fighters[1].target = fighters[2]
  -- fighters[1].fighters = fighters
  -- fighters[2].target = fighters[1]
  -- fighters[2].fighters = fighters

  other_fighters = {}

  iowa_snow = snow:create(foregroundGroup, 4000)

  player_headshot = display.newImageRect(uiGroup, "Art/" .. candidate .. "_face.png", 50, 50)
  player_headshot.x = 27
  player_headshot.y = 27
  player_headshot.xScale = -1

  -- opponent_headshot = display.newImageRect(uiGroup, "Art/" .. opponent .. "_face.png", 50, 50)
  -- opponent_headshot.x = display.contentWidth - 27
  -- opponent_headshot.y = 27

  player_wins = composer.getVariable("player_wins")
  opponent_wins = composer.getVariable("opponent_wins")
  round = composer.getVariable("round")

  player_checkmark = display.newImageRect( uiGroup, "Art/checkmark.png", 40, 40)
  player_checkmark.x = player_headshot.x - 5
  player_checkmark.y = player_headshot.y + 45
  player_checkmark.isVisible = (player_wins > 0)

  -- opponent_checkmark = display.newImageRect( uiGroup, "Art/checkmark.png", 40, 40)
  -- opponent_checkmark.x = opponent_headshot.x + 5
  -- opponent_checkmark.y = opponent_headshot.y + 45
  -- opponent_checkmark.isVisible = (opponent_wins > 0)

  announcement_text = display.newImageRect(uiGroup, "Art/round.png", 568/1.5, 320/1.5)
  announcement_text.x = display.contentCenterX + 30
  announcement_text.y = 80
  announcement_number = display.newSprite(uiGroup, numbers, {frames={1,2,3,4,5,6,7,8,9,10}})
  announcement_number:setFrame(round + 1)
  announcement_number.xScale = 1/1.5
  announcement_number.yScale = 1/1.5
  announcement_number.x = display.contentCenterX + 70
  announcement_number.y = 80
  timer.performWithDelay(1500, function()
    display.remove(announcement_text)
    display.remove(announcement_number)
    announcement_text = display.newImageRect(uiGroup, "Art/fight.png", 568/1.5, 320/1.5)
    announcement_text.x = display.contentCenterX
    announcement_text.y = 80
  end)
  timer.performWithDelay(2500, function() announcement_text.isVisible = false end)


  right_panel = display.newImageRect(uiGroup, "Art/right_panel.png", 116, 58)
  right_panel.x = display.contentWidth - 58
  right_panel.y = display.contentHeight - 29

  green_button = display.newImageRect(uiGroup, "Art/green_button.png", 54, 54)
  green_button.x = display.contentWidth - 86
  green_button.y = display.contentHeight - 28

  blue_button = display.newImageRect(uiGroup, "Art/blue_button.png", 54, 54)
  blue_button.x = display.contentWidth - 30
  blue_button.y = display.contentHeight - 28

  red_button = display.newImageRect(uiGroup, "Art/red_button.png", 54, 54)
  red_button.x = 32
  red_button.y = display.contentHeight - 32  

  pause_button = display.newImageRect(uiGroup, "Art/pause_button.png", 48, 48)
  pause_button.x = display.contentCenterX
  pause_button.y = 24

  punch_sound = audio.loadSound("Sound/punch.wav")
  -- stage_music = audio.loadStream("Sound/test_music.mp3")

  blue_button:addEventListener("touch", player_blue_button)
  green_button:addEventListener("touch", player_green_button)
  -- red_button:addEventListener("tap", player_s_button)
  red_button:addEventListener("touch", player_red_button)
  pause_button:addEventListener("tap", pause)
  Runtime:addEventListener("touch", swipe)
  if keyboard_use == false then
    Runtime:addEventListener("key", debugKeyboard)
  else
    Runtime:addEventListener("key", properKeyboard)
  end

  camera:setToTarget(false, player.x, player.y + player.z, contentGroup, {parallaxBackgroundGroup, mainGroup, bgGroup, foregroundGroup}, {0.2, 1,1,1})

  -- debugGrid()

  state = "waiting"
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    gameLoopTimer = timer.performWithDelay(33, gameLoop, 0)
    -- backgroundAnimationTimer = timer.performWithDelay(500, backgroundAnimation, 0)
    player:enable()
    -- addBad()
    -- fighters[2]:enable()
    timer.performWithDelay(2500, function() activateGame() end)

  elseif ( phase == "did" ) then
    composer.removeScene("Source.Scenes.prefight")
    -- audio.play(stage_music, { channel=3, loops=1 })
    -- Code here runs when the scene is entirely on screen

  end
end


-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen
    timer.cancel(gameLoopTimer)
    for i = 1, #fighters do
      fighters[i]:disable()
    end
    -- audio.stop(3)
    -- audio.dispose(stage_music)

  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
  if gameLoopTimer ~= nil then
    timer.cancel(gameLoopTimer)
  end
  for i = 1, #fighters do
    fighters[i]:disable()
  end
  audio.dispose(punch_sound)
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
