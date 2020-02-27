
local composer = require("composer")
local animation = require("plugin.animation")

local scene = composer.newScene()

local effects_class = require("Source.Utilities.effects")

candidates = {}
candidates["warren"] = require("Source.Candidates.Warren")
candidates["trump"] = require("Source.Candidates.Trump")
candidates["biden"] = require("Source.Candidates.Biden")
candidates["sanders"] = require("Source.Candidates.Sanders")

local effects

local backgroundGroup
local fightGroup
local titleGroup
local foregroundGroup

local title_music = audio.loadStream("Sound/intro_sound_alt.mp3")
local thunder_sound = audio.loadStream("Sound/intro_thunder.mp3")

local animationTimer

local speed_line_width = 800
local max_speed_lines = 100
local speed_line_backdrop_height = 180
local speed_line_min_height = 1
local speed_line_max_height = 15
local speed_line_min_x_vel = 60
local speed_line_max_x_vel = 80
local speed_line_center = 120

local blue_color = {r=106/255, g=175/255, b=226/255}
local red_color = {r=224/255, g=29/255, b=39/255}
local white_color = {r=1, g=1, b=1}
local colors = {red_color, white_color, blue_color}

local beat_number

local start_time

local satire
local white_screen
local title_card
local press_start

local blue_slash
local blue_fighter
local blue_cutout_1
local blue_cutout_2

local white_slash
local white_fighter
local white_cutout_1

local red_slash
local red_fighter
local red_cutout_1

local yellow_slash
local yellow_fighter
local yellow_cutout_1

local grey_slash
local grey_fighter
local grey_cutout_1
local grey_cutout_2
local white_background

local purple_slash
local purple_fighter
local purple_cutout_1

local black_cutout
local orange_background

local false_trump
local trump

local grey_tone = 1

local function gotoSelection()
  audio.stop(1)
  Runtime:removeEventListener("key", keyboard)
  composer.gotoScene("Source.Scenes.selection")
end

local function gotoQuickTitle()
  audio.stop(1)
  Runtime:removeEventListener("key", keyboard)
  composer.gotoScene("Source.Scenes.quick_title")
end

local timerTable

local function addSpeedLine(color, direction, y)
  height = math.random(speed_line_min_height, speed_line_max_height)
  x_vel = math.random(speed_line_min_x_vel, speed_line_max_x_vel)
  color_tint = math.random(8, 12) / 10
  speed_line = display.newImageRect(backgroundGroup, "Art/block.png", speed_line_width, height)
  if direction > 0 then
    speed_line.x = -1 * speed_line_width / 2 - 200 + math.random(1, 200)
  else
    speed_line.x = display.contentWidth + speed_line_width / 2 + 200 - math.random(1, 200)
  end
  speed_line.y = y - speed_line_backdrop_height/2 + math.random(speed_line_backdrop_height)
  if speed_line.y + height / 2 > y + speed_line_backdrop_height / 2 then
    speed_line.y = y + speed_line_backdrop_height / 2 - height / 2 - 1
  end
  if speed_line.y - height / 2 < y - speed_line_backdrop_height / 2 then
    speed_line.y = y - speed_line_backdrop_height / 2 + height / 2 + 1
  end
  speed_line.x_vel = x_vel
  new_color = {
    r = math.min(color.r * color_tint, 1),
    g = math.min(color.g * color_tint, 1),
    b = math.min(color.b * color_tint, 1),
  }
  speed_line:setFillColor(new_color.r, new_color.g, new_color.b)
  function speed_line:update()
    if direction > 0 then
      self.x = self.x + self.x_vel
    else
      self.x = self.x - self.x_vel
    end
  end
  function speed_line:finished()
    if direction > 0 then
      return (self.x - speed_line_width / 2 > display.contentWidth)
    else
      return (self.x + speed_line_width / 2 < 0)
    end
  end

  effects:add(speed_line)
end

local function addRandomSpeedLine()
  direction = 1
  if math.random(1,1000) > 500 then
    direction = -1
  end
  addSpeedLine(colors[math.random(1,3)], direction, speed_line_center)
end

