
local composer = require("composer")

local scene = composer.newScene()

local function gotoGame()
  composer.gotoScene("Source.Scenes.gameIntermediary", {effect = "fade", time = 2000})
end

local function gotoPostfight()
  composer.removeScene("Source.Scenes.postfight")
  composer.gotoScene("Source.Scenes.postfight", {effect = "fade", time = 2000})
end

local function gotoGameover()
  composer.gotoScene("Source.Scenes.gameover", {effect = "fade", time = 2000})
end

local function pause(event)
  composer.gotoScene("Source.Scenes.pause")
  paused = true

  return true
end

local healthBar = require("Source.Utilities.healthBar")
local snow = require("Source.Utilities.snow")
local effects = require("Source.Utilities.effects")

candidates = {}
candidates["warren"] = require("Source.Candidates.warren")
candidates["trump"] = require("Source.Candidates.trump")
candidates["biden"] = require("Source.Candidates.biden")

local state

local paused = false

local camera = {
  x = 0,
  y = 0,
  move = true,
  speed = 0.4,
  min_x = 0,
  max_x = 0,
  min_y = 0,
  max_y = 0,
}

local iowa_snow
local effects_thingy

local show_hitboxes = false

local sceneGroup
local bgGroup
local mainGroup
local uiGroup
local hitBoxGroup

local sky
local parallax_background
local background

local announcement_text

local red_button
local green_button
local blue_button
local pause_button

local player_checkmark
local opponent_checkmark

local fighters = {}

local punch_sound

local physics = require( "physics" )
physics.start()

local player
local other_fighters

local function activateGame()
  for i = 1, #other_fighters do
    other_fighters[i]:enableAutomatic()
  end
  state = "active"
end


local function checkPlayerActions()
  if state ~= "active" then
    red_button.alpha = 0.5
    green_button.alpha = 0.5
    blue_button.alpha = 0.5
  elseif player.action ~= nil and player.action ~= "blocking" then
    red_button.alpha = 0.5
    green_button.alpha = 0.5
    if player.action ~= "jumping" then
      blue_button.alpha = 0.5
    else
      blue_button.alpha = 1.0
    end
  elseif player.action == "blocking" then
    red_button.alpha = 0.5
    green_button.alpha = 1.0
    blue_button.alpha = 1.0
  else
    red_button.alpha = 1.0
    green_button.alpha = 1.0
    blue_button.alpha = 1.0
  end
end

local function showHitBoxes()
  for i = hitBoxGroup.numChildren, 1, -1 do
    hitBoxGroup[i]:removeSelf()
    hitBoxGroup[1] = nil
  end
  for i = 1,2,1 do
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
    Runtime:removeEventListener("key", debugKeyboard)

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
        timer.performWithDelay(4000, gotoPostfight)
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
        timer.performWithDelay(4000, gotoGameover)
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

local function gameLoop()
  if state == "active" then
    checkEnding()
  end

  if camera.move then
    -- Calculate new camera position
    x = -1 * ((fighters[1].x + fighters[2].x) / 2.0 - display.contentCenterX)
    y = -1 * ((fighters[1].y - fighters[1].y_offset + fighters[2].y - fighters[2].y_offset) / 2.0 - display.contentCenterY)

    -- blend with old camera position
    if x >= camera.min_x and x <= camera.max_x then
      camera.x = camera.speed * x + (1 - camera.speed) * camera.x
    end
    if y >= camera.min_y and y <= camera.max_y then
      camera.y = camera.speed * y + (1 - camera.speed) * camera.y
    end

    -- assign to groups
    skyGroup.x = camera.x
    skyGroup.y = camera.y
    parallaxBackgroundGroup.x = 0.8 * display.contentCenterX + 0.2 * camera.x
    parallaxBackgroundGroup.y = camera.y
    mainGroup.x = camera.x
    mainGroup.y = camera.y
    -- hitBoxGroup.x = camera.x
    -- hitBoxGroup.y = camera.y
    bgGroup.x = camera.x
    bgGroup.y = camera.y
    foregroundGroup.x = camera.x
    foregroundGroup.y = camera.y
  end

  iowa_snow:update()
  effects_thingy:update()

  for i = 1, #fighters do
    if (fighters[i].health < fighters[i].visibleHealth - 5) then
      fighters[i].visibleHealth = 0.2 * fighters[i].health + 0.8 * fighters[i].visibleHealth
      fighters[i].healthbar:setHealth(fighters[i].visibleHealth)
    elseif (fighters[i].health < fighters[i].visibleHealth) then
      fighters[i].visibleHealth = fighters[i].visibleHealth - 1
      fighters[i].healthbar:setHealth(fighters[i].visibleHealth)
    end
  end

  checkPlayerActions()

  if show_hitboxes == true then
    showHitBoxes()
  end
end

local function player_blue_button(event)
  if state == "active" then
    player:kickingAction()
  end
end

local function player_green_button(event)
  if state == "active" then
    player:punchingAction()
  end
end

local function player_s_button(event)
  if state == "active" then
    player:specialAction()
  end
end

local function player_red_button(event)
  if state == "active" then
    if (event.phase == "began") and player.action == nil then
      if player.action == nil then
        player:blockingAction()
      end
    elseif (event.phase == "ended" or event.phase == "cancelled") then
      print("cancelled")
      if player.action == "blocking" then
        player:restingAction()
      end
    end
  end

  return true  -- Prevents touch propagation to underlying objects
end

