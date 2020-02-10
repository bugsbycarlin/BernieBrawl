
local composer = require("composer")

local scene = composer.newScene()

local mainGroup

local comic

local animationTimer

local camera = {
  x = 0,
  y = 0,
  speed = 0.85, -- lower is much faster
}

local frame_width = 432
local frame_height = 320
local inset_width = 412
local inset_height = 300
local margin = (display.contentWidth - frame_width) / 2

local target_number = 1
local target_list = {
  {x=0, y=0, cx=margin, cy=0, frame="Art/comic_frame_1.png"},
  {x=frame_width, y=0, cx=frame_width + margin, cy=0, frame="Art/comic_frame_2.png"},
  {x=2 * frame_width, y=0, cx=2*frame_width + margin, cy=0, frame="Art/comic_frame_3.png"}
}

local frames = {}
local backing = {}

local function debugKeyboard(event)
  if event.keyName == "space" and event.phase == "up" then
    target_number = target_number + 1
  end

  if event.keyName == "left" and event.phase == "up" then
    target_number = target_number - 1
  end

  if event.keyName == "right" and event.phase == "up" then
    target_number = target_number + 1
  end

  if target_number < 1 then
    target_number = 1
  elseif target_number > #target_list then
    target_number = #target_list
  end
end

local function animationLoop()
  print("Animating")
  if target_number <= #target_list then
    local target = target_list[target_number]
    if camera.x ~= target.x then
      camera.x = camera.speed * camera.x + (1 - camera.speed) * target.x
    end
    if camera.y ~= target.y then
      camera.y = camera.speed * camera.y + (1 - camera.speed) * target.y
    end
  end
  for i = 1, #target_list do
    if i == target_number then
      frames[i].alpha = math.min(frames[i].alpha + 0.05, 1.0)
      backing[i].alpha = math.min(frames[i].alpha + 0.05, 1.0)
    else
      frames[i].alpha = math.max(frames[i].alpha - 0.05, 0.5)
      backing[i].alpha = math.max(frames[i].alpha - 0.05, 0.5)
    end
  end

  mainGroup.x = -1 * camera.x
  mainGroup.y = -1 * camera.y
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  -- display.setDefault("background", 1,1,1)
  local sceneGroup = self.view
 
  mainGroup = display.newGroup()
  sceneGroup:insert(mainGroup)

  -- comic = display.newImageRect(mainGroup, "Art/comic_template_1_by_3.png", 1744, 340)
  -- comic.anchorX = 0
  -- comic.anchorY = 0
  -- comic.x = 0
  -- comic.y = -10

  for i = 1,3,1 do
    backing[i] = display.newImageRect(mainGroup, "Art/white_backing.png", frame_width, frame_height)
    backing[i].anchorX = 0
    backing[i].anchorY = 0
    backing[i].x = target_list[i].cx
    backing[i].y = target_list[i].cy
    backing[i].alpha = 0.5

    frames[i] = display.newImageRect(mainGroup, target_list[i].frame, inset_width, inset_height)
    frames[i].anchorX = 0
    frames[i].anchorY = 0
    frames[i].x = target_list[i].cx + 10
    frames[i].y = target_list[i].cy + 10
    frames[i].alpha = 0.5
  end

  Runtime:addEventListener("key", debugKeyboard)
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    animationTimer = timer.performWithDelay(33, animationLoop, 0)
    
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
    timer.cancel(animationTimer)
  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view

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