local twit_frames = {34, 34, 34, 34, 35, 35,}
local twit_frame_number = 1
local function animationFunction()
  effects:update()

  if beat_number == 0 then
    false_trump.sprite:setFrame(twit_frames[twit_frame_number])
    twit_frame_number = twit_frame_number + 1
    if twit_frame_number > #twit_frames then
      twit_frame_number = 1
    end
  end

  if beat_number > 0 and beat_number < 10 then
    satire.alpha = math.max(0, satire.alpha - 0.04)
    if satire.alpha == 0 then
      satire.isVisible = false
    end
  end

  if beat_number == 0 then
    -- trump.alpha = math.min(1, trump.alpha + 0.02)
  end

  if beat_number == 10 then
    addRandomSpeedLine()
    white_screen.alpha = white_screen.alpha * 0.9
    if white_screen.alpha < 0.2 then
      white_screen.isVisible = false
    end
  elseif beat_number == 11 then
  elseif beat_number == 12 then
    press_start.alpha = math.min(1, press_start.alpha + 0.1)
  end
end

local function immediateTitleCard(event)
  if beat_number >= 10 then
    return
  end
  for i = 1, #timerTable do
    timer.cancel(timerTable[i])
  end
  Runtime:removeEventListener("key", keyboard)
  Runtime:removeEventListener("tap", immediateTitleCard)
  gotoQuickTitle()
end

