
local composer = require("composer")

local scene = composer.newScene()

local function gotoCutscene()
  composer.gotoScene("Source.Scenes.cutscene", {effect = "fade", time = 1000})
end

local postfight_placeholder

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  candidate = composer.getVariable( "candidate" )
  opponent = composer.getVariable("opponent")
  location = composer.getVariable("location")
  content = string.upper(candidate .. " defeats " .. opponent .. " in " .. location .. "!")
  local remaining_locations = composer.getVariable("remaining_locations")
  if #remaining_locations < 1 then
    content = string.upper(candidate .. " WINS THE WHITEHOUSE!")
  end
  postfight_placeholder = display.newText(sceneGroup, content, display.contentCenterX, display.contentCenterY, "Georgia-Bold", 20)
  postfight_placeholder:setTextColor(0.18, 0.18, 0.72)

  timer.performWithDelay(3000, gotoCutscene, 1)
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

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
    composer.removeScene("postfight")
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
