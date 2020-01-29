
effects = {}
effects.__index = effects

local twit = require("Source.Utilities.twit")

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

function effects:add(effect)
  table.insert(self.effect_list, effect)
end

return effects