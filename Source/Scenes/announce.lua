
local composer = require("composer")

local scene = composer.newScene()

local AnnouncementSpriteInfo = {}

AnnouncementSpriteInfo =
{
    frames = {
    
        {
            -- frame_1
            x=0,
            y=0,
            width=248,
            height=143,

        },
        {
            -- frame_2
            x=0,
            y=143,
            width=248,
            height=143,

        },
        {
            -- frame_3
            x=0,
            y=286,
            width=248,
            height=143,

        },
        {
            -- frame_4
            x=0,
            y=429,
            width=248,
            height=143,

        },
        {
            -- frame_5
            x=0,
            y=572,
            width=248,
            height=143,

        },
    },

    sheetContentWidth = 248,
    sheetContentHeight = 715
}

local sheets = {}
sheets["buttigieg"] = graphics.newImageSheet("Art/buttigieg_announces_frames.png", AnnouncementSpriteInfo)
sheets["warren"] = graphics.newImageSheet("Art/warren_announces_frames.png", AnnouncementSpriteInfo)
sheets["sanders"] = graphics.newImageSheet("Art/sanders_announces_frames.png", AnnouncementSpriteInfo)
sheets["biden"] = graphics.newImageSheet("Art/biden_announces_frames.png", AnnouncementSpriteInfo)
sheets["bloomberg"] = graphics.newImageSheet("Art/bloomberg_announces_frames.png", AnnouncementSpriteInfo)
sheets["yang"] = graphics.newImageSheet("Art/yang_announces_frames.png", AnnouncementSpriteInfo)

local announcementText

local screenCrawl

-- local speeches = {}
-- speeches["warren"] = {"I'M NOT AFRAID OF ANYONE...", "", "PARTICULARLY NOT DONALD TRUMP!", "", ""}

local function gotoPrefight()
  composer.gotoScene("Source.Scenes.prefight")
end

local video
local sequence = {1, 1, 1, 2, 2, 3, 3, 3, 4, 5}
local sequence_value = 1
local animationTimer
local textTimer

local candidate

local function videoAnimation()
  sequence_value = sequence_value + 1
  if sequence_value <= #sequence then
    video:setFrame(sequence[sequence_value])
  else
    -- timer.cancel(textTimer)
    gotoPrefight()
  end
end

-- local function textAnimation()
--   if sequence_value <= #sequence and string.len(speechText.text) < string.len(speeches[candidate][sequence[sequence_value]]) then
--     speechText.text = string.sub(speeches[candidate][sequence[sequence_value]], 1, string.len(speechText.text) + 1)
--   end
--   if sequence_value <= #sequence and speeches[candidate][sequence[sequence_value]] == "" then
--     speechText.text = ""
--   end
-- end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Set up display groups
  videoGroup = display.newGroup()
  sceneGroup:insert( videoGroup )
  uiGroup = display.newGroup()
  sceneGroup:insert( uiGroup )

  candidate = composer.getVariable( "candidate" )
  video = display.newSprite(videoGroup, sheets[candidate], {frames={1,2,3,4,5}})
  video.x = display.contentCenterX
  video.y = display.contentCenterY
  video.xScale = 2.5
  video.yScale = 2.5

  screenCrawl = display.newImageRect( uiGroup, "Art/screen_crawl.png", 600, 30)
  screenCrawl.x = display.contentCenterX
  screenCrawl.y = display.contentHeight - 15

  announcementText = display.newText(uiGroup, "", display.contentCenterX, display.contentHeight - 15, "Georgia-Bold", 24)
  -- announcementText.anchorX = 0
  -- announcementText.anchorY = 0
  announcementText:setTextColor(1, 1, 1)
  announcementText.text = string.upper(candidate .. " announces candidacy")
  -- speechText.text = speeches[candidate][sequence_value]
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    animationTimer = timer.performWithDelay( 1000, videoAnimation, 0 )
    -- textTimer = timer.performWithDelay(30, textAnimation, 0)

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
    timer.cancel(animationTimer)

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen
    composer.removeScene("announce")
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
