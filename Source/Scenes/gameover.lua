
local composer = require("composer")

local scene = composer.newScene()

local function gotoPrefight()
  composer.gotoScene("Source.Scenes.prefight", {effect = "fade", time = 1000})
end

local function gotoTitle()
  composer.gotoScene("Source.Scenes.title", {effect = "fade", time = 1000})
end

local gameoverText
local tryAgainText
local returnToTitleText

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  gameoverText = display.newText(sceneGroup, "GAME OVER", display.contentCenterX, display.contentCenterY - 60, "Georgia-Bold", 40)
  gameoverText:setTextColor(0.72, 0.18, 0.18)

  tryAgainText = display.newText(sceneGroup, "TRY AGAIN", display.contentCenterX, display.contentCenterY + 20, "Georgia-Bold", 30)
  tryAgainText:setTextColor(0.9, 0.9, 0.9)

  returnToTitleText = display.newText(sceneGroup, "RETURN TO TITLE", display.contentCenterX, display.contentCenterY + 60, "Georgia-Bold", 30)
  returnToTitleText:setTextColor(0.18, 0.18, 0.72)

end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    tryAgainText:addEventListener("touch", gotoPrefight)
    returnToTitleText:addEventListener("touch", gotoTitle)
  elseif ( phase == "did" ) then
    composer.removeScene("Source.Scenes.game")
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
    composer.removeScene("gameover")
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
