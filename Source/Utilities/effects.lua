
effects = {}
effects.__index = effects

local dizzyTwit = require("Source.Utilities.dizzyTwit")
local projectile = require("Source.Utilities.projectile")

sounds = {}
sounds["punch"] = audio.loadSound("Sound/punch.wav")
sounds["swing_1"] = audio.loadSound("Sound/swing_1.wav")
sounds["swing_2"] = audio.loadSound("Sound/swing_2.wav")
sounds["swing_3"] = audio.loadSound("Sound/swing_3.wav")
sounds["whip_swing"] = audio.loadSound("Sound/whip_swing.wav")
sounds["whip_crack"] = audio.loadSound("Sound/whip_crack.wav")
sounds["block"] = audio.loadSound("Sound/block.wav")
sounds["damage_1"] = audio.loadSound("Sound/damage_1.wav")
sounds["damage_2"] = audio.loadSound("Sound/damage_2.wav")
sounds["damage_3"] = audio.loadSound("Sound/damage_3.wav")
sounds["damage_4"] = audio.loadSound("Sound/damage_4.wav")
sounds["damage_5"] = audio.loadSound("Sound/damage_5.wav")
sounds["damage_6"] = audio.loadSound("Sound/damage_6.wav")
sounds["manifesto"] = audio.loadSound("Sound/manifesto.wav")
sounds["help_me_bros"] = audio.loadSound("Sound/help_me_bros.wav")
sounds["plan"] = audio.loadSound("Sound/plan.wav")

local speed_line_width = 800
local max_speed_lines = 200
local speed_line_backdrop_height = display.contentHeight
local speed_line_min_height = 8
local speed_line_max_height = 20
local speed_line_min_x_vel = 80
local speed_line_max_x_vel = 120

function effects:create(top_level_group, foreground_group)

  local object = {}
  setmetatable(object, effects)

  object.effect_list = {}
  object.top_level_group = top_level_group
  print("My top level group")
  print(top_level_group)
  object.foreground_group = foreground_group

  fighters = nil

  object.candidates = {}
  object.candidates["bro"] = require("Source.Candidates.Bro")

  object.counts = {}

  return object
end

function effects:update()
  copy_effect_list = {}
  for i = 1, #self.effect_list do
    self.effect_list[i].fighters = self.fighters
    self.effect_list[i]:update()
  end
  self.counts = {}
  for i = 1, #self.effect_list do
    if self.effect_list[i]:finished() ~= true then
      table.insert(copy_effect_list, self.effect_list[i])
      if self.effect_list[i].type ~= nil then
        if self.counts[self.effect_list[i].type] == nil then
          self.counts[self.effect_list[i].type] = 0
        end
        self.counts[self.effect_list[i].type] = self.counts[self.effect_list[i].type] + 1
      end
    else
      display.remove(self.effect_list[i].sprite)
    end
  end
  self.effect_list = copy_effect_list
end

local red_color = {r=224/255, g=29/255, b=39/255}
function effects:addRedSpeedLine(y, group)
  height = math.random(speed_line_min_height, speed_line_max_height)
  x_vel = math.random(speed_line_min_x_vel, speed_line_max_x_vel)
  color_tint = math.random(5, 15) / 10
  speed_line = display.newImageRect(group, "Art/block.png", speed_line_width, height)
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

  self:add(speed_line)
end

function effects:removeType(type_string)
  copy_effect_list = {}
  for i = 1, #self.effect_list do
    if self.effect_list[i].type ~= type_string then
      table.insert(copy_effect_list, self.effect_list[i])
    else
      display.remove(self.effect_list[i].sprite)
    end
  end
  self.effect_list = copy_effect_list
end

function effects:addTemporaryText(text_string, x, y, font_size, color, group, duration)
  text = {}
  text.sprite = display.newText(
    group,
    text_string,
    x, y,
    "Georgia-Bold", font_size)
  text.sprite:setFillColor(color[1], color[2], color[3])
  text.duration = duration
  text.start_time = system.getTimer()
  text.type = "temporaryText"
  text.group = group
  function text:update()
  end
  function text:finished()
    print(system.getTimer() - self.start_time)
    print(self.duration)
    print(system.getTimer() - self.start_time > self.duration)
    return system.getTimer() - self.start_time > self.duration
  end

  self:add(text)
end

function effects:shakeScreen(intensity, duration)
  local shake = {}
  shake.start_time = system.getTimer()
  shake.intensity = intensity
  shake.duration = duration
  shake.target = self.top_level_group
  print("Hi")
  print(shake.target)

  function shake:update()
    shake.target.x = math.random(0, 2 * self.intensity) - self.intensity
  end

  function shake:finished()
    if system.getTimer() - self.start_time > self.duration then
      shake.target.x = 0
      shake.target.y = 0
      return true
    else
      return false
    end
  end

  self:add(shake)
end

function effects:addArrow(group, x, y, size, rotation, duration)
  local arrow = display.newImageRect(group, "Art/arrow.png", size, size)
  arrow.x = x
  arrow.y = y
  arrow.rotation = rotation
  arrow.start_time = system.getTimer()
  arrow.duration = duration

  function arrow:update()
    blinking_time = system.getTimer() - self.start_time
    if math.floor(blinking_time / 150) % 2 == 0 then
      self.isVisible = false
    else
      self.isVisible = true
    end
  end

  function arrow:finished()
    return self.duration > 0 and (system.getTimer() - self.start_time > self.duration)
  end

  self:add(arrow)
end

function effects:addDizzyTwit(group, originator, x_center, y_center, width, duration)
  local twit = dizzyTwit:create(group, originator, x_center, y_center, width, duration)
  self:add(twit)
end

projectileTwit_x_vel = 18
projectileTwit_y_vel_max = 2
function effects:addProjectileTwit(group, originator, x, y, z, xScale)
  local x_vel = projectileTwit_x_vel * xScale
  local y_vel = (math.random(1,200) - 100) / (100 / projectileTwit_y_vel_max)
  local p = projectile:create("twit", group, originator, originator.fighters, x, y, z, xScale, x_vel, y_vel)
  self:add(p)
end

projectileSteak_x_vel = 30
projectileSteak_y_vel_max = 2
function effects:addProjectileSteak(group, originator, x, y, z, xScale)
  local x_vel = projectileSteak_x_vel * xScale
  local y_vel = (math.random(1,200) - 100) / (100 / projectileSteak_y_vel_max)
  local p = projectile:create("steak", group, originator, originator.fighters, x, y, z, xScale, x_vel, y_vel)
  p.sprite.xScale = xScale / 2
  p.sprite.yScale = 1/2
  p.hit_radius = p.hit_radius / 1.5
  p.gravity = 2
  p.rotation_vel = 10 * xScale
  self:add(p)
end

projectileGoldBar_x_vel = 28
projectileGoldBar_y_vel_max = 2
function effects:addProjectileGoldBar(group, originator, x, y, z, xScale)
  local x_vel = projectileGoldBar_x_vel * xScale
  local y_vel = (math.random(1,200) - 100) / (100 / projectileGoldBar_y_vel_max)
  local p = projectile:create("gold_bar", group, originator, originator.fighters, x, y, z, xScale, x_vel, y_vel)
  p.sprite.xScale = xScale / 1.5
  p.sprite.yScale = 1/1.5
  p.hit_radius = p.hit_radius / 1.25
  p.gravity = 2
  p.y_vel = -8
  p.rotation_vel = 10 * xScale
  self:add(p)
end

projectilePhone_x_vel = 30
projectilePhone_y_vel_max = 2
function effects:addProjectilePhone(group, originator, x, y, z, xScale)
  local x_vel = projectilePhone_x_vel * xScale
  local y_vel = (math.random(1,200) - 100) / (100 / projectilePhone_y_vel_max)
  local p = projectile:create("phone", group, originator, originator.fighters, x, y, z, xScale, x_vel, y_vel)
  p.sprite.xScale = xScale / 2
  p.sprite.yScale = 1/2
  p.hit_radius = p.hit_radius / 1.5
  p.gravity = 2
  p.rotation_vel = 10 * xScale
  self:add(p)
end

projectileSoda_x_vel = 30
projectileSoda_y_vel_max = 2
function effects:addProjectileSoda(group, originator, x, y, z, xScale)
  local x_vel = projectileSoda_x_vel * xScale
  local y_vel = (math.random(1,200) - 100) / (100 / projectileSoda_y_vel_max)
  local p = projectile:create("soda", group, originator, originator.fighters, x, y, z, xScale, x_vel, y_vel)
  p.sprite.xScale = xScale / 2
  p.sprite.yScale = 1/2
  p.hit_radius = p.hit_radius / 1.5
  p.gravity = 2
  p.y_vel = -5
  p.rotation_vel = 10 * xScale
  self:add(p)
end

projectileManifesto_x_vel = 30
projectileManifesto_y_vel_max = 2
function effects:addProjectileManifesto(group, originator, x, y, z, xScale)
  local x_vel = projectileManifesto_x_vel * xScale
  local y_vel = (math.random(1,200) - 100) / (100 / projectileManifesto_y_vel_max)
  local p = projectile:create("manifesto", group, originator, originator.fighters, x, y, z, xScale, x_vel, y_vel)
  p.sprite.xScale = xScale / 2
  p.sprite.yScale = 1/2
  p.hit_radius = p.hit_radius / 1.5
  p.gravity = 1
  p.rotation_vel = 10 * xScale
  self:add(p)
end

function effects:addBro(group, player, x_center, y_center, x_vel, y_vel, min_x, max_x, min_z, max_z)
  print("Adding a bro")
  if self.fighters == nil then
    print("Actually, can't add a bro because the effects system doesn't have a list of fighers.")
    return
  end
  local fighter = self.candidates["bro"]:create(x_center, y_center, group, min_x, max_x, min_z, max_z, self)
  table.insert(player.fighters, fighter)
  fighter.fighters = player.fighters
  fighter.target = player.target
  fighter.side = "good"
  fighter.x_vel = x_vel
  fighter.y_vel = y_vel
  fighter.ally = player
  fighter.action = "jumping"
  fighter:enable()
  fighter:enableAutomatic()
  table.insert(self.fighters, fighter)
end

function effects:add(effect)
  table.insert(self.effect_list, effect)
end

function effects:playSound(sound)
  audio.play(sounds[sound], 0)
end

function effects:randomSwing()
  audio.play(sounds["swing_" .. math.random(1,3)], 0)
end

function effects:randomDamageSound()
  audio.play(sounds["damage_" .. math.random(1,6)], 0)
end

return effects