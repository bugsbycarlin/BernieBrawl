-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
 
-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )
 
-- Seed the random number generator
math.randomseed( os.time() )

-- Reserve channel 1 for background music
audio.reserveChannels( 1 )
-- Reduce the overall volume of the channel
volume = 0.5
audio.setVolume( volume)

music = false
local stage_music
stage_music = audio.loadStream("Sound/test_music.mp3")
-- audio.play( stage_music, { channel=1, loops=-1 } )

local function quick_setup(candidate, opponent)
  local names = {"warren", "sanders", "biden", "buttigieg", "yang", "bloomberg"}
  local locations = {"iowa", "new hampshire", "super tuesday", "nomination fight", "first debate", "second debate", "final battle"}
  composer.setVariable("candidate", candidate)
  local remaining_candidates = {}
  for i = 1, #names do
    if candidate ~= names[i] and opponent ~= names[i] then
      table.insert(remaining_candidates, names[i])
    end
  end
  composer.setVariable("opponent", opponent)
  composer.setVariable("remaining_candidates", remaining_candidates)
  location = table.remove(locations, 1)
  composer.setVariable("location", location)
  composer.setVariable("remaining_locations", locations)
  composer.setVariable("player_wins", 0)
  composer.setVariable("opponent_wins", 0)
  composer.setVariable("round", 1)
end

quick_setup("warren", "biden")

-- -- Go to the menu screen
-- composer.gotoScene("Source.Scenes.title", {effect = "fade", time = 2000})
-- composer.gotoScene("Source.Scenes.intro", {effect = "fade", time = 3000})
-- composer.gotoScene("Source.Scenes.select", {effect = "fade", time = 1000})
composer.gotoScene("Source.Scenes.prefight_alt", {effect = "fade", time = 1000})
-- composer.gotoScene("Source.Scenes.game")
-- composer.gotoScene("Source.Scenes.hitDetectionEditor")

