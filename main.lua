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

-- Master control volume for muting while debugging
master_volume = 1
-- Reserve channel 1 for background music
audio.reserveChannels(1)
audio.reserveChannels(1)
-- Reduce the overall volume of the channel
audio.setVolume(math.min(master_volume, 0.3), {channel=1})
audio.setVolume(math.min(master_volume, 0.3), {channel=2})
for i = 3,32 do
  audio.setVolume(math.min(master_volume, 1.0), { channel=i })
end

-- music = false
-- local stage_music
-- stage_music = audio.loadStream("Sound/test_music.mp3")
-- audio.play( stage_music, { channel=1, loops=-1 } )


local function setup()
  composer.setVariable("names", {"warren", "sanders", "biden", "buttigieg", "yang", "bloomberg"})
  composer.setVariable("nicknames", {
    warren="the planner",
    sanders="the populist",
    biden="the smiler",
    buttigieg="the polyglot",
    yang="the founder",
    bloomberg="the money"})
  composer.setVariable("selectable_names", {"biden", "sanders", "warren",})
  composer.setVariable("locations", {
    "Iowa Caucus",
    "New Hampshire Primary",
    "Super Tuesday",
    "Milwaukee Convention",
    "Salt Lake City VP Debate",
    "South Bend Debate",
    "Nashville Debate",
    "White House Battlegrounds"
  })
  composer.setVariable("location_number", 1)
end

local function quick_setup(candidate, opponent)
  composer.setVariable("candidate", candidate)
  local remaining_candidates = {}
  local names = composer.getVariable("names")
  local locations = composer.getVariable("locations")
  for i = 1, #names do
    if candidate ~= names[i] and opponent ~= names[i] then
      table.insert(remaining_candidates, names[i])
    end
  end
  composer.setVariable("opponent", opponent)
  composer.setVariable("remaining_candidates", remaining_candidates)
  location = table.remove(locations, 1)
  composer.setVariable("locations", locations)
  composer.setVariable("player_wins", 0)
  composer.setVariable("opponent_wins", 0)
  composer.setVariable("round", 1)
end

setup()
quick_setup("sanders", "trump")

-- -- Go to the menu screen
-- composer.gotoScene("Source.Scenes.intro", {effect = "fade", time = 2000})
composer.gotoScene("Source.Scenes.title", {effect = "fade", time = 2000})
-- composer.gotoScene("Source.Scenes.selection", {effect = "fade", time = 1000})
-- composer.gotoScene("Source.Scenes.flight")
-- composer.gotoScene("Source.Scenes.prefight", {effect = "fade", time = 1000})
-- composer.gotoScene("Source.Scenes.game")
-- composer.gotoScene("Source.Scenes.hitDetectionEditor")
-- composer.gotoScene("Source.Scenes.cutscene_alt")


