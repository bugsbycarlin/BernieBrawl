-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local gameplan = require("Source.Utilities.gameplan")
 
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

gameplan:setup()
gameplan:quick_setup("sanders", "suit")

-- -- Go to the menu screen
-- composer.gotoScene("Source.Scenes.intro", {effect = "fade", time = 2000})
-- composer.gotoScene("Source.Scenes.title", {effect = "fade", time = 2000})
-- composer.gotoScene("Source.Scenes.selection", {effect = "fade", time = 1000})
-- composer.gotoScene("Source.Scenes.flight")
-- composer.gotoScene("Source.Scenes.prefight", {effect = "fade", time = 1000})
composer.gotoScene("Source.Scenes.game")
-- composer.gotoScene("Source.Scenes.game", {effect = "fade", time = 2000})
-- composer.gotoScene("Source.Scenes.hitDetectionEditor")
-- composer.gotoScene("Source.Scenes.cutscene_alt")
-- composer.gotoScene("Source.Scenes.comic", {effect = "fade", time = 500})


