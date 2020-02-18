
local candidate_template = require("Source.Candidates.candidate")

local trumpSpriteInfo = require("Source.Sprites.trumpSprite")
local trumpSprite = graphics.newImageSheet("Art/trump_sprite.png", trumpSpriteInfo:getSheet())

trump = {}
trump.__index = trump

local blocking_max_frames = 30

function trump:create(x, y, group, min_x, max_x, effects_thingy)
  local candidate = candidate_template:create(x, y, group, min_x, max_x, effects_thingy, 38)

  candidate.power = 12
  candidate.resting_rate = 60
  candidate.action_rate = 50
  candidate.automatic_rate = 450
  candidate.ko_frame = 1
  candidate:setMaxHealth(400)

  candidate.frames = {}
  for i = 1, #trumpSpriteInfo.sheet.frames do
    table.insert(candidate.frames, i)
  end

  candidate.name = "Donald Trump"
  candidate.short_name = "trump"

  candidate.sprite = display.newSprite(candidate, trumpSprite, {frames=candidate.frames})
  candidate.hitIndex = trumpSpriteInfo.hitIndex

  candidate.after_image = display.newSprite(candidate, trumpSprite, {frames=candidate.frames})
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

  function candidate:damageAction(actor, extra_vel)
    --self.sprite:setFrame(31)
    self.after_image.isVisible = false
    self.x_vel = -20 * self.xScale
    if extra_vel ~= nil then
      self.x_vel = self.x_vel + extra_vel * self.xScale
    end
    self.y_vel = -5
    self.rotation = 15 * self.xScale
    self.damage_timer = 4
    self.health = self.health - actor.power
    self.damage_in_a_row = self.damage_in_a_row + 1
    self.action = "damaged"
    if self.damage_in_a_row > 3 or self.health <= 0 then
      self:koAction()
    end
  end

  -- local resting_frames = {
  --   1, 1,
  --   2, 2,
  --   3,
  --   4, 4, 4, 4,
  --   5, 5,
  --   6,
  --   1, 1, 1,
  --   7, 7,
  --   8, 8,
  --   9, 9, 9,
  --   10,
  --   11, 11,
  --   4, 4,
  --   5, 5,
  --   6, 6,
  -- }
  local resting_frames_A = {
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
  }
  local resting_frames_B = {
    1, 1,
    11, 11,
    12, 12,
    13, 13,
    14, 14,
    15, 15,
    16, 16,
    17, 17,
    18, 18,
    19, 19,
  }
  resting_frames = resting_frames_A
  candidate.animations["resting"] = function(self)
    self.sprite:setFrame(resting_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #resting_frames) then
      self.frame = 1
      if math.random(1, 100) > 30 then
        resting_frames = resting_frames_A
      else
        resting_frames = resting_frames_B
      end
    end
  end

  local kicking_frames = {
    20, 20,
    21, 21,
    22,
    23, 23, 23,
    22,
    21, 21,
    20, 20,
  }
  candidate.animations["kicking"] = function(self)
    self.sprite:setFrame(kicking_frames[self.frame])
    if self.frame == 24 then
      self.x = self.x + 20 * self.xScale
    end
    self.frame = self.frame + 1
    if (self.frame > #kicking_frames) then
      self:restingAction()
    end
  end

  local punching_frames = {
    24, 24,
    25, 25,
    26, 26,
    27, 27,
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

  candidate.animations["blocking"] = function(self)
    self.sprite:setFrame(30)
    self.frame = self.frame + 1
    if self.frame > blocking_max_frames then
      self:restingAction()
    end
  end

  candidate.damaged_frames = {
    28, 28, 29, 29, 30, 30, 29, 29,
  }
  candidate.animations["damaged"] = function(self)
    self.sprite:setFrame(self.damaged_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #self.damaged_frames) then
      self.frame = #self.damaged_frames
    end
  end

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

return trump