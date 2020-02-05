
local composer = require("composer")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function gotoPrefight()
  composer.setVariable("player_wins", 0)
  composer.setVariable("opponent_wins", 0)
  composer.setVariable("round", 1)
  composer.removeScene("Source.Scenes.game")
  composer.removeScene("Source.Scenes.prefight_alt")
  composer.removeScene("Source.Scenes.postfight_alt")
  composer.gotoScene("Source.Scenes.prefight", {effect = "fade", time = 1000})
end

local function gotoCredits()
  composer.gotoScene("Source.Scenes.credits", {effect = "fade", time = 1000})
end

local function choose_player(event)
  local candidate = composer.getVariable("candidate")
  local location = composer.getVariable("location")
  print(location)
  local remaining_candidates = composer.getVariable("remaining_candidates")
  local remaining_locations = composer.getVariable("remaining_locations")
  print(remaining_candidates[1])

  location = table.remove(remaining_locations, 1)
  composer.setVariable("location", location)
  composer.setVariable("remaining_locations", remaining_locations)

  local opponent = "trump"
  if #remaining_candidates >= 1 then
    opponent = table.remove(remaining_candidates, math.random(1, #remaining_candidates))
    -- remove all bonus figures; you don't have to fight them.
    if location == "nomination fight" then
      remaining_candidates = {}
      print(remaining_candidates[1])
    end
    composer.setVariable("remaining_candidates", remaining_candidates)
  end
  composer.setVariable("opponent", opponent)

  gotoPrefight()
end

local placeholder
local placeholder2

local background

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  background = display.newImageRect( sceneGroup, "Art/placeholder_cutscene.png", 568, 320)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  local remaining_locations = composer.getVariable("remaining_locations")
  
  if #remaining_locations >= 1 then
    placeholder = display.newText(sceneGroup, "I did not draw this.", display.contentCenterX, 30, "Georgia-Bold", 20)
    placeholder:setTextColor(0.18, 0.18, 0.72)

    placeholder = display.newText(sceneGroup, "Cutscene: Trump watches Fox News in his underwear.", 60, display.contentCenterY + 30, "Georgia-Bold", 20)
    placeholder:setTextColor(0.18, 0.18, 0.72)

    timer.performWithDelay(6000, choose_player, 1)
  else
    placeholder = display.newText(sceneGroup, "FINAL UNDERWEAR CUTSCENE", display.contentCenterX, 30, "Georgia-Bold", 30)
    placeholder:setTextColor(0.18, 0.18, 0.72)

    placeholder2 = display.newText(sceneGroup, "... UNTIL 2024?", display.contentCenterX, 60, "Georgia-Bold", 30)
    placeholder2:setTextColor(0.18, 0.18, 0.72)

    placeholder:addEventListener("touch", gotoCredits)
    timer.performWithDelay(6000, gotoCredits, 1)
  end
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
    composer.removeScene("cutscene")
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
