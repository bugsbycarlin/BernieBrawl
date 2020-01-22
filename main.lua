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

-- -- Go to the menu screen
-- composer.gotoScene("Source.Scenes.title", {effect = "fade", time = 2000})
-- composer.gotoScene("Source.Scenes.intro", {effect = "fade", time = 3000})
-- composer.gotoScene("Source.Scenes.select", {effect = "fade", time = 1000})
composer.gotoScene("Source.Scenes.game")
-- composer.gotoScene("Source.Scenes.hitDetectionEditor")