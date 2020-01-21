
local composer = require("composer")

local scene = composer.newScene()

local function gotoPostfight()
  composer.gotoScene("Source.Scenes.postfight", {effect = "fade", time = 1000})
end

local function gotoGameover()
  composer.gotoScene("Source.Scenes.gameover", {effect = "fade", time = 1000})
end

local HealthBar = require("Source.Utilities.healthBar")

local Warren = require("Source.Candidates.Warren")
local Trump = require("Source.Candidates.Trump")

local state

local camera = {x = 0, y = 0, move = true, speed = 0.4}

local sceneGroup
local bgGroup
local mainGroup
local uiGroup

local parallax_background
local background_1
local background_2
local foreground

local button_s
local button_1
local button_2

local fighters = {}

local punch_sound

local physics = require( "physics" )
physics.start()

local player

local function checkPlayerActions()
  if player.action ~= nil then
    button_s.alpha = 0.5
    button_1.alpha = 0.5
    if player.action ~= "jumping" then
      button_2.alpha = 0.5
    else
      button_2.alpha = 1.0
    end
  else
    button_s.alpha = 1.0
    button_1.alpha = 1.0
    button_2.alpha = 1.0
  end
end

local function gameLoop()
  if state == "active" then
    if fighters[1].health <= 0 or fighters[2].health <= 0 then
      state = "ending"
      for i = 1, #fighters do
        fighters[i]:disable()
      end
      if (player.health > 0) then
        timer.performWithDelay(4000, gotoPostfight)
      else
        timer.performWithDelay(4000, gotoGameover)
      end
      Runtime:removeEventListener("touch", swipe)
      Runtime:removeEventListener("key", debugKeyboard)
    end
  end

  if camera.move then
    -- Calculate new camera position
    x = -1 * ((fighters[1].x + fighters[2].x) / 2.0 - display.contentCenterX)
    y = -1 * ((fighters[1].y - fighters[1].y_offset + fighters[2].y - fighters[2].y_offset) / 2.0 - display.contentCenterY)

    -- blend with old camera position
    camera.x = camera.speed * x + (1 - camera.speed) * camera.x
    camera.y = camera.speed * y + (1 - camera.speed) * camera.y

    -- assign to groups
    parallaxBackgroundGroup.x = 0.8 * display.contentCenterX + 0.2 * camera.x
    parallaxBackgroundGroup.y = camera.y
    mainGroup.x = camera.x
    mainGroup.y = camera.y
    bgGroup.x = camera.x
    bgGroup.y = camera.y
    foregroundGroup.x = camera.x
    foregroundGroup.y = camera.y
  end


  for i = 1,2,1 do
    if (fighters[i].health < fighters[i].visibleHealth) then
      fighters[i].visibleHealth = fighters[i].visibleHealth - 1
      fighters[i].healthbar:setHealth(fighters[i].visibleHealth)
    end
  end

  checkPlayerActions()
end

local function player_2_button(event)
  player:kickingAction()
end

local function player_1_button(event)
  player:punchingAction()
end

local function player_s_button(event)
  player:specialAction()
end

local function debugKeyboard(event)
  if event.keyName == "j" then
    player_s_button(event)
  end
  if event.keyName == "k" then
    player_1_button(event)
  end
  if event.keyName == "l" then
    player_2_button(event)
  end
end


local swipe_event = {}
local function swipe(event)

  if (event.phase == "began") then
    -- Set touch focus on the fighter
    -- display.currentStage:setFocus( fighter )
    
    -- Store initial offset position
    swipe_event.initialX = event.x
    swipe_event.initialY = event.y
  elseif (event.phase == "moved") then
    -- nothing
  elseif (event.phase == "ended" or event.phase == "cancelled") then
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


