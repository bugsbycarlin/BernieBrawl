
local composer = require("composer")

local scene = composer.newScene()

local pictures = {}
local name_texts = {}
local trash = {}

local vs_text
local location_text

local candidate
local opponent
local location

local animationTimer
local animationCounter = 0

local punch_sound

local function gotoGame()
  composer.gotoScene("Source.Scenes.game", {effect = "crossFade", time = 1500})
end

local function animation()
  -- counter
  animationCounter = animationCounter + 30
  
  -- shake
  local x_shake = math.random(-1,1)
  local y_shake = math.random(-1,1)
  if animationCounter < 300 then
    -- pass
  elseif animationCounter >= 300 and animationCounter < 900 then
    if pictures[1].isVisible == false then
      audio.play(punch_sound)
    end
    pictures[1].isVisible = true
    name_texts[1].isVisible = true
    
    pictures[1].x = 40 + x_shake
    pictures[1].y = display.contentCenterY + y_shake
    name_texts[1].x = 40 + x_shake
    name_texts[1].y = display.contentCenterY - 140 + y_shake
  elseif animationCounter >= 900 and animationCounter < 1500 then
    if vs_text.isVisible == false then
      audio.play(punch_sound)
    end
    vs_text.isVisible = true
    vs_text.x = display.contentCenterX + x_shake
    vs_text.y = display.contentCenterY + y_shake
  elseif animationCounter >= 1500 and animationCounter < 2100 then
    if pictures[2].isVisible == false then
      audio.play(punch_sound)
    end
    pictures[2].isVisible = true
    name_texts[2].isVisible = true
    
    pictures[2].x = display.contentWidth - 240 + x_shake
    pictures[2].y = display.contentCenterY + y_shake
    name_texts[2].x = display.contentWidth - 240 + x_shake
    name_texts[2].y = display.contentCenterY - 140 + y_shake
  elseif animationCounter >= 2100 and animationCounter < 3000 then
    if location_text.isVisible == false then
      audio.play(punch_sound)
    end
    location_text.isVisible = true
    location_text.x = display.contentCenterX + x_shake
    location_text.y = display.contentHeight - 30 + y_shake
  elseif animationCounter >= 3000 and animationCounter < 4500 then
    -- pass for now. later, add competing texts.
  else
    gotoGame()
  end

end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  mainGroup = display.newGroup()
  sceneGroup:insert( mainGroup )
  uiGroup = display.newGroup()
  sceneGroup:insert( uiGroup )

  candidate = composer.getVariable("candidate")
  opponent = composer.getVariable("opponent")
  location = composer.getVariable("location")

  pictures[1] = display.newImageRect( mainGroup, "Art/" .. candidate .. "_face.png", 200, 200 )
  pictures[1].x = 40
  pictures[1].y = display.contentCenterY
  pictures[1].anchorX = 1
  pictures[1].xScale = -1
  pictures[1].isVisible = false

  name_texts[1] = display.newEmbossedText(uiGroup, string.upper(candidate), 40, display.contentCenterY - 140, "Georgia-Bold", 30)
  name_texts[1].anchorX = 0
  name_texts[1].anchorY = 0
  name_texts[1]:setTextColor(0.72, 0.18, 0.18)
  name_texts[1].isVisible = false

  vs_text = display.newEmbossedText(uiGroup, "VS", display.contentCenterX, display.contentCenterY, "Georgia-Bold", 30)
  vs_text:setTextColor(0.72, 0.18, 0.18)
  vs_text.isVisible = false

  pictures[2] = display.newImageRect( mainGroup, "Art/" .. opponent .. "_face.png", 200, 200 )
  pictures[2].x = display.contentWidth - 240
  pictures[2].y = display.contentCenterY
  pictures[2].anchorX = 0
  pictures[2].xScale = 1
  pictures[2].isVisible = false

  name_texts[2] = display.newEmbossedText(uiGroup, string.upper(opponent), display.contentWidth - 240, display.contentCenterY - 140, "Georgia-Bold", 30)
  name_texts[2].anchorX = 0
  name_texts[2].anchorY = 0
  name_texts[2]:setTextColor(0.72, 0.18, 0.18)
  name_texts[2].isVisible = false

  location_text = display.newEmbossedText(uiGroup, string.upper(location), display.contentCenterX, display.contentHeight - 30, "Georgia-Bold", 30)
  location_text:setTextColor(0.72, 0.18, 0.18)
  location_text.isVisible = false

  punch_sound = audio.loadSound("Sound/punch.wav")
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    animationTimer = timer.performWithDelay(30, animation, 0)

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
    timer.cancel(animationTimer)

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen
    composer.removeScene("prefight")
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
