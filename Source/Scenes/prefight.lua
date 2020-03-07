
local composer = require("composer")

local scene = composer.newScene()

local effects_system = require("Source.Utilities.effects")

candidates = {}
candidates["warren"] = require("Source.Candidates.Warren")
candidates["trump"] = require("Source.Candidates.Trump")
candidates["biden"] = require("Source.Candidates.Biden")
candidates["sanders"] = require("Source.Candidates.Sanders")

local stage_music = audio.loadStream("Sound/BeiMir.mp3")

local effects

local color_backdrop

local animationTimer

local speed_line_width = 800
local max_speed_lines = 100
local speed_line_backdrop_height = 140
local speed_line_mid_height = 1
local speed_line_max_height = 15
local speed_line_min_x_vel = 60
local speed_line_max_x_vel = 80

local blue_color = {r=106/255, g=175/255, b=226/255}
local red_color = {r=224/255, g=29/255, b=39/255}

local beat_number

local start_time

local blue_candidate
local red_candidate

local blue_text
local red_text

local red_fighter
local blue_fighter

--[[
  "put'cher hand down for a second bernie, okay?
  "just waving to you, joe"
    -- warren_vs_bloomberg = {
  --   first="how are you gonna pay for Medicare for All, Senator?",
  --   second="I'm gonna beat the money out of you, Mike!",
  -- },
  -- Bloomberg: this is a fight you can't afford to lose!
  -- Sanders vs bloomberg (or trump): "I hate billionaires and hair stylists!"
  -- warren vs trump: you can't keep blocking everything that moves this country forward. this has to stop.
  -- nobody in this country got rich on his own. Nobody.
  -- You're a loud, nasty, thin-skinner fraud who never risked anything for anyone and you serve nobody but yourself.
  --"I'm not going to sugarcoat it," Mr Biden said. "This isn't the first time in my life I've been knocked down."
]]--

quips = { warren={}, biden={}, sanders={}, buttigieg={}, yang={}, bloomberg={}, trump={}, }

quips["warren"]["biden"] = {
   "I'm landing Medicare for All and you're not gonna stop me, Joe.",
    "I'm literally gonna make you pay for that, Liz.",
}
quips["warren"]["sanders"] = {
  "You said a woman could never be president!", "Bull! A woman can be president. It's just not gonna be you."
}
quips["warren"]["trump"] = {
  "blah",
  "blah",
}

quips["biden"]["warren"] = {
  "I helped you with the CFPB! I got you votes!",
  "I'll thank you when I'm President.",
}
quips["biden"]["sanders"] = {
  "Put'cher hand down for a second, Bernie, okay?",
  "Just waving to you, Joe.",
}
quips["biden"]["trump"] = {
  "blah",
  "blah",
}

quips["sanders"]["warren"] = {
  "Medicare for All!", "Medicare for All!"
}
quips["sanders"]["biden"] = {
  "blah",
  "blah",
}
quips["sanders"]["trump"] = {
  "blah",
  "blah",
}


quips["trump"]["warren"] = {
  "blah",
  "blah",
}
quips["trump"]["biden"] = {
  "blah",
  "blah",
}
quips["trump"]["sanders"] = {
  "blah",
  "blah",
}

local function gotoGame()
  composer.gotoScene("Source.Scenes.game", {effect = "crossFade", time = 1000})
end

local function addBlueSpeedLine(y)
  height = math.random(speed_line_mid_height, speed_line_max_height)
  x_vel = math.random(speed_line_min_x_vel, speed_line_max_x_vel)
  color_tint = math.random(5, 15) / 10
  speed_line = display.newImageRect(backgroundGroup, "Art/block.png", speed_line_width, height)
  speed_line.x = -1 * speed_line_width / 2 - 200 + math.random(1, 200)
  speed_line.y = y - speed_line_backdrop_height/2 + math.random(speed_line_backdrop_height)
  if speed_line.y + height / 2 > y + speed_line_backdrop_height / 2 then
    speed_line.y = y + speed_line_backdrop_height / 2 - height / 2 - 1
  end
  if speed_line.y - height / 2 < y - speed_line_backdrop_height / 2 then
    speed_line.y = y - speed_line_backdrop_height / 2 + height / 2 + 1
  end
  speed_line.x_vel = x_vel
  new_color = {
    r = math.min(blue_color.r * color_tint, 1),
    g = math.min(blue_color.g * color_tint, 1),
    b = math.min(blue_color.b * color_tint, 1),
  }
  speed_line:setFillColor(new_color.r, new_color.g, new_color.b)
  function speed_line:update()
    self.x = self.x + self.x_vel
  end
  function speed_line:finished()
    return (self.x - speed_line_width / 2 > display.contentWidth) 
  end

  effects:add(speed_line)
