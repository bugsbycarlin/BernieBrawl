
local composer = require("composer")

local scene = composer.newScene()

local function gotoPostfight()
  composer.gotoScene("Source.Scenes.postfight", {effect = "fade", time = 1000})
  composer.removeScene("Source.Scenes.game")
end

local function gotoGameover()
  composer.gotoScene("Source.Scenes.gameover", {effect = "fade", time = 1000})
  composer.removeScene("Source.Scenes.game")
end

local function pause(event)
  composer.gotoScene("Source.Scenes.pause")
  paused = true

  return true
end

local healthBar = require("Source.Utilities.healthBar")
local snow = require("Source.Utilities.snow")

candidates = {}
candidates["warren"] = require("Source.Candidates.warren")
candidates["trump"] = require("Source.Candidates.trump")
candidates["biden"] = require("Source.Candidates.biden")

local state

local paused = false

local camera = {x = 0, y = 0, move = true, speed = 0.4}

local iowa_snow

local show_hitboxes

local sceneGroup
local bgGroup
local mainGroup
local uiGroup
local hitBoxGroup

local sky
local parallax_background
local background

local button_s
local button_1
local button_2
local button_pause

-- local button_p
-- local button_k
-- local button_b

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

local function gameLoop()
  if state == "active" then
    if fighters[1].health <= 0 or fighters[2].health <= 0 then
      state = "ending"
      for i = 1, #fighters do
        fighters[i]:disableAutomatic()
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

  for i = 1,2,1 do
    if (fighters[i].health < fighters[i].visibleHealth) then
      fighters[i].visibleHealth = fighters[i].visibleHealth - 1
      fighters[i].healthbar:setHealth(fighters[i].visibleHealth)
    end
  end

  checkPlayerActions()

  if show_hitboxes == true then
    showHitBoxes()
  end
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

  if event.keyName == "h" then
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
  show_hitboxes = false

  uiGroup = display.newGroup()
  sceneGroup:insert(uiGroup)

  iowa_stage_width = 1800
  min_x = display.contentCenterX - (iowa_stage_width / 2 - display.contentWidth / 2)
  max_x = display.contentCenterX + (iowa_stage_width / 2 - display.contentWidth / 2)

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

  local candidate = composer.getVariable( "candidate" )
  -- local opponent = composer.getVariable("opponent")
  local opponent = "biden"
  local location = composer.getVariable("location")

  fighters[1] = candidates[opponent]:create(384, display.contentCenterY, mainGroup, min_x, max_x)
  fighters[1].xScale = -1
  fighters[1].healthbar = healthBar:create(display.contentWidth - 240 - 10, 10, 0.8, uiGroup)

  fighters[2] = candidates[candidate]:create(184, display.contentCenterY, mainGroup, min_x, max_x)
  fighters[2].healthbar = healthBar:create(60, 10, 0.8, uiGroup)

  fighters[1].target = fighters[2]
  fighters[1].other_fighters = {fighters[2]}
  fighters[2].target = fighters[1]
  fighters[2].other_fighters = {fighters[1]}

  player = fighters[2]

  iowa_snow = snow:create(foregroundGroup)

  player_headshot = display.newImageRect(uiGroup, "Art/" .. candidate .. "_face.png", 50, 50)
  player_headshot.x = 27
  player_headshot.y = 27

  opponent_headshot = display.newImageRect(uiGroup, "Art/" .. opponent .. "_face.png", 50, 50)
  opponent_headshot.x = display.contentWidth - 27
  opponent_headshot.y = 27

  -- button_2 = display.newImageRect(uiGroup, "Art/button_2.png", 48, 48)
  -- button_2.x = display.contentWidth - 30
  -- button_2.y = display.contentHeight - 30

  -- button_1 = display.newImageRect(uiGroup, "Art/button_1.png", 48, 48)
  -- button_1.x = display.contentWidth - (30 + 50)
  -- button_1.y = display.contentHeight - 30

  -- button_s = display.newImageRect(uiGroup, "Art/button_s.png", 48, 48)
  -- button_s.x = display.contentWidth - (30 + 100)
  -- button_s.y = display.contentHeight - 30

  button_1 = display.newImageRect(uiGroup, "Art/button_p.png", 60, 60)
  button_1.x = display.contentWidth - 94
  button_1.y = display.contentHeight - 32

  button_2 = display.newImageRect(uiGroup, "Art/button_k.png", 60, 60)
  button_2.x = display.contentWidth - 32
  button_2.y = display.contentHeight - 32

  button_s = display.newImageRect(uiGroup, "Art/button_b.png", 60, 60)
  button_s.x = 32
  button_s.y = display.contentHeight - 32  

  button_pause = display.newImageRect(uiGroup, "Art/button_pause.png", 48, 48)
  button_pause.x = display.contentCenterX
  button_pause.y = 24  

  punch_sound = audio.loadSound("Sound/punch.wav")
  -- stage_music = audio.loadStream("Sound/test_music.mp3")

  button_2:addEventListener("tap", player_2_button)
  button_1:addEventListener("tap", player_1_button)
  button_s:addEventListener("tap", player_s_button)
  button_pause:addEventListener("tap", pause)
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
    -- backgroundAnimationTimer = timer.performWithDelay(500, backgroundAnimation, 0)
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
