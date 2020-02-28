
local candidate_template = require("Source.Candidates.candidate")

local bidenSpriteInfo = require("Source.Sprites.bidenSprite")
local bidenSprite = graphics.newImageSheet("Art/biden_sprite.png", bidenSpriteInfo:getSheet())

biden = {}
biden.__index = biden

function biden:create(x, y, group, min_x, max_x, min_z, max_z, effects_thingy)
  local candidate = candidate_template:create(x, y, group, min_x, max_x, min_z, max_z, effects_thingy, 47)

  candidate.resting_rate = 60
  candidate.action_rate = 40
  candidate.power = 10
  candidate.knockback = 12
  candidate.automatic_rate = 750
  candidate:setMaxHealth(30)

  -- to do: lots of knockback for ultra punching

  candidate.frames = {}
  for i = 1, #bidenSpriteInfo.sheet.frames do
    table.insert(candidate.frames, i)
  end

  candidate.name = "Joe Biden"
  candidate.short_name = "biden"

  candidate.sprite = display.newSprite(candidate, bidenSprite, {frames=candidate.frames})
  candidate.hitIndex = bidenSpriteInfo.hitIndex
  
  candidate.after_image = display.newSprite(candidate, bidenSprite, {frames=candidate.frames})
  candidate.after_image.alpha = 0.5
  candidate.after_image.isVisible = false

  candidate.ko_frame = 30

  function candidate:automaticAction()
    -- do return end

    if self.health <= 0 then
      return
    end
    
    print("Joe Biden HP is " .. self.health)
    if math.abs(self.target.x - self.x) > 350 then
      self:basicAutomaticMove()
    elseif self.target.action ~= "dizzy" and self.target.action ~= "ko" then
      dice = math.random(1, 100)
      moved = false
      if dice > 70 then
        moved = self:basicAutomaticMove()
      end
      if moved == false then
        if dice > 60 then
          self:punchingAction()
        elseif dice > 20 then
          self:kickingAction()
        else
          self:specialAction()
        end
      end
    else
      local dice = math.random(1, 100)
      if dice > 90 then
        self:moveAction(10 * self.xScale, 0)
      elseif dice > 60 then
        self:moveAction(-10 * self.xScale, 0)
      elseif dice > 55 then
        self:punchingAction()
      end
    end
  end

  -- keep this one, it's an override
  function candidate:jumpAttackAction()
    self.action = "jump_kicking"
    self.frame = 1
    self.sprite:setFrame(33)
    self:forceMoveAction(10*self.xScale, 0)
  end

  function candidate:specialAction()
    self.action = "ultra_punching"
    self.frame = 1
    self.attack = {power=2*self.power, knockback=2*self.knockback}
  end

  function candidate:checkSpecialAction(x_vel, y_vel)
    if #self.swipe_history > 2 
      and system.getTimer() - self.swipe_history[#self.swipe_history - 2].time < 1500 then

      x_vel_1 = self.swipe_history[#self.swipe_history - 2].x_vel
      y_vel_1 = self.swipe_history[#self.swipe_history - 2].y_vel
      x_vel_2 = self.swipe_history[#self.swipe_history - 1].x_vel
      y_vel_2 = self.swipe_history[#self.swipe_history - 1].y_vel
      x_vel_3 = self.swipe_history[#self.swipe_history].x_vel
      y_vel_3 = self.swipe_history[#self.swipe_history].y_vel

      if math.abs(x_vel_1) > self.max_x_velocity / 3 and x_vel_1 * self.xScale > 0 
        and math.abs(y_vel_1) < self.max_y_velocity / 5
        and math.abs(x_vel_2) > self.max_x_velocity / 3 and x_vel_2 * self.xScale < 0
        and math.abs(y_vel_2) < self.max_y_velocity / 5
        and math.abs(x_vel_3) > self.max_x_velocity / 1.5 and x_vel_3 * self.xScale > 0 
        and math.abs(y_vel_3) < self.max_y_velocity / 5 then

        self.y_vel = 0
        self:specialAction()
        return true
      end
    end

    return false
  end

  candidate.damaged_frames = {
    28
  }

  local resting_frames = {
    1, 1,
    2, 2,
    3, 3,
    4, 4,
    5, 5,
    6, 6,
    7, 7,
    8, 8,
    9, 9,
    10, 10,
    11, 11,
    12, 12,
    13, 13,
    14, 14,
    15, 15,
    16, 16,
  }
  candidate.animations["resting"] = function(self)
    self.sprite:setFrame(resting_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #resting_frames) then
      self.frame = 1
    end
  end

  local kicking_frames = {
    1, 1,
    17, 17,
    18, 18, 18, 18,
    19, 19,
    20, 20,
    1, 1,
  }
  candidate.animations["kicking"] = function(self)
    self.sprite:setFrame(kicking_frames[self.frame])
    if self.frame == 5 then
      self:forceMoveAction(15*self.xScale, 0)
      self.effects_thingy:playSound("swing_1")
    end
    self.frame = self.frame + 1
    if (self.frame > #kicking_frames) then
      self:restingAction()
    end
  end

  local punching_frames = {
    1, 1,
    21, 21,
    22, 22,
    23, 23,
    24, 24,
    25, 25,
    26, 26, 26, 26,
    27, 27,
    10, 10,
    9, 9,
    1, 1,
  }
  candidate.animations["punching"] = function(self)
    self.sprite:setFrame(punching_frames[self.frame])
    if self.frame == 5 or self.frame == 13 then
      self:forceMoveAction(10*self.xScale, 0)
      self.effects_thingy:playSound("swing_1")
    end
    -- second attack
    self.frame = self.frame + 1
    if self.frame == 13 and self.attack == nil then
      self.attack = {power=self.power, knockback=self.knockback}
    end
    if (self.frame > #punching_frames) then
      self:restingAction()
    end
  end

  local ultra_punching_frames = {
    25, 25, 25, 25, 25, 34, 34
  }
  candidate.animations["ultra_punching"] = function(self)
    self.sprite:setFrame(ultra_punching_frames[self.frame])
    if self.frame < 7 then
      self.frame = self.frame + 1
    end
    if self.frame == 6 then
      self.x_vel = 40 * self.xScale
      self.y_vel = -7
    end
    if self.frame == 7 and self.x_vel < 2 then
      self:restingAction()
    end
  end

  candidate.animations["jumping"] = function(self)
    if self.y_vel < 0 then
      self.sprite:setFrame(31) -- go up
    elseif self.y_vel > 0 then
      self.sprite:setFrame(32) -- go down
    end
  end

  candidate.animations["jump_kicking"] = function(self)
    self.sprite:setFrame(33)
  end

  candidate.blocking_frames = {35}

  candidate.animations["dizzy"] = function(self)
    self.sprite:setFrame(29)
  end

  candidate.animations["ko"] = function(self)
    if self.xScale == 1 and self.rotation > -90 and self.y_vel ~= 0 then
      self.rotation = self.rotation - 7
    elseif self.xScale == -1 and self.rotation < 90 and self.y_vel ~= 0 then
      self.rotation = self.rotation + 7
    end
  end

  local celebrating_frames = {
    36, 36, 36,
    37, 37, 37,
    38, 38, 38,
    37, 37, 37,
  }
  candidate.animations["celebrating"] = function(self)
    self.sprite:setFrame(celebrating_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #celebrating_frames) then
      self.frame = 1
    end
  end

  return candidate
end

return biden