local function debugKeyboard(event)
  if state ~= "active" then
    return
  end

  if event.keyName == "h" then
    if player.action == nil then
      player:blockingAction()
    end
  end
  if event.keyName == "j" then
    player_green_button(event)
  end
  if event.keyName == "k" then
    player_blue_button(event)
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

  skyGroup = display.newGroup()
  sceneGroup:insert(skyGroup)

  parallaxBackgroundGroup = display.newGroup()
  sceneGroup:insert(parallaxBackgroundGroup)

  bgGroup = display.newGroup()
  sceneGroup:insert(bgGroup)

  mainGroup = display.newGroup()
  sceneGroup:insert(mainGroup)

  foregroundGroup = display.newGroup()
  sceneGroup:insert(foregroundGroup)

  hitBoxGroup = display.newGroup()
  sceneGroup:insert(hitBoxGroup)

  uiGroup = display.newGroup()
  sceneGroup:insert(uiGroup)

  iowa_stage_width = 1800
  min_x = display.contentCenterX - (iowa_stage_width / 2 - display.contentWidth / 2)
  max_x = display.contentCenterX + (iowa_stage_width / 2 - display.contentWidth / 2)

  camera.min_x = min_x - 300
  camera.max_x = max_x + 300
  camera.min_y = 0
  camera.max_y = 150

  sky = display.newImageRect(skyGroup, "Art/iowa_sky.png", iowa_stage_width, 512)
  sky.x = display.contentCenterX
  sky.y = display.contentHeight
  sky.anchorY = 1

  parallax_background = display.newImageRect(parallaxBackgroundGroup, "Art/iowa_skyline.png", 2820, 405)
  parallax_background.x = display.contentCenterX
  parallax_background.y = display.contentHeight + 30
  parallax_background.anchorY = 1

  background = display.newImageRect(mainGroup, "Art/iowa_snow.png", iowa_stage_width, 512)
  background.x = display.contentCenterX
  background.y = display.contentHeight + 20
  background.anchorY = 1

  traffic_cone = display.newImageRect(foregroundGroup, "Art/traffic_cone.png", 128, 128)
  traffic_cone.x = background.x - 676
  traffic_cone.y = background.y - 52

  traffic_cone_2 = display.newImageRect(foregroundGroup, "Art/traffic_cone.png", 128, 128)
  traffic_cone_2.x = background.x + 698
  traffic_cone_2.y = background.y - 49

  effects_thingy = effects:create()

  local candidate = composer.getVariable("candidate")
  local opponent = composer.getVariable("opponent")
  -- local opponent = "biden"
  local location = composer.getVariable("location")

  fighters[1] = candidates[opponent]:create(384, display.contentCenterY, mainGroup, min_x, max_x, effects_thingy)
  fighters[1].xScale = -1
  fighters[1].healthbar = healthBar:create(display.contentWidth - 240 - 10, 10, 0.8, uiGroup)

  fighters[2] = candidates[candidate]:create(184, display.contentCenterY, mainGroup, min_x, max_x, effects_thingy)
  fighters[2].healthbar = healthBar:create(60, 10, 0.8, uiGroup)

  fighters[1].target = fighters[2]
  fighters[1].other_fighters = {fighters[2]}
  fighters[2].target = fighters[1]
  fighters[2].other_fighters = {fighters[1]}

  player = fighters[2]
  other_fighters = player.other_fighters

  iowa_snow = snow:create(foregroundGroup)

  player_headshot = display.newImageRect(uiGroup, "Art/" .. candidate .. "_face.png", 50, 50)
  player_headshot.x = 27
  player_headshot.y = 27

  opponent_headshot = display.newImageRect(uiGroup, "Art/" .. opponent .. "_face.png", 50, 50)
  opponent_headshot.x = display.contentWidth - 27
  opponent_headshot.y = 27

  player_wins = composer.getVariable("player_wins")
  opponent_wins = composer.getVariable("opponent_wins")
  round = composer.getVariable("round")

  player_checkmark = display.newImageRect( uiGroup, "Art/checkmark.png", 40, 40)
  player_checkmark.x = player_headshot.x - 5
  player_checkmark.y = player_headshot.y + 45
  player_checkmark.isVisible = (player_wins > 0)

  opponent_checkmark = display.newImageRect( uiGroup, "Art/checkmark.png", 40, 40)
  opponent_checkmark.x = opponent_headshot.x + 5
  opponent_checkmark.y = opponent_headshot.y + 45
  opponent_checkmark.isVisible = (opponent_wins > 0)

  announcement_text = display.newEmbossedText(uiGroup, "ROUND " .. round, display.contentCenterX, 70, "Georgia-Bold", 30)
  announcement_text:setTextColor(0.72, 0.18, 0.18)
  timer.performWithDelay(1500, function() announcement_text.text = "FIGHT!" end)
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

  blue_button:addEventListener("tap", player_blue_button)
  green_button:addEventListener("tap", player_green_button)
  -- red_button:addEventListener("tap", player_s_button)
  red_button:addEventListener("touch", player_red_button)
  pause_button:addEventListener("tap", pause)
  Runtime:addEventListener("touch", swipe)
  Runtime:addEventListener("key", debugKeyboard)

  state = "waiting"
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    gameLoopTimer = timer.performWithDelay( 33, gameLoop, 0 )
    -- backgroundAnimationTimer = timer.performWithDelay(500, backgroundAnimation, 0)
    fighters[1]:enable()
    fighters[2]:enable()
    timer.performWithDelay(2500, function() activateGame() end)
    -- audio.play( stage_music, { channel=1, loops=-1 } )

  elseif ( phase == "did" ) then
    composer.removeScene("Source.Scenes.prefight_alt")
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
