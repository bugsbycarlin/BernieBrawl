
local candidate_template = require("Source.Candidates.candidate")

local sandersSpriteInfo = require("Source.Sprites.sandersSprite")
local sandersSprite = graphics.newImageSheet("Art/sanders_sprite.png", sandersSpriteInfo:getSheet())

sanders = {}
sanders.__index = sanders

function sanders:create(x, y, group, min_x, max_x, effects_thingy)
  local candidate = candidate_template:create(x, y, group, min_x, max_x, effects_thingy, 47)

  candidate.power = 12
  candidate.automatic_rate = 450
  candidate.bros = 4
  candidate.ko_frame = 33
  -- candidate:setMaxHealth(400)

  candidate.frames = {}
  for i = 1, #sandersSpriteInfo.sheet.frames do
    table.insert(candidate.frames, i)
  end

  candidate.name = "Bernie Sanders"
  candidate.short_name = "sanders"

  candidate.sprite = display.newSprite(candidate, sandersSprite, {frames=candidate.frames})
  candidate.hitIndex = sandersSpriteInfo.hitIndex

  candidate.after_image = display.newSprite(candidate, sandersSprite, {frames=candidate.frames})
  candidate.after_image.alpha = 0.5
  candidate.after_image.isVisible = false

  function candidate:automaticAction()
    if self.target.action ~= "dizzy" and self.target.action ~= "ko" then
      dice = math.random(1, 100)
      if dice > 90 then
        self:moveAction(10 * self.xScale, 0)
      elseif dice > 45 then
        self:punchingAction()
      else
        self:kickingAction()
      end
    end
  end

  function candidate:specialAction()
    self.action = "summoning"
    self.frame = 1
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

      if math.abs(x_vel_1) < self.max_x_velocity / 5
        and math.abs(x_vel_2) < self.max_x_velocity / 5
        and math.abs(x_vel_3) < self.max_x_velocity / 5
        and math.abs(y_vel_1) > self.max_y_velocity / 3
        and math.abs(y_vel_2) > self.max_y_velocity / 3
        and math.abs(y_vel_3) > self.max_y_velocity / 3 then
        self.y_vel = 0
        self:specialAction()
        return true
      end
    end

    return false
  end

  candidate.damaged_frames = {
    31
  }

  local resting_frames = {
    1, 1, 1,
    2, 2,
    3, 3,
    4, 4,
    5, 5, 5,
    6, 6,
    7, 7,
    8, 8,
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
    25, 25,
    26, 26,
    27, 27,
    28, 28, 28, 28,
    27, 27,
    26, 26,
    25, 25,
    1, 1,

  }
  candidate.animations["kicking"] = function(self)
    self.sprite:setFrame(kicking_frames[self.frame])
    if self.frame == 7 then
      self.x = self.x + 20 * self.xScale
    elseif self.frame == 9 then
      self.x = self.x + 20 * self.xScale
      self:forceMoveAction(10*self.xScale, -15)
    end
    self.frame = self.frame + 1
    if (self.frame > #kicking_frames) then
      self:restingAction()
    end
  end

  local punching_frames = {
    10, 10,
    11, 11,
    12, 12,
    13, 13,
    14, 14,
    15, 15,
    16, 16,
    17, 17,
    18, 18,
    19, 19,
    11, 11,
    12, 12,
    20, 20, 20,
    21, 21,
    14, 14,
    15, 15,
    11, 11,

  }
  candidate.animations["punching"] = function(self)
    self.sprite:setFrame(punching_frames[self.frame])
    if self.frame == 25 then
      self.x = self.x + 40 * self.xScale
    elseif self.frame == 28 then
      self.x = self.x + 20 * self.xScale
    end
    self.frame = self.frame + 1
    if (self.frame > #punching_frames) then
      self:restingAction()
    end
  end

  local summoning_frames = {
    1,
    34, 34,
    35, 35, 36,
    35, 35, 36,
    35, 35, 36,
    35, 35, 36,
    34,
  }
  candidate.animations["summoning"] = function(self)
    self.sprite:setFrame(summoning_frames[self.frame])
    self.frame = self.frame + 1
    if self.frame == 6 then
      if self.bros > 0 then
        self.effects_thingy:addBro(self.parent_group, self, self.x - 250, self.y + 100, 10, -30, self.min_x, self.max_x)
        self.bros = self.bros - 1
      end
    end
    if self.frame == 12 then
      if self.bros > 0 then
        self.effects_thingy:addBro(self.parent_group, self, self.x + 250, self.y + 100, -10, -30, self.min_x, self.max_x)
        self.bros = self.bros - 1
      end
    end
    if (self.frame > #summoning_frames) then
      self:restingAction()
    end
  end

  candidate.animations["jumping"] = function(self)
    if self.y_vel < 0 then
      self.sprite:setFrame(22) -- go up
    elseif self.y_vel > 0 then
      self.sprite:setFrame(24) -- go down
    end
  end

  candidate.animations["jump_kicking"] = function(self)
    self.sprite:setFrame(23)
    self.frame = self.frame + 1
    if (self.frame > 5) then
      self:jumpingAction()
    end
  end

  candidate.blocking_frames = {30}

  candidate.animations["dizzy"] = function(self)
    self.sprite:setFrame(32)
  end

  candidate.animations["ko"] = function(self)
    if self.xScale == 1 and self.rotation > -90 and self.y_vel ~= 0 then
      self.rotation = self.rotation - 7
    elseif self.xScale == -1 and self.rotation < 90 and self.y_vel ~= 0 then
      self.rotation = self.rotation + 7
    end
  end

  local celebrating_frames = {
    29, 29, 29, 29, 29, 29, 29,
  }
  candidate.animations["celebrating"] = function(self)
    self.sprite:setFrame(celebrating_frames[self.frame])
    if self.frame == 1 then
      -- create smoke
      local number = math.random(1, 2)
      local smoke_trail = display.newImageRect(self, "Art/smoke_0" .. number .. ".png", 64, 64)
      smoke_trail.x = 16
      smoke_trail.y = -51
      smoke_trail.alpha = 1
      function smoke_trail:update()
        smoke_trail.alpha = smoke_trail.alpha * 0.99
        smoke_trail.y = smoke_trail.y - 0.5
      end
      function smoke_trail:finished()
        return self.alpha < 0.05
      end
      self.effects_thingy:add(smoke_trail)
    end
    self.frame = self.frame + 1
    if (self.frame > #celebrating_frames) then
      self.frame = 1
    end
  end

  return candidate
end

return sanders