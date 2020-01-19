
local composer = require( "composer" )

local scene = composer.newScene()

local function gotoTitle()
  composer.gotoScene( "title", {effect = "fade", time = 3000} )
end

local good
local game
local lab

local background

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  background = display.newImageRect( sceneGroup, "Art/goodgamelab.png", display.contentWidth, display.contentHeight)
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  background.alpha = 0.8


  good = display.newEmbossedText(sceneGroup, "GOOD", display.contentCenterX - 106, display.contentCenterY, "Georgia-Bold", 30)
  good:setTextColor(0.72, 0.18, 0.18)

  game = display.newEmbossedText(sceneGroup, "GAME", display.contentCenterX, display.contentCenterY, "Georgia-Bold", 30)
  game:setTextColor(0.9, 0.9, 0.9)

  lab = display.newEmbossedText(sceneGroup, "LAB", display.contentCenterX + 93, display.contentCenterY, "Georgia-Bold", 30)
  lab:setTextColor(0.18, 0.18, 0.72)
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    timer.performWithDelay(6000, gotoTitle, 1)
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
    composer.removeScene("intro")
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
