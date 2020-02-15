
local composer = require("composer")

local scene = composer.newScene()

local function gotoPrefight()
  -- audio.stop(1)
  -- audio.dispose(select_music)
  -- audio.play(punch_sound, {channel=4})
  composer.gotoScene("Source.Scenes.prefight", {effect = "fade", time = 1000})
end

local background
local plane
local icon
local location_name

local zoom = 1

local plane_sound = audio.loadSound("Sound/plane_sound.mp3")
local train_sound = audio.loadSound("Sound/train_sound.mp3")

targets = {
    {name="Iowa", x=887, y=435, icon="black_stone.png"},
    {name="New Hampshire", x=1442, y=265, icon="black_stone.png"},
    {name="Super Tuesday", x=486, y=526, icon="black_stone.png"},
    {name="The Convention", x=1030, y=384, icon="black_stone.png"},
    {name="VP Debate", x=411, y=498, icon="black_stone.png"},
    {name="First Debate", x=1079, y=427, icon="black_stone.png"},
    {name="Second Debate", x=1100, y=618, icon="black_stone.png"},
    {name="The White House", x=1363, y=453, icon="black_stone.png"},
}

local location_number

local animationTimer

local beat_number

origin = {x=1363*zoom, y=453*zoom}

camera = {x=0, y=0, speed=0.95}

local function animation()

  if beat_number == 1 then
    local target_x = (targets[location_number].x - origin.x) * zoom
    local target_y = (targets[location_number].y - origin.y) * zoom
    if camera.x ~= target_x then
      camera.x = camera.speed * camera.x + (1 - camera.speed) * target_x
    end
    if camera.y ~= target_y then
      camera.y = camera.speed * camera.y + (1 - camera.speed) * target_y
    end
    mainGroup.x = -origin.x * zoom + display.contentCenterX - camera.x
    mainGroup.y = -origin.y * zoom + display.contentCenterY - camera.y

    if math.abs(target_x - camera.x) < 6 then
      beat_number = 2
        timer.performWithDelay(200, gotoPrefight)
    end
  end

end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  mainGroup = display.newGroup()
  sceneGroup:insert(mainGroup)
  planeGroup = display.newGroup()
  sceneGroup:insert(planeGroup)

  location_number = composer.getVariable("location_number")

  if location_number > 1 then
    origin.x = targets[location_number - 1].x
    origin.y = targets[location_number - 1].y
  end

  background = display.newImageRect(mainGroup, "Art/selection_background.png", 1600, 1100)
  background.anchorX = 0
  background.anchorY = 0
  background.x = 0
  background.y = 0

  mainGroup.x = -origin.x * zoom + display.contentCenterX - camera.x
  mainGroup.y = -origin.y * zoom + display.contentCenterY - camera.y

  -- icon2 = display.newImageRect(mainGroup, "Art/corn.png", 64, 64)
  -- icon2.x = origin.x * zoom
  -- icon2.y = origin.y * zoom

  icon = display.newImageRect(mainGroup, "Art/" .. targets[location_number].icon, 16, 16)
  icon.x = targets[location_number].x * zoom
  icon.y = targets[location_number].y * zoom
  
  location_name = display.newText(mainGroup, string.upper(targets[location_number].name), icon.x, icon.y + 25, "Georgia-Bold", 25)
  location_name:setTextColor(1,1,1)

  if location_number == 4 then
    plane = display.newImageRect(planeGroup, "Art/train.png", 96, 48)
    camera.speed = 0.97
  else
    plane = display.newImageRect(planeGroup, "Art/plane.png", 96, 96)
  end
  plane.x = display.contentCenterX
  plane.y = display.contentCenterY
  local rotation = math.atan2(targets[location_number].x - origin.x, targets[location_number].y - origin.y) * 180 / 3.141592
  plane.rotation = 90 - rotation

  beat_number = 0
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    animationTimer = timer.performWithDelay(33, animation, 0)
    timer.performWithDelay(500, function()
      if location_number == 4 then
        audio.play(train_sound, {channel=4})
      else
        audio.play(plane_sound, {channel=4})
      end
      beat_number = 1
    end)
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
    timer.cancel(animationTimer)
    composer.removeScene("Source.Scenes.flight")
  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
  audio.dispose(plane_sound)
  audio.dispose(train_sound)
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
