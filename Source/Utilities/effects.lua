
effects = {}
effects.__index = effects

local twit = require("Source.Utilities.twit")

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

function effects:create()

  local object = {}
  setmetatable(object, effects)

  object.effect_list = {}

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
      display.remove(self.effect_list[i].sprite)
    end
  end
  self.effect_list = copy_effect_list
end

function effects:addTwit(group, x_center, y_center, width, period, duration)
  print("Adding a twit")
  local x = twit:create(group, x_center, y_center, width, period, duration)
  self:add(x)
end

function effects:addBro(group, player, x_center, y_center, x_vel, y_vel, min_x, max_x)
  print("Adding a bro")
  if self.fighters == nil then
    print("Actually, can't add a bro because the effects system doesn't have a list of fighers.")
    return
  end
  local fighter = candidates["bro"]:create(x_center, y_center, group, min_x, max_x, self)
  fighter.target = player.target
  fighter.x_vel = x_vel
  fighter.y_vel = y_vel
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

function effects:randomDamage()
  audio.play(sounds["damage_" .. math.random(1,6)], 0)
end

return effects