end

local function addRedSpeedLine(y)
  height = math.random(speed_line_mid_height, speed_line_max_height)
  x_vel = math.random(speed_line_min_x_vel, speed_line_max_x_vel)
  color_tint = math.random(5, 15) / 10
  speed_line = display.newImageRect(backgroundGroup, "Art/block.png", speed_line_width, height)
  speed_line.x = display.contentWidth + speed_line_width / 2 + 200 - math.random(1, 200)
  speed_line.y = y - speed_line_backdrop_height/2 + math.random(speed_line_backdrop_height)
  if speed_line.y + height / 2 > y + speed_line_backdrop_height / 2 then
    speed_line.y = y + speed_line_backdrop_height / 2 - height / 2 - 1
  end
  if speed_line.y - height / 2 < y - speed_line_backdrop_height / 2 then
    speed_line.y = y - speed_line_backdrop_height / 2 + height / 2 + 1
  end
  speed_line.x_vel = x_vel
  new_color = {
    r = math.min(red_color.r * color_tint, 1),
    g = math.min(red_color.g * color_tint, 1),
    b = math.min(red_color.b * color_tint, 1),
  }
  speed_line:setFillColor(new_color.r, new_color.g, new_color.b)
  function speed_line:update()
    self.x = self.x - self.x_vel
  end
  function speed_line:finished()
    return (self.x + speed_line_width / 2 < 0) 
  end

  effects:add(speed_line)
end

