
dizzyTwit = {}
dizzyTwit.__index = dizzyTwit

local twit_speed = 5
local twit_period = 80
local flutter_height = 7
local twit_size = 32

function dizzyTwit:create(group, originator, x_center, y_center, width, duration)

  local object = {}
  setmetatable(object, dizzyTwit)

  object.sprite = display.newImageRect(group, "Art/twit.png", twit_size, twit_size)
  object.sprite.x = x_center - width + math.random(1, 2 * width)
  object.sprite.y = y_center
  object.x_center = x_center
  object.y_center = y_center
  object.width = width
  object.period = twit_period
  object.x_vel = twit_speed
  if math.random(1,100) < 50 then
    object.x_vel = object.x_vel * -1
    object.sprite.xScale = -1
  end
  object.duration = duration
  object.originator = originator
  object.start_time = system.getTimer()

  return object
end

function dizzyTwit:update()
  self.sprite.x = self.sprite.x + self.x_vel
  if self.sprite.x > self.x_center + self.width or self.sprite.x < self.x_center - self.width then
    self.x_vel = self.x_vel * -1
    self.sprite.xScale = self.sprite.xScale * -1
  end
  self.sprite.y = self.y_center + flutter_height * math.sin((system.getTimer() - self.start_time) / self.period)
end

function dizzyTwit:finished()
  print("Time")
  print(system.getTimer() - self.start_time)
  if system.getTimer() - self.start_time > self.duration then
    return true
  elseif self.originator.action ~= "dizzy" then
    return true
  else
    return false
  end
end

return dizzyTwit