local function keyboard(event)
  if event.keyName == "enter" and event.phase == "up" then
    if beat_number < 10 then
      immediateTitleCard()
      beat_number = 10
    elseif beat_number < 20 then
      gotoSelection()
      beat_number = 50
    end
  end

  return true
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  backgroundGroup = display.newGroup()
  sceneGroup:insert(backgroundGroup)
  fightGroup = display.newGroup()
  sceneGroup:insert(fightGroup)
  titleGroup = display.newGroup()
  sceneGroup:insert(titleGroup)
  foregroundGroup = display.newGroup()
  sceneGroup:insert(foregroundGroup)

  satire = display.newText(fightGroup, "this is satire", display.contentCenterX, display.contentCenterY + 100, "Georgia-Bold", 20)
  satire:setTextColor(1,1,1)

  white_screen = display.newImageRect(titleGroup, "Art/white_screen.png", 1024, 1024)
  white_screen.x = display.contentCenterX
  white_screen.y = display.contentCenterY
  white_screen.alpha = 0

  white_background = display.newImageRect(backgroundGroup, "Art/white_screen.png", 1024, 1024)
  white_background.x = display.contentCenterX
  white_background.y = display.contentCenterY
  white_background.isVisible = false

  title_card = display.newImageRect(titleGroup, "Art/title_card.png", 568, 320)
  title_card.x = display.contentCenterX
  title_card.y = display.contentCenterY
  title_card.isVisible = false

  press_start = display.newImageRect(titleGroup, "Art/press_start.png", 568, 320)
  press_start.x = display.contentCenterX
  press_start.y = display.contentCenterY
  press_start.isVisible = false

  blue_slash = display.newImageRect(fightGroup, "Art/blue_slash.png", 800, 500)
  blue_slash.x = -400
  blue_slash.y = display.contentCenterY
  blue_slash.isVisible = false

  blue_cutout_1 = display.newImageRect(fightGroup, "Art/Cutouts/biden_all_black.png", 750 / 2, 562 / 2)
  blue_cutout_1.xScale = -1
  blue_cutout_1.x = 80
  blue_cutout_1.y = display.contentCenterY

  blue_fighter = candidates["biden"]:create(-400, display.contentCenterY - 30, fightGroup, -2500, 2500, -100, 100, effects)
  blue_fighter.xScale = 0.7
  blue_fighter.yScale = 0.7
  blue_fighter.ground_target = blue_fighter.y
  blue_fighter.sprite:setFrame(34)
  blue_fighter.isVisible = false
  blue_fighter.sprite:setFillColor(0, 0, 0)

  white_cutout_1 = display.newImageRect(fightGroup, "Art/Cutouts/sanders_black_and_white.png", 800, 500)
  white_cutout_1.x = display.contentCenterX
  white_cutout_1.y = display.contentCenterY
  white_cutout_1.isVisible = false

  white_slash = display.newImageRect(fightGroup, "Art/white_slash.png", 800, 500)
  white_slash.x = display.contentWidth + 400
  white_slash.y = display.contentCenterY
  white_slash.isVisible = false

  white_fighter = candidates["sanders"]:create(display.contentWidth + 400, display.contentCenterY - 30, fightGroup, -2500, 2500, -100, 100, effects)
  white_fighter.xScale = -0.7
  white_fighter.yScale = 0.7
  white_fighter.ground_target = white_fighter.y
  white_fighter.sprite:setFrame(20)
  white_fighter.isVisible = false
  white_fighter.sprite:setFillColor(0, 0, 0)

  red_cutout_1 = display.newImageRect(fightGroup, "Art/Cutouts/warren_red_pixelated.png", 341, 227)
  red_cutout_1.x = 40
  red_cutout_1.y = display.contentCenterY + 40
  red_cutout_1.isVisible = false
  red_cutout_1.xScale = 0
  red_cutout_1.yScale = 0
  red_cutout_1:setFillColor(0.7, 0.2, 0.2)

  red_slash = display.newImageRect(fightGroup, "Art/alt_red_slash.png", 800, 500)
  red_slash.x = -400
  red_slash.y = display.contentCenterY
  red_slash.isVisible = false

  red_fighter = candidates["warren"]:create(-400, display.contentCenterY - 30, fightGroup, -2500, 2500, -100, 100, effects)
  red_fighter.xScale = 0.7
  red_fighter.yScale = 0.7
  red_fighter.ground_target = red_fighter.y
  red_fighter.sprite:setFrame(11)
  red_fighter.isVisible = false
  red_fighter.sprite:setFillColor(0, 0, 0)

  yellow_slash = display.newImageRect(fightGroup, "Art/yellow_slash.png", 800, 500)
  yellow_slash.x = display.contentCenterX
  yellow_slash.y = display.contentCenterY + 500
  yellow_slash.isVisible = false

  yellow_fighter = candidates["biden"]:create(190, display.contentCenterY + 400, fightGroup, -2500, 2500, -100, 100, effects)
  yellow_fighter.xScale = -0.7
  yellow_fighter.yScale = 0.7
  yellow_fighter.ground_target = yellow_fighter.y
  yellow_fighter.sprite:setFrame(31)
  yellow_fighter.isVisible = false
  yellow_fighter.sprite:setFillColor(0, 0, 0)

  yellow_cutout_1 = display.newImageRect(fightGroup, "Art/Cutouts/buttigieg_yellow.png", 295, 244)
  yellow_cutout_1.x = display.contentWidth - 160
  yellow_cutout_1.y = display.contentCenterY
  yellow_cutout_1.isVisible = false

  grey_fighter = candidates["sanders"]:create(display.contentCenterX - 50, display.contentCenterY - 30, fightGroup, -2500, 2500, -100, 100, effects)
  grey_fighter.xScale = 0.7
  grey_fighter.yScale = 0.7
  grey_fighter.ground_target = grey_fighter.y
  grey_fighter.sprite:setFrame(19)
  grey_fighter.isVisible = false
  grey_fighter.sprite.fill.effect = "filter.duotone"
  grey_fighter.sprite.fill.effect.darkColor = {grey_tone, grey_tone, grey_tone}
  grey_fighter.sprite.fill.effect.lightColor = {grey_tone, grey_tone, grey_tone}

  grey_cutout_1 = display.newImageRect(fightGroup, "Art/Cutouts/bloomberg_all_grey.png", 800, 500)
  grey_cutout_1.x = display.contentCenterX
  grey_cutout_1.y = display.contentCenterY
  grey_cutout_1.isVisible = false

  grey_cutout_2 = display.newImageRect(fightGroup, "Art/Cutouts/bloomberg_all_black.png", 800, 500)
  grey_cutout_2.x = display.contentCenterX
  grey_cutout_2.y = display.contentCenterY
  grey_cutout_2.isVisible = false

  purple_cutout_1 = display.newImageRect(fightGroup, "Art/Cutouts/klobuchar_all_purple.png", 800, 500)
  purple_cutout_1.x = display.contentCenterX + 300
  purple_cutout_1.y = display.contentCenterY + 300
  purple_cutout_1.isVisible = false

  purple_slash = display.newImageRect(fightGroup, "Art/purple_slash.png", 800, 500)
  purple_slash.x = -400
  purple_slash.y = display.contentCenterY
  purple_slash.isVisible = false

  purple_fighter = candidates["warren"]:create(display.contentCenterX + 60, display.contentCenterY - 30, fightGroup, -2500, 2500, -100, 100, effects)
  purple_fighter.xScale = 0.7
  purple_fighter.yScale = 0.7
  purple_fighter.ground_target = purple_fighter.y
  purple_fighter.sprite:setFrame(8)
  purple_fighter.isVisible = false
  purple_fighter.sprite:setFillColor(0, 0, 0)

  orange_background = display.newImageRect(backgroundGroup, "Art/orange_screen.png", 1024, 1024)
  orange_background.x = display.contentCenterX
  orange_background.y = display.contentCenterY
  orange_background.isVisible = false
  orange_background.alpha = 0

  black_cutout = display.newImageRect(fightGroup, "Art/Cutouts/trump_all_black.png", 568, 379)
  black_cutout.x = display.contentCenterX
  black_cutout.y = display.contentCenterY + 40
  black_cutout.isVisible = false

  trump = candidates["trump"]:create(display.contentCenterX, display.contentCenterY - 30, fightGroup, -500, 1500, -100, 100, effects)
  trump.xScale = -0.7
  trump.yScale = 0.7
  trump.ground_target = trump.y
  trump.isVisible = false
  trump.sprite.fill.effect = "filter.duotone"
  -- trump.alpha = 0

  false_trump = candidates["trump"]:create(display.contentCenterX, display.contentCenterY - 30, fightGroup, -500, 1500, -100, 100, effects)
  false_trump.xScale = -0.7
  false_trump.yScale = 0.7
  false_trump.ground_target = false_trump.y

  grey_slash = display.newImageRect(fightGroup, "Art/grey_slash.png", 800, 500)
  grey_slash.x = display.contentCenterX
  grey_slash.y = display.contentCenterY
  grey_slash.isVisible = false

  effects = effects_class:create()

  beat_number = 0
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    animationTimer = timer.performWithDelay(33, animationFunction, 0)

    -- trump:enable()

    beat_number = 0

    timerTable = {}

    local initial_delay = 2500

    -- table.insert(timerTable, timer.performWithDelay(2400, function()
    --   animation.to(false_trump.sprite, {alpha=0}, {time=100})
    -- end))

    table.insert(timerTable, timer.performWithDelay(initial_delay, function()
      false_trump.isVisible = false
      trump.isVisible = true
      trump.sprite.fill.effect.darkColor = {0.02, 0.26, 0.69}
      trump.sprite.fill.effect.lightColor = {0.02, 0.26, 0.69}
      satire.isVisible = false
      beat_number = 1
      audio.play(title_music, { channel=1, loops=0 })
      blue_slash.isVisible = true
      blue_fighter.isVisible = true
      animation.to(blue_slash, {x=display.contentCenterX + 30}, {time=50, easing=easing.outExpo})
      animation.to(blue_fighter, {x=display.contentCenterX + 60}, {time=50, easing=easing.outExpo})
      --trump:damageAction(blue_fighter, 30)
      -- trump:disable()
      trump.isVisible = true
      trump.sprite:setFrame(30)
      -- trump.xVel = -5
      local x = trump.x
      animation.to(trump, {x=trump.x + 30}, {time=4000, easing=easing.outSine})
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + 50, function()
      animation.to(blue_slash, {x=display.contentCenterX + 40}, {time=4000, easing=easing.outSine})
      animation.to(blue_fighter, {x=display.contentCenterX + 90}, {time=4000, easing=easing.outSine})
      animation.to(blue_cutout_1, {xScale = -1.1, yScale = 1.1, x = 70}, {time=4000, easing=easing.outSine})
      animation.to(trump, {rotation=20}, {time=4000, easing=easing.outSine})
    end))

    -- local second = 2822
    -- local third = 5643
    -- local fourth = 8458
    -- local fifth = 8810
    -- local sixth = 9163
    -- local seventh = 9869
    -- local fourth = 7047
    -- local fifth = 

    local second = 1396
    local third = 2822
    local fourth = 4218
    local fifth = 5643
    local sixth = 7041
    local seventh = 8465
    local prep_gap = 150  

    -- table.insert(timerTable, timer.performWithDelay(initial_delay + second - prep_gap, function()
    --   animation.to(blue_slash, {y=800, x= display.contentCenterX - 100, rotation=60}, {time=prep_gap, easing=easing.inOutCirc})
    --   animation.to(blue_fighter, {y=1000}, {time=prep_gap - 100, easing=easing.inOutCirc})
    --   animation.to(blue_fighter, {alpha=0}, {time=prep_gap - 100, easing=easing.inOutCirc})
    --   trump.sprite:setFrame(30)
    --   animation.cancel(trump)
    --   trump.isVisible = false
    --   trump.x = display.contentCenterX - 20
    --   trump.y = display.contentCenterY
    --   -- animation.to(trump, {x=display.contentCenterX, rotation=0}, {time=400, easing=easing.inOutExpo})
    -- end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + second, function()
      trump.sprite.fill.effect.darkColor = {0, 0, 0}
      trump.sprite.fill.effect.lightColor = {0, 0, 0}
      animation.to(blue_slash, {x=-400}, {time=50, easing=easing.outExpo})
      animation.to(blue_fighter, {x=-400}, {time=50, easing=easing.outExpo})
      white_slash.isVisible = true
      white_fighter.isVisible = true
      white_cutout_1.isVisible = true
      blue_cutout_1.isVisible = false
      trump.xScale = 0.7
      trump.rotation = 0
      trump.isVisible = true
      animation.to(white_slash, {x=display.contentCenterX - 30}, {time=50, easing=easing.outExpo})
      animation.to(white_fighter, {x=display.contentCenterX - 110}, {time=50, easing=easing.outExpo})
      animation.to(trump, {x=trump.x - 30}, {time=4000, easing=easing.outSine})
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + second + 50, function()
      trump.sprite:setFrame(30)
      white_fighter.sprite:setFrame(21)
      blue_slash.isVisible = false
      blue_fighter.isVisible = false
      animation.to(white_slash, {x=display.contentCenterX - 40}, {time=4000, easing=easing.outSine})
      animation.to(white_fighter, {x=display.contentCenterX - 90}, {time=4000, easing=easing.outSine})
      animation.to(trump, {rotation=-20}, {time=4000, easing=easing.outSine})
    end))


    table.insert(timerTable, timer.performWithDelay(initial_delay + third - prep_gap, function()
      animation.to(white_slash, {y=-800, x= display.contentCenterX - 100, rotation=-40}, {time=prep_gap, easing=easing.inOutExpo})
      animation.to(white_fighter, {xScale = 0.0, yScale = 0.0}, {time=prep_gap - 100, easing=easing.inOutExpo})
      animation.to(white_cutout_1, {xScale = 0.0, yScale = 0.0}, {time=100, easing=easing.outExpo})
      white_cutout_1.isVisible = false
      trump.sprite:setFrame(30)
      animation.cancel(trump)
      trump.isVisible = false
      trump.x = display.contentCenterX + 20
      trump.y = display.contentCenterY
      -- animation.to(trump, {x=display.contentCenterX, rotation=0}, {time=prep_gap, easing=easing.inOutExpo})
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + third, function()
      trump.sprite.fill.effect.darkColor = {0.21, 0.07, 0.07}
      trump.sprite.fill.effect.lightColor = {0.21, 0.07, 0.07}
      animation.to(white_slash, {x=-900}, {time=50, easing=easing.outExpo})
      animation.to(white_fighter, {x=-900}, {time=50, easing=easing.outExpo})
      white_cutout_1.isVisible = false
      red_slash.isVisible = true
      red_fighter.isVisible = true
      trump.xScale = -0.7
      trump.rotation = 0
      trump.isVisible = true
      red_cutout_1.isVisible = true
      animation.to(red_cutout_1, {xScale=1, yScale=1}, {time=50, easing=easing.outExpo})
      animation.to(red_slash, {x=display.contentCenterX - 80}, {time=20, easing=easing.outExpo})
      animation.to(red_fighter, {x=display.contentCenterX + 60}, {time=50, easing=easing.outExpo})
      animation.to(trump, {x=trump.x + 15}, {time=1400, easing=easing.outSine})
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + third + 50, function()
      -- red_fighter.sprite:setFrame(12)
      trump.sprite:setFrame(30)
      animation.to(red_slash, {x=display.contentCenterX - 60}, {time=4000, easing=easing.outSine})
      animation.to(red_fighter, {x=display.contentCenterX + 90}, {time=4000, easing=easing.outSine})
      animation.to(red_cutout_1, {rotation=4, x=red_cutout_1.x + 15}, {time=4000, easing=easing.outSine})
      animation.to(trump, {x=trump.x + 15, rotation=10}, {time=4000, easing=easing.outSine})
    end))


    table.insert(timerTable, timer.performWithDelay(initial_delay + fourth - prep_gap, function()
      animation.to(white_slash, {y=-800, x= display.contentCenterX - 100, rotation=-40}, {time=prep_gap, easing=easing.inOutExpo})
      animation.to(white_fighter, {xScale = 0.0, yScale = 0.0}, {time=prep_gap - 100, easing=easing.inOutExpo})
      animation.to(white_cutout_1, {xScale = 0.0, yScale = 0.0}, {time=100, easing=easing.outExpo})
      white_cutout_1.isVisible = false
      -- animation.to(trump, {x=display.contentCenterX, rotation=0}, {time=prep_gap, easing=easing.inOutExpo})
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + fourth, function()
      trump.sprite:setFrame(30)
      animation.cancel(trump)
      trump.xScale = 0.7
      trump.rotation = -20
      trump.x = 100
      trump.y = display.contentCenterY
      trump.sprite.fill.effect.darkColor = {0,0,0}
      trump.sprite.fill.effect.lightColor = {0,0,0}
      animation.to(yellow_slash, {y = display.contentCenterY + 50}, {time=50, easing=easing.outExpo})
      animation.to(yellow_fighter, {y = display.contentCenterY + 40}, {time=50, easing=easing.outExpo})
      red_cutout_1.isVisible = false
      red_slash.isVisible = false
      red_fighter.isVisible = false
      yellow_slash.isVisible = true
      yellow_fighter.isVisible = true
      yellow_cutout_1.isVisible = true
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + fourth + 50, function()
      -- red_fighter.sprite:setFrame(12)
      trump.sprite:setFrame(30)
      animation.to(yellow_slash, {x=display.contentCenterX + 20}, {time=4000, easing=easing.outSine})
      local y = yellow_fighter.y
      animation.to(yellow_fighter, {y=y - 15}, {time=4000, easing=easing.outSine})
      local x = yellow_cutout_1.x
      animation.to(yellow_cutout_1, {x=x + 30}, {time=4000, easing=easing.outSine})
      animation.to(trump, {rotation=-30, x=80,y=display.contentCenterY - 20}, {time=4000, easing=easing.outSine})
    end))



    table.insert(timerTable, timer.performWithDelay(initial_delay + fifth - prep_gap, function()
      animation.to(yellow_slash, {alpha = 0}, {time=prep_gap, easing=easing.inOutExpo})
      animation.to(yellow_fighter, {alpha = 0}, {time=50, easing=easing.inOutExpo})
      animation.to(yellow_cutout_1, {alpha = 0}, {time=prep_gap, easing=easing.outExpo})
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + fifth, function()
      trump.sprite:setFrame(23)
      animation.cancel(trump)
      trump.xScale = -0.7
      trump.rotation = 0
      trump.x = display.contentCenterX + 50
      trump.y = display.contentCenterY
      trump.sprite.fill.effect.darkColor = {grey_tone, grey_tone, grey_tone,}
      trump.sprite.fill.effect.lightColor = {grey_tone, grey_tone, grey_tone}
      grey_fighter.isVisible = true
      grey_slash.isVisible = true
      grey_cutout_1.isVisible = true
      yellow_slash.isVisible = false
      yellow_fighter.isVisible = false
      yellow_cutout_1.isVisible = false
      animation.to(trump, {x=trump.x+50, rotation=6}, {time=4000, easing=easing.outCirc})
      animation.to(grey_fighter, {x=grey_fighter.x-50, rotation=-6}, {time=4000, easing=easing.outCirc})
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + fifth + 689, function()
      trump.sprite.fill.effect.darkColor = {1 - grey_tone, 1 - grey_tone, 1 - grey_tone}
      trump.sprite.fill.effect.lightColor = {1 - grey_tone, 1 - grey_tone, 1 - grey_tone}
      grey_fighter.sprite.fill.effect.darkColor = {1 - grey_tone, 1 - grey_tone, 1 - grey_tone}
      grey_fighter.sprite.fill.effect.lightColor = {1 - grey_tone, 1 - grey_tone, 1 - grey_tone}
      grey_cutout_1.isVisible = false
      grey_cutout_2.isVisible = true
      white_background.isVisible = true
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + fifth + 710, function()
      trump.sprite.fill.effect.darkColor = {grey_tone, grey_tone, grey_tone,}
      trump.sprite.fill.effect.lightColor = {grey_tone, grey_tone, grey_tone,}
      grey_fighter.sprite.fill.effect.darkColor = {grey_tone, grey_tone, grey_tone,}
      grey_fighter.sprite.fill.effect.lightColor = {grey_tone, grey_tone, grey_tone,}
      grey_cutout_1.isVisible = true
      grey_cutout_2.isVisible = false
      white_background.isVisible = false
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + fifth + 876, function()
      trump.sprite.fill.effect.darkColor = {1 - grey_tone, 1 - grey_tone, 1 - grey_tone}
      trump.sprite.fill.effect.lightColor = {1 - grey_tone, 1 - grey_tone, 1 - grey_tone}
      grey_fighter.sprite.fill.effect.darkColor = {1 - grey_tone, 1 - grey_tone, 1 - grey_tone}
      grey_fighter.sprite.fill.effect.lightColor = {1 - grey_tone, 1 - grey_tone, 1 - grey_tone}
      grey_cutout_1.isVisible = false
      grey_cutout_2.isVisible = true
      white_background.isVisible = true
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + fifth + 900, function()
      trump.sprite.fill.effect.darkColor = {grey_tone, grey_tone, grey_tone,}
      trump.sprite.fill.effect.lightColor = {grey_tone, grey_tone, grey_tone,}
      grey_fighter.sprite.fill.effect.darkColor = {grey_tone, grey_tone, grey_tone,}
      grey_fighter.sprite.fill.effect.lightColor = {grey_tone, grey_tone, grey_tone,}
      grey_cutout_1.isVisible = true
      grey_cutout_2.isVisible = false
      white_background.isVisible = false
    end))
    -- 689
    -- 876
    -- 7054
    -- 7743
    -- 7930


    table.insert(timerTable, timer.performWithDelay(initial_delay + sixth - prep_gap, function()
      -- animation.to(yellow_slash, {alpha = 0}, {time=prep_gap, easing=easing.inOutExpo})
      -- animation.to(yellow_fighter, {alpha = 0}, {time=50, easing=easing.inOutExpo})
      -- animation.to(yellow_cutout_1, {alpha = 0}, {time=prep_gap, easing=easing.outExpo})
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + sixth, function()
      trump.sprite:setFrame(30)
      animation.cancel(trump)
      trump.xScale = -0.7
      trump.rotation = 0
      trump.x = display.contentCenterX + 150
      trump.y = display.contentCenterY
      trump.sprite.fill.effect.darkColor = {0.20, 0.15, 0.5}
      trump.sprite.fill.effect.lightColor = {0.20, 0.15, 0.5}
      grey_fighter.isVisible = false
      grey_slash.isVisible = false
      grey_cutout_1.isVisible = false
      purple_slash.isVisible = true
      purple_fighter.isVisible = true
      purple_cutout_1.isVisible = true
      animation.to(purple_slash, {x=display.contentCenterX, y=display.contentCenterY}, {time=50, easing=easing.outExpo})
      animation.to(purple_cutout_1, {x=display.contentCenterX, y=display.contentCenterY}, {time=50, easing=easing.outExpo})
      animation.to(trump, {y=trump.y - 20, rotation=30}, {time=4000, easing=easing.outSine})
      -- animation.to(trump, {x=trump.x+50, rotation=6}, {time=4000, easing=easing.outCirc})
      -- animation.to(purple_fighter, {x=purple_fighter.x+20}, {time=4000, easing=easing.outSine})
    end))

    table.insert(timerTable, timer.performWithDelay(initial_delay + seventh, function()
      animation.cancel(trump)
      purple_slash.isVisible = false
      purple_fighter.isVisible = false
      purple_cutout_1.isVisible = false
      trump.isVisible = false
      black_cutout.isVisible = true
      orange_background.isVisible = true
      animation.to(orange_background, {alpha=1}, {time=8000, easing=easing.linear})
    end))


    table.insert(timerTable, timer.performWithDelay(initial_delay + 10567, function() 
      orange_background.isVisible = false
      black_cutout.isVisible = false
      beat_number = 10
      display.remove(fightGroup)
      title_card.isVisible = true
      white_screen.alpha = 1
      for i = 1,40,1 do
        addRandomSpeedLine()
      end
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + 11300, function()
      beat_number = 11
    end))
    table.insert(timerTable, timer.performWithDelay(initial_delay + 13000, function()
      press_start.isVisible = true
      press_start.alpha = 0
      beat_number = 12
      press_start:addEventListener("tap", gotoSelection)
    end))

    -- display.getCurrentStage():setFocus(backgroundGroup)
    Runtime:addEventListener("tap", immediateTitleCard)
    Runtime:addEventListener("key", keyboard)

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
    composer.removeScene("Source.Scenes.title")
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