local function animation()

  effects:update()

  red_candidate:update()
  blue_candidate:update()

  if beat_number % 4 == 0 then
    color_backdrop:setFillColor(blue_color.r, blue_color.g, blue_color.b)
  elseif beat_number % 4 == 1 then
    color_backdrop.x = color_backdrop.x + speed_line_min_x_vel
  elseif beat_number % 4 == 2 then
    if color_backdrop.x > display.contentCenterX then
      color_backdrop.x = color_backdrop.x - speed_line_min_x_vel
    else
      color_backdrop.x = display.contentCenterX
    end
    color_backdrop:setFillColor(red_color.r, red_color.g, red_color.b)
  elseif beat_number % 4 == 3 then
    color_backdrop.x = color_backdrop.x - speed_line_min_x_vel
  end

  if #effects.effect_list < max_speed_lines and beat_number % 4 == 0 then
    addBlueSpeedLine(color_backdrop.y)
  end

  if #effects.effect_list < max_speed_lines and beat_number % 4 == 2 then
    addRedSpeedLine(color_backdrop.y)
  end

  if(blue_fighter.y < blue_fighter.ground_target - 250 - 10) then
    blue_fighter.ground_target = display.contentCenterY + blue_fighter.y_offset
  end

  if(red_fighter.y < red_fighter.ground_target - 250 - 10) then
    red_fighter.ground_target = display.contentCenterY + red_fighter.y_offset
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

  candidate = composer.getVariable("candidate")
  opponent = composer.getVariable("opponent")
  location = composer.getVariable("location")

  color_backdrop = display.newImageRect(backgroundGroup, "Art/block.png", speed_line_width, speed_line_backdrop_height)
  color_backdrop.x = display.contentCenterX
  color_backdrop.y = display.contentCenterY + 90
  color_backdrop:setFillColor(blue_color.r, blue_color.g, blue_color.b)

  local exchange = quips[candidate][opponent]

  blue_candidate = display.newImageRect(pictureGroup, "Art/Cutouts/" .. candidate .. "_blue_pixelated.png", 341, 227)
  blue_candidate.x = 40
  blue_candidate.y = display.contentCenterY - 50
  blue_candidate.target_x = 40
  blue_candidate.alpha = 0.0
  blue_candidate.xScale = 1
  blue_candidate.yScale = 1
  blue_candidate.rotation = 0
  blue_text = display.newText(
    mainGroup,
    exchange[1],
    display.contentCenterX + 100, 80, 350, 100,
    "Georgia-Bold", 20)
  blue_text:setTextColor(blue_color.r, blue_color.g, blue_color.b)
  blue_text.alpha = 0
  function blue_candidate:update()
    if beat_number % 4 == 0 then
      self.rotation = self.rotation - 0.05
      if self.alpha < 0.99 then
        blue_text.alpha = math.min(1, blue_text.alpha + 0.1)
        self.alpha = math.min(1, self.alpha + 0.1)
        self.xScale = self.xScale + 0.001
        self.yScale = self.yScale + 0.001
        self.x = self.x + 0.3
      else
        self.xScale = self.xScale - 0.001
        self.yScale = self.yScale - 0.001
        blue_text.rotation = blue_text.rotation + 0.03
      end
    else
      self.alpha = math.max(0, self.alpha - 0.1)
      blue_text.alpha = math.max(0, blue_text.alpha - 0.1)
    end
  end

  red_candidate = display.newImageRect(pictureGroup, "Art/Cutouts/" .. opponent .. "_red_pixelated.png", 341, 227)
  red_candidate.x = display.contentWidth - 80
  red_candidate.y = display.contentCenterY - 50
  red_candidate.xScale = -1
  red_candidate.alpha = 0.0
  red_text = display.newText(
    mainGroup,
    exchange[2],
    display.contentCenterX - 80, 80, 300, 100,
    "Georgia-Bold", 20)
  red_text:setTextColor(red_color.r, red_color.g, red_color.b)
  red_text.alpha = 0
  function red_candidate:update()
    if beat_number % 4 == 2 then
      red_text.y = 100
      red_text.alpha = math.min(1, red_text.alpha + 0.1)
      self.alpha = math.min(1, self.alpha + 0.1)
      self.xScale = self.xScale + 0.001
      self.yScale = self.yScale + 0.001
      self.x = self.x - 0.3
    else
      self.alpha = math.max(0, self.alpha - 0.1)
      red_text.alpha = math.max(0, red_text.alpha - 0.1)
    end
    if beat_number % 4 == 3 then
      red_text.y = red_text.y - 40
    end
  end

  effects = effects_system:create()

  beat_number = 0

  red_fighter = candidates[opponent]:create(384 + 38, display.contentCenterY + 250, mainGroup, -500, 1500, -100, 100, effects)
  red_fighter.xScale = -1
  red_fighter.ground_target = red_fighter.ground_target + 250
  red_fighter.max_y_velocity = 70

  red_fighter.sprite.fill.effect = "filter.duotone"
  red_fighter.sprite.fill.effect.darkColor = { red_color.r / 3, red_color.g / 3, red_color.b / 3, 1 }
  red_fighter.sprite.fill.effect.lightColor = { red_color.r / 3, red_color.r / 3, red_color.r / 3, 1 }
  red_fighter.sprite:setFillColor(red_color.r / 3, red_color.r / 3, red_color.r / 3)

  blue_fighter = candidates[candidate]:create(184 - 38, display.contentCenterY + 250, mainGroup, -500, 1500, -100, 100, effects)
  blue_fighter.ground_target = blue_fighter.ground_target + 250
  blue_fighter.max_y_velocity = 70

  blue_fighter.sprite.fill.effect = "filter.duotone"
  blue_fighter.sprite.fill.effect.darkColor = { blue_color.r / 3, blue_color.g / 3, blue_color.b / 3, 1 }
  blue_fighter.sprite.fill.effect.lightColor = { blue_color.r / 3, blue_color.r / 3, blue_color.r / 3, 1 }
  blue_fighter.sprite:setFillColor(blue_color.r / 3, blue_color.r / 3, blue_color.r / 3)
  
  red_fighter.target = blue_fighter
  red_fighter.other_fighters = {blue_fighter}
  blue_fighter.target = red_fighter
  blue_fighter.other_fighters = {red_fighter}


  -- first action
  for i = 1,20,1 do
    addBlueSpeedLine(color_backdrop.y)
  end
  blue_fighter:forceMoveAction(5, -45)

  timer.performWithDelay(3000, function() beat_number = 1 end)
  timer.performWithDelay(4000, function()
    red_fighter:forceMoveAction(-5, -45)
    beat_number = 2 
    for i = 1,20,1 do
      addRedSpeedLine(color_backdrop.y)
    end
  end)

  if #exchange == 2 then
    timer.performWithDelay(7000, function()
      beat_number = 3
    end)
    timer.performWithDelay(8000, function() gotoGame() end)
  elseif #exchange == 4 then
    timer.performWithDelay(7000, function() beat_number = 3 end)
    timer.performWithDelay(8000, function()
      beat_number = 4
      for i = 1,20,1 do
        addBlueSpeedLine(color_backdrop.y)
      end
      blue_text.text = exchange[3]
    end)
    timer.performWithDelay(11000, function() beat_number = 5 end)
    -- timer.performWithDelay(11000, function() beat_number = 5 end)
    timer.performWithDelay(12000, function()
      beat_number = 6
      for i = 1,20,1 do
        addRedSpeedLine(color_backdrop.y)
      end
      red_text.text = exchange[4]
    end)
    timer.performWithDelay(15000, function()
      beat_number = 7
    end)
    timer.performWithDelay(16000, function() gotoGame() end)
  end
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    animationTimer = timer.performWithDelay(33, animation, 0)
    blue_fighter:enable()
    red_fighter:enable()
    print("here")
    audio.play(stage_music, { channel=1, loops=0 })

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
    red_fighter:disable()
    blue_fighter:disable()
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
