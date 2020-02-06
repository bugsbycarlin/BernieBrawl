
local composer = require("composer")

local scene = composer.newScene()

local effects_class = require("Source.Utilities.effects")

candidates = {}
candidates["warren"] = require("Source.Candidates.warren")
candidates["trump"] = require("Source.Candidates.trump")
candidates["biden"] = require("Source.Candidates.biden")
candidates["sanders"] = require("Source.Candidates.sanders")


number_sheet =
{
    frames = {
    
        { x=0, y=0, width=568, height=320,},
        { x=0, y=320, width=568, height=320,},
        { x=0, y=640, width=568, height=320,},
        { x=0, y=960, width=568, height=320,},
        { x=0, y=1280, width=568, height=320,},
        { x=0, y=1600, width=568, height=320,},
        { x=0, y=1920, width=568, height=320,},
        { x=0, y=2240, width=568, height=320,},
        { x=0, y=2560, width=568, height=320,},
        { x=0, y=2880, width=568, height=320,},

    },

    sheetContentWidth = 568,
    sheetContentHeight = 4096
}
local numbers = graphics.newImageSheet("Art/number_sheet.png", number_sheet)
local continue_numbers
local continue_text
local continue_group

local effects

local animationTimer

local beat_number

local start_time

local winning_fighter

local ko_fighter

local quip_text

local continue_text
local continue_count
local continue_time

--[[
  "put'cher hand down for a second bernie, okay?
  "just waving to you, joe"
]]--
-- https://www.brainyquote.com/authors/elizabeth-warren-quotes
quips = {
  warren = {
    "Nevertheless, She Persisted.",
    "Change is possible - if you fight for it!",
    "Americans are fighters!",
    "We can't go out and tell ourselves we've done good if we haven't!",
    "The middle class is getting hammered, and I'm here to hammer back!",
    "It's a simple idea. We all do better when we work together and invest in our future.",
    "If you don't have a seat at the table, you're probably on the menu.",
    "Keep a little space in your heart for the improbable. You won't regret it.",
  },
  biden = {
    "The measure of a man isn't how often he gets knocked down, but how quickly he gets up.",
    "I know I'm not supposed to like muscle cars, but I like muscle cars.",
  },
  sanders = {
    "There are no 'human' oppressors. oppressors have lost their humanity!",
    "Let us wage a moral and political war against war itself!",
    "When we stand together, we will always win!",
    "What the people want to see is not someone who can win every fight. They want to see him stand up and fight for what he believes.",
    "A crisis cannot be solved on the backs of the weak and vulnerable.",
    "Citizens in a democracy need diverse sources of news and information.",
    "A nation will not survive morally or economically when so few have so much and so many have so little.",
    "It's better to show up than to give.",
    "Difficult times often bring out the best in people."
  },
}

local function gotoCutscene()
  -- not ready until I have another fighter!
  -- composer.removeScene("Source.Scenes.game")
  -- composer.gotoScene("Source.Scenes.cutscene", {effect = "fade", time = 1000})
end

local function gotoPrefight()
  composer.setVariable("player_wins", 0)
  composer.setVariable("opponent_wins", 0)
  composer.setVariable("round", 1)
  composer.removeScene("Source.Scenes.game")
  composer.removeScene("Source.Scenes.prefight")
  composer.removeScene("Source.Scenes.postfight")
  composer.gotoScene("Source.Scenes.prefight", {effect = "fade", time = 1000})
end

local function gotoTitle()
  composer.gotoScene("Source.Scenes.title", {effect = "fade", time = 1000})
end