local function backgroundAnimation()
  if (background_1.isVisible == true) then
    background_1.isVisible = false
    background_2.isVisible = true
  else
    background_1.isVisible = true
    background_2.isVisible = false
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
  sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  parallaxBackgroundGroup = display.newGroup()
  sceneGroup:insert(parallaxBackgroundGroup)

  bgGroup = display.newGroup()
  sceneGroup:insert(bgGroup)

  mainGroup = display.newGroup()
  sceneGroup:insert(mainGroup)

  foregroundGroup = display.newGroup()
  sceneGroup:insert(foregroundGroup)

  uiGroup = display.newGroup()
  sceneGroup:insert(uiGroup)

  parallax_background = display.newImageRect(parallaxBackgroundGroup, "Art/snow_parallax_background_pixelated.png", 1704, 753)
  parallax_background.x = display.contentCenterX
  parallax_background.y = display.contentHeight + 60
  parallax_background.anchorY = 1

  background_1 = display.newImageRect(mainGroup, "Art/snow_bg_1_pixelated.png", 1704, 753)
  background_1.x = display.contentCenterX
  background_1.y = display.contentHeight + 60
  background_1.anchorY = 1

  background_2 = display.newImageRect(mainGroup, "Art/snow_bg_2_pixelated.png", 1704, 753)
  background_2.x = display.contentCenterX
  background_2.y = display.contentHeight + 60
  background_2.anchorY = 1
  background_2.isVisible = false

  -- local foreground = display.newImageRect(foregroundGroup, "Art/snow_foreground_pixelated.png", 1704, 753)
  -- foreground.x = display.contentCenterX
  -- foreground.y = display.contentHeight + 40
  -- foreground.anchorY = 1

  fighters[1] = Trump:create(384, display.contentCenterY, mainGroup)
  fighters[1].xScale = -1
  fighters[1].healthbar = HealthBar:create(display.contentWidth - 240 - 10, 10, uiGroup)

  fighters[2] = Warren:create(184, display.contentCenterY, mainGroup)
  fighters[2].healthbar = HealthBar:create(10, 10, uiGroup)


  fighters[1].target = fighters[2]
  fighters[1].other_fighters = {fighters[2]}
  fighters[2].target = fighters[1]
  fighters[2].other_fighters = {fighters[1]}

  player = fighters[2]

  button_2 = display.newImageRect(uiGroup, "Art/button_2.png", 48, 48)
  button_2.x = display.contentWidth - 30
  button_2.y = display.contentHeight - 30

  button_1 = display.newImageRect(uiGroup, "Art/button_1.png", 48, 48)
  button_1.x = display.contentWidth - (30 + 50)
  button_1.y = display.contentHeight - 30

  button_s = display.newImageRect(uiGroup, "Art/button_s.png", 48, 48)
  button_s.x = display.contentWidth - (30 + 100)
  button_s.y = display.contentHeight - 30

  punch_sound = audio.loadSound("Sound/punch.wav")
  -- stage_music = audio.loadStream("Sound/test_music.mp3")

  button_2:addEventListener("tap", player_2_button)
  button_1:addEventListener("tap", player_1_button)
  button_s:addEventListener("tap", player_s_button)
  Runtime:addEventListener("touch", swipe)
  Runtime:addEventListener("key", debugKeyboard)

  state = "active"
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    gameLoopTimer = timer.performWithDelay( 33, gameLoop, 0 )
    -- trumpActionsTimer = timer.performWithDelay(600, trumpActions, 0)
    backgroundAnimationTimer = timer.performWithDelay(500, backgroundAnimation, 0)
    fighters[1]:enable()
    fighters[2]:enable()
    fighters[1]:enableAutomatic()
    -- audio.play( stage_music, { channel=1, loops=-1 } )

  elseif ( phase == "did" ) then
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
    composer.removeScene("game")
    timer.cancel(gameLoopTimer)
    timer.cancel(backgroundAnimationTimer)
    
  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
  audio.dispose(punch_sound)
  -- audio.dispose(stage_music)
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
