
local composer = require("composer")

local scene = composer.newScene()

local function gotoSelect()
  composer.gotoScene("Source.Scenes.select", {effect = "fade", time = 500})
end

local ScrollingText = require("Source.Utilities.scrollingText")

local opening_text_objects = {}

-- local titleText
-- local subtitleText

local animationTimer

opening_text_string_1 = {
  "     IT IS A DARK TIME FOR BLUE AMERICA",
  "",
  "Although the century has seen the first black",
  "president elected, the Republicans have driven",
  "the Democrats from the Whitehouse and pursued",
  "them across the land.",
}
opening_text_string_2 = {
  "But a new group of fighters is gathering.",
  "",
  "Though they share a common goal, there can be",
  "only one champion. In the snow covered wastes",
  "of Iowa, the fight begins."
}
opening_text_string_3 = {
  "ELECTION FIGHTER"
}


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  -- titleText = display.newEmbossedText(sceneGroup, "WHITEHOUSE RUMBLE", display.contentCenterX, display.contentCenterY, "Georgia-Bold", 30)
  -- titleText:setTextColor(0.18, 0.18, 0.72)
  -- titleText.alpha = 0

  -- subTitleText = display.newEmbossedText(sceneGroup, "VOTE WITH FISTS", display.contentCenterX, display.contentCenterY + 40, "Georgia-Bold", 24)
  -- subTitleText:setTextColor(0.72, 0.18, 0.18)

  opening_text_objects[1] = ScrollingText:create(
    40,
    display.contentCenterY - 60,
    0,
    sceneGroup,
    "Georgia-Bold",
    20,
    opening_text_string_1,
    22,
    2000,
    4000,
    4000,
    2000,
    {r=0.72, g=0.18, b=0.18})

  opening_text_objects[2] = ScrollingText:create(
    40,
    display.contentCenterY - 60,
    0,
    sceneGroup,
    "Georgia-Bold",
    20,
    opening_text_string_2,
    22,
    2000,
    4000,
    4000,
    2000,
    {r=0.9, g=0.9, b=0.9})

  opening_text_objects[3] = ScrollingText:create(
    display.contentCenterX,
    display.contentCenterY,
    0.5,
    sceneGroup,
    "Georgia-Bold",
    44,
    opening_text_string_3,
    22,
    2000,
    4000,
    4000,
    2000,
    {r=0.18, g=0.18, b=0.72})

  Runtime:addEventListener("tap", gotoSelect)
end

local startTime = 0
local function printTiming()
  elapsed = system.getTimer() - startTime
  print(elapsed)
end

-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    opening_text_objects[1]:start()
    startTime = system.getTimer()
    timer.performWithDelay(33, printTiming, 0)
    timer.performWithDelay(20000, function() opening_text_objects[2]:start() end)
    timer.performWithDelay(40000, function() opening_text_objects[3]:start() end)

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