local function animation()

  effects:update()

  -- if beat_number == 1 then
  --   color_backdrop.x = color_backdrop.x + speed_line_min_x_vel
  -- elseif beat_number == 2 then
  --   if color_backdrop.x > display.contentCenterX then
  --     color_backdrop.x = color_backdrop.x - speed_line_min_x_vel
  --   else
  --     color_backdrop.x = display.contentCenterX
  --   end
  --   color_backdrop:setFillColor(red_color.r, red_color.g, red_color.b)
  -- elseif beat_number == 3 then
  --   color_backdrop.x = color_backdrop.x - speed_line_min_x_vel
  -- end

  winning_fighter:update()
  if continue_group.alpha > 0 then
    continue_group:update()
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  pictureGroup = display.newGroup()
  sceneGroup:insert(pictureGroup)
  backgroundGroup = display.newGroup()
  sceneGroup:insert(backgroundGroup)
  mainGroup = display.newGroup()
  sceneGroup:insert(mainGroup)
  foregroundGroup = display.newGroup()
  sceneGroup:insert(foregroundGroup)

  effects = effects_class:create()

  winning_fighter_name = composer.getVariable("winning_fighter")
  ko_location = composer.getVariable("ko_location")
  ko_fighter_name = composer.getVariable("ko_fighter")

  winning_fighter = display.newImageRect(pictureGroup, "Art/Cutouts/" .. winning_fighter_name .. "_dark_pixelated.png", 341, 227)
  winning_fighter.y = 120
  winning_fighter.alpha = 0
  winning_fighter:setFillColor(0.5, 0.5, 0.5)
  quip_text = display.newText(
    mainGroup,
    quips[winning_fighter_name][math.random(1, #quips[winning_fighter_name])],
    60, 130, 200, 200,
    "Georgia-Bold", 20)
  quip_text:setTextColor(0.3, 0.3, 0.4)
  quip_text.alpha = 0

  if (ko_location.x < display.contentCenterX) then
    winning_fighter.x = display.contentWidth - 120
    winning_fighter.side = "right"
    winning_fighter.xScale = -1
    quip_text.x = 120
  else
    winning_fighter.x = 120
    winning_fighter.side = "left"
    quip_text.x = display.contentWidth - 120
  end

  function winning_fighter:update()
    if self.alpha < 0.99 then
      quip_text.alpha = math.min(1, quip_text.alpha + 0.02)
      self.alpha = math.min(1, self.alpha + 0.02)
    end

    if self.side == "left" then
      self.x = self.x + 0.1
      if math.abs(self.xScale) < 1.3 then
        self.xScale = self.xScale + 0.001
        self.yScale = self.yScale + 0.001
      end
      self.rotation = self.rotation - 0.03
      quip_text.rotation = quip_text.rotation + 0.02
    elseif self.side == "right" then
      self.x = self.x - 0.1
      if math.abs(self.xScale) < 1.3 then
        self.xScale = self.xScale + 0.001
        self.yScale = self.yScale + 0.001
      end
      self.rotation = self.rotation + 0.03
      quip_text.rotation = quip_text.rotation - 0.02
    end
  end

  continue_count = 1000
  continue_group = display.newGroup()
  mainGroup:insert(continue_group)
  continue_group.alpha = 0
  continue_group.x = display.contentCenterX
  continue_group.y = display.contentCenterY
  continue_text = display.newImageRect(
    continue_group,
    "Art/continue.png",
    568, 320)
  -- continue_time = system.getTimer()
  continue_numbers = display.newSprite(continue_group, numbers, {frames={1,2,3,4,5,6,7,8,9,10}})
  continue_numbers.x = 160
  function continue_group:update()
    if continue_group.isVisible == true then
      continue_count = 10 - (system.getTimer() - continue_time) / 1000
      continue_numbers:setFrame(math.ceil(continue_count))
      continue_group.xScale = 0.95 + 0.1 * math.sin(2 * continue_count)
      continue_group.yScale = continue_group.xScale
      if continue_count <= 0 then
        gotoTitle()
      end
    end
  end
  continue_group:addEventListener("tap", gotoPrefight)

  print(ko_fighter_name)
  print(ko_location.y)
  ko_fighter = candidates[ko_fighter_name]:create(ko_location.x, ko_location.y, mainGroup, -1500, 1500, effects)
  ko_fighter.y = ko_fighter.y - ko_fighter.y_offset
  ko_fighter.xScale = ko_location.xScale
  ko_fighter.sprite:setFrame(ko_fighter.ko_frame)

  print(ko_fighter.y)

  if composer.getVariable("gameover") == false then
    timer.performWithDelay(6000, function() gotoCutscene() end)
  else
    -- gameover! count down.
    timer.performWithDelay(6000, function()
      print("Here yeah")
      continue_count = 10
      continue_time = system.getTimer()
      continue_group.alpha = 1
      continue_group:update()
    end)
  end

  -- ko_fighter.sprite.fill.effect = "filter.duotone"
  -- ko_fighter.sprite.fill.effect.darkColor = { blue_color.r / 3, blue_color.g / 3, blue_color.b / 3, 1 }
  -- ko_fighter.sprite.fill.effect.lightColor = { blue_color.r / 3, blue_color.r / 3, blue_color.r / 3, 1 }
  -- ko_fighter.sprite:setFillColor(blue_color.r / 3, blue_color.r / 3, blue_color.r / 3)

  -- timer.performWithDelay(3000, function() beat_number = 1 end)
  -- timer.performWithDelay(4000, function()
  --   red_fighter:forceMoveAction(-5, -45)
  --   beat_number = 2 
  --   for i = 1,20,1 do
  --     addRedSpeedLine(color_backdrop.y)
  --   end
  -- end)
  -- timer.performWithDelay(7000, function()
  --   beat_number = 3
  -- end)
  -- timer.performWithDelay(8000, function() gotoGame() end)
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    animationTimer = timer.performWithDelay(33, animation, 0)

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
    ko_fighter:disable()
    composer.removeScene("Source.Scenes.prefight")
  end
end


-- destroy()
function scene:destroy( event )

  -- Code here runs prior to the removal of scene's view
  if animationTimer ~= nil then
    timer.cancel(animationTimer)
  end
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
