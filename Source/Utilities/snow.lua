


snow = {}
snow.__index = snow

local max_flakes = 100
local reversing_rate = 30
local min_radius = 1
local max_radius = 3
local floor_width = 60


function snow:create(group)

  local object = {}
  setmetatable(object, snow)

  object.flakes = {}
  object.group = group

  return object
end

function snow:update()
  if #self.flakes < max_flakes then
    self:create_flake()
  end

  copy_flakes = {}
  for i = 1, #self.flakes do
    if math.random(1, 1000) < reversing_rate then
      self.flakes[i].x_vel = -1 * self.flakes[i].x_vel
    end
    self.flakes[i].x = self.flakes[i].x + self.flakes[i].x_vel
    self.flakes[i].y = self.flakes[i].y + self.flakes[i].y_vel

    if self:finished(self.flakes[i]) ~= true then
      table.insert(copy_flakes, self.flakes[i])
    else
      display.remove(self.flakes[i])
    end
  end
  self.flakes = copy_flakes
end

function snow:finished(flake)
  if flake.y > flake.target_y then
    return true
  else
    return false
  end
end

function snow:create_flake()
  local x = math.random(0, display.contentWidth) - self.group.x
  local y = -1 * math.random(10, 20) - self.group.y
  local radius = math.random(min_radius, max_radius)
  local flake = display.newCircle(self.group, x, y, radius)
  flake.alpha = math.random(50, 100) / 100.0
  flake:setFillColor(1.0, 1.0, 1.0)
  flake.target_y = display.contentHeight - math.random(1, floor_width)
  flake.x_vel = math.random(3,6) / 5.0
  flake.y_vel = math.random(0,10) / 8.0
  table.insert(self.flakes, flake)
end

return snow