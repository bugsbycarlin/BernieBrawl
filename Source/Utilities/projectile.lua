
projectile = {}
projectile.__index = projectile

local projectile_size = 64
local projectile_knockback = 10
local projectile_power = 8
local z_threshold = 40

local function distance(x1, y1, x2, y2)
  return math.sqrt((x1-x2)^2 + (y1 - y2)^2)
end

function projectile:create(projectile_type, group, originator, fighters, x, y, z, xScale, x_vel, y_vel)

  local object = {}
  setmetatable(object, projectile)
  print(group)

  object.type = "projectile"

  object.sprite = display.newImageRect(group, "Art/" .. projectile_type .. ".png", projectile_size, projectile_size)
  object.y = y
  object.z = z
  object.sprite.x = x
  object.sprite.y = y + z
  object.sprite.z = z
  object.sprite.xScale = xScale
  object.x_vel = x_vel
  object.y_vel = y_vel
  object.gravity = 0
  object.sprite.rotation = 0
  object.rotation_vel = 0
  object.starting_x = x
  object.enabled = true
  object.originator = originator
  object.fighters = fighters
  object.hit_radius = projectile_size / 3

  return object
end

function projectile:update()
  self.sprite.x = self.sprite.x + self.x_vel
  self.sprite.y = self.sprite.y + self.y_vel
  self.sprite.rotation = self.sprite.rotation + self.rotation_vel
  self.y_vel = self.y_vel + self.gravity


  local insensitivity = 4

  if self.fighters ~= nil then
    print("Checking " .. #self.fighters .. " fighters")
    for i = 1, #self.fighters do
      opponent = self.fighters[i]

      local z_diff = math.abs(opponent.z - self.z)

      if z_diff < z_threshold and self.enabled == true and opponent ~= self.originator and opponent.action ~= "ko" and opponent.action ~= "blinking" then

        -- Get the opponent's hit detection circles
        opponent_frame = opponent.sprite.frame
        opponent_hitIndex = opponent.hitIndex[opponent_frame]

        -- priority order of results for opponent:
        -- block: 2
        -- smackasmack: 1
        -- miss: -1
        opponent_result = -1

        for k = 1, #opponent_hitIndex do
          x1, y1 = self.sprite:localToContent(0, 0)
          x2, y2 = opponent:localToContent(opponent_hitIndex[k].x, opponent_hitIndex[k].y)
          if distance(x1, y1, x2, y2) < self.hit_radius + opponent_hitIndex[k].radius - insensitivity then
            if opponent_hitIndex[k].purpose == "defense" then
              opponent_result = math.max(2, opponent_result)
            else
              opponent_result = math.max(1, opponent_result)
            end
          end
        end

        if opponent_result == 2 then
          self.enabled = false
          self.sprite.isVisible = false
          opponent.effects:randomDamageSound()
          -- opponent:adjustVelocity(projectile_knockback * -1 * opponent.xScale, 0)
          opponent:damageAction("knockback", projectile_power / 8, projectile_knockback * 0.5, 0, 0)
        elseif opponent_result == 1 then
          self.enabled = false
          opponent.effects:randomDamageSound()
          opponent.damage_in_a_row = opponent.damage_in_a_row + 1
          opponent:damageAction("damaged", projectile_power, projectile_knockback, 0, 5)
        end
      end
    end
  end
end

function projectile:finished()
  if self.enabled == false or math.abs(self.sprite.x - self.starting_x) > 1000 then
    return true
  else
    return false
  end
end

return projectile