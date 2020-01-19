
local composer = require("composer")

local scene = composer.newScene()

local function gotoSelect()
  composer.gotoScene("Source.Scenes.select", {effect = "fade", time = 500})
end

local ScrollingText = require("Source.Utilities.scrollingText")

local scroll

local titleText
local subtitleText

local animationTimer

opening_text = {
  "It is a dark time for America.",
  "Although the century has seen the",
  "first black president elected, Republicans",
  "have driven the Democrats from the",
  "Whitehouse and pursued them across the land.",
}

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  titleText = display.newEmbossedText(sceneGroup, "WHITEHOUSE RUMBLE", display.contentCenterX, display.contentCenterY, "Georgia-Bold", 30)
  titleText:setTextColor(0.18, 0.18, 0.72)

  -- subTitleText = display.newEmbossedText(sceneGroup, "VOTE WITH FISTS", display.contentCenterX, display.contentCenterY + 40, "Georgia-Bold", 24)
  -- subTitleText:setTextColor(0.72, 0.18, 0.18)

  scroll = ScrollingText:create(
    display.contentCenterX,
    display.contentCenterY + 40,
    sceneGroup,
    "Georgia-Bold",
    20,
    opening_text,
    22,
    1000,
    2000,
    1000,
    {r=0.72, g=0.18, b=0.18})

  Runtime:addEventListener("tap", gotoSelect)
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    scroll:start()
    -- animationTimer = timer.performWithDelay(30, scroll:animation(), 0)
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
    composer.removeScene("title")
    -- timer.cancel(animationTimer)
    Runtime:removeEventListener("tap", gotoSelect)
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
