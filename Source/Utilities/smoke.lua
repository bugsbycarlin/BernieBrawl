


smoke = {}
smoke.__index = smoke

local max_clouds = 100
local min_scale = 0.2
local max_scale = 0.6

function smoke:create(group, min_x, max_x, min_y, max_y)

  local object = {}
  setmetatable(object, smoke)

  object.clouds = {}
  object.group = group
  object.min_x = min_x
  object.max_x = max_x
  object.min_y = min_y
  object.max_y = max_y

  return object
end

function smoke:update()
  if #self.clouds < max_clouds then
    self:create_flake()
  end

  copy_clouds = {}
  for i = 1, #self.clouds do
    if math.random(1, 1000) < reversing_rate then
      self.clouds[i].x_vel = -1 * self.clouds[i].x_vel
    end
    self.clouds[i].x:update()
    self.clouds[i].x = self.clouds[i].x + self.clouds[i].x_vel
    self.clouds[i].y = self.clouds[i].y + self.clouds[i].y_vel

    if self:finished(self.clouds[i]) ~= true then
      table.insert(copy_clouds, self.clouds[i])
    else
      display.remove(self.clouds[i])
    end
  end
  self.clouds = copy_clouds
end

function smoke:finished(flake)
  x, y = self.group:localToContent(flake.x, flake.y)
  if flake.y > flake.target_y then
    return true
  elseif x < -100 or x > display.contentWidth + 100 then
    return true
  else
    return false
  end
end

function smoke:create_flake()
  if (-1 * self.group.x) > self.max_x then
    return
  end
  local x = math.random(0, display.contentWidth) - self.group.x
  local y = -1 * math.random(10, 20) - self.group.y
  local radius = math.random(min_radius, max_radius)
  local flake = display.newCircle(self.group, x, y, radius)
  flake.alpha = math.random(50, 100) / 100.0
  flake:setFillColor(1.0, 1.0, 1.0)
  flake.target_y = display.contentHeight - math.random(1, floor_width)
  flake.x_vel = math.random(3,6) / 5.0
  flake.y_vel = math.random(0,10) / 8.0
  table.insert(self.clouds, flake)
end

return smoke