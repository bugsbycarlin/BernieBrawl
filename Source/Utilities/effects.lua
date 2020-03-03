
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

function effects:create(top_level_group, foreground_group)

  local object = {}
  setmetatable(object, effects)

  object.effect_list = {}
  object.top_level_group = top_level_group
  object.foreground_group = foreground_group

  fighters = nil

  return object
end

function effects:update()
  copy_effect_list = {}
  for i = 1, #self.effect_list do
    self.effect_list[i]:update()
  end
  for i = 1, #self.effect_list do
    if self.effect_list[i]:finished() ~= true then
      table.insert(copy_effect_list, self.effect_list[i])
    else
      if display.type == "textBubble" then

      else
        display.remove(self.effect_list[i].sprite)
      end
    end
  end
  self.effect_list = copy_effect_list
end

function effects:shakeScreen(intensity, duration)
  local shake = {}
  shake.start_time = system.getTimer()
  shake.intensity = intensity
  shake.duration = duration
  shake.target = self.top_level_group

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
  local p = projectile:create("twit", group, originator, self.fighters, x, y, z, xScale, x_vel, y_vel)
  self:add(p)
end

projectileSteak_x_vel = 30
projectileSteak_y_vel_max = 2
function effects:addProjectileSteak(group, originator, x, y, z, xScale)
  local x_vel = projectileSteak_x_vel * xScale
  local y_vel = (math.random(1,200) - 100) / (100 / projectileSteak_y_vel_max)
  local p = projectile:create("steak", group, originator, self.fighters, x, y, z, xScale, x_vel, y_vel)
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
  local p = projectile:create("gold_bar", group, originator, self.fighters, x, y, z, xScale, x_vel, y_vel)
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
  local p = projectile:create("phone", group, originator, self.fighters, x, y, z, xScale, x_vel, y_vel)
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
  local p = projectile:create("soda", group, originator, self.fighters, x, y, z, xScale, x_vel, y_vel)
  p.sprite.xScale = xScale / 2
  p.sprite.yScale = 1/2
  p.hit_radius = p.hit_radius / 1.5
  p.gravity = 2
  p.y_vel = -5
  p.rotation_vel = 10 * xScale
  self:add(p)
end

function effects:addBro(group, player, x_center, y_center, x_vel, y_vel, min_x, max_x, min_z, max_z)
  print("Adding a bro")
  if self.fighters == nil then
    print("Actually, can't add a bro because the effects system doesn't have a list of fighers.")
    return
  end
  local fighter = candidates["bro"]:create(x_center, y_center, group, min_x, max_x, min_z, max_z, self)
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