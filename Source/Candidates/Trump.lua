
local candidate_template = require("Source.Candidates.candidate")

local trumpSpriteInfo = require("Source.Sprites.trumpSprite")
local trumpSprite = graphics.newImageSheet("Art/trump_sprite.png", trumpSpriteInfo:getSheet())

trump = {}
trump.__index = trump

function trump:create(x, y, group, min_x, max_x, min_z, max_z, effects_thingy)
  local candidate = candidate_template:create(x, y, group, min_x, max_x, min_z, max_z, effects_thingy, 38)

  candidate.power = 12
  candidate.resting_rate = 60
  candidate.action_rate = 50
  candidate.automatic_rate = 450
  candidate.ko_frame = 32
  candidate:setMaxHealth(300)

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
    do return end
    -- self:blockingAction()
    if self.action == "resting" then
      if self.target.action == "jump_kicking" then
        self:blockingAction()
      elseif self.target.action ~= "dizzy" and self.target.action ~= "ko" then
        dice = math.random(1, 100)
        local moved = false
        if dice > 50 then
          moved = self:basicAutomaticMove()
        end
        print(moved)
        if moved == false then
          if dice > 70 and self.target.action ~= "resting" then
            self:blockingAction()
          elseif dice > 55 then
            self:punchingAction()
          elseif dice > 40 then
            self:kickingAction()
          elseif dice > 0 then
            self:specialAction()
          end
        end
      else
        dice = math.random(1, 100)
        if dice > 90 then
          self:basicAutomaticMove()
        else
          self:specialAction()
        end
      end
    end
  end

  function candidate:specialAction()
    local dice = math.random(1,100)
    if dice > 64 then
      self.action = "twitting"
    elseif dice > 48 then
      self.action = "phone_throwing"
    elseif dice > 32 then
      self.action = "steak_throwing"
    elseif dice >16 then
      self.action = "gold_bar_throwing"
    else
      self.action = "soda_throwing"
    end
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

  local twitting_frames = {
    1,
    33, 33,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    34,
  }
  candidate.animations["twitting"] = function(self)
    self.sprite:setFrame(twitting_frames[self.frame])
    if self.frame == 10 or self.frame == 13 or self.frame == 16 then
      self.effects_thingy:addProjectileTwit(self.parent_group, self, self.x + 20 * self.xScale, self.y - 30, self.z, self.xScale)
    end
    self.frame = self.frame + 1
    if (self.frame > #twitting_frames) then
      self:restingAction()
    end
  end

  local phone_throwing_frames = {
    1,
    33, 33,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    24, 24,
    25, 25,
    26, 26,
    27, 27,
  }
  candidate.animations["phone_throwing"] = function(self)
    self.sprite:setFrame(phone_throwing_frames[self.frame])
    if self.frame == 16 then
      self.effects_thingy:addProjectilePhone(self.parent_group, self, self.x + 20 * self.xScale, self.y - 30, self.z, self.xScale)
    end
    self.frame = self.frame + 1
    if (self.frame > #phone_throwing_frames) then
      self:restingAction()
    end
  end

  local steak_throwing_frames = {
    1,
    33, 33,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    24, 24,
    25, 25,
    26, 26,
    27, 27,
  }
  candidate.animations["steak_throwing"] = function(self)
    self.sprite:setFrame(steak_throwing_frames[self.frame])
    if self.frame == 16 then
      self.effects_thingy:addProjectileSteak(self.parent_group, self, self.x + 20 * self.xScale, self.y - 30, self.z, self.xScale)
    end
    self.frame = self.frame + 1
    if (self.frame > #steak_throwing_frames) then
      self:restingAction()
    end
  end

  local gold_bar_throwing_frames = {
    1,
    33, 33,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    24, 24,
    25, 25,
    26, 26,
    27, 27,
  }
  candidate.animations["gold_bar_throwing"] = function(self)
    self.sprite:setFrame(gold_bar_throwing_frames[self.frame])
    if self.frame == 16 then
      self.effects_thingy:addProjectileGoldBar(self.parent_group, self, self.x + 20 * self.xScale, self.y - 30, self.z, self.xScale)
    end
    self.frame = self.frame + 1
    if (self.frame > #gold_bar_throwing_frames) then
      self:restingAction()
    end
  end

  local soda_throwing_frames = {
    1,
    33, 33,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    34, 34, 35,
    24, 24,
    25, 25,
    26, 26,
    27, 27,
  }
  candidate.animations["soda_throwing"] = function(self)
    self.sprite:setFrame(soda_throwing_frames[self.frame])
    if self.frame == 16 then
      self.effects_thingy:addProjectileSoda(self.parent_group, self, self.x + 20 * self.xScale, self.y - 30, self.z, self.xScale)
    end
    self.frame = self.frame + 1
    if (self.frame > #soda_throwing_frames) then
      self:restingAction()
    end
  end

  function candidate:jumpingAction()
    self.action = "pre_jumping"
    self.stored_y_vel = self.y_vel
    self.stored_x_vel = self.x_vel
    self.x_vel = 0
    self.y_vel = 0
    self.frame = 1
  end

  candidate.pre_jumping_frames = {
    36, 36, 37, 37,
  }
  candidate.animations["pre_jumping"] = function(self)
    self.sprite:setFrame(self.pre_jumping_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #self.pre_jumping_frames) then
      self.action = "jumping"
      self.y_vel = self.stored_y_vel
      self.x_vel = self.stored_x_vel
      self.frame = 1
    end
  end

  candidate.animations["jumping"] = function(self)
    if self.y_vel < 0 then
      self.sprite:setFrame(38) -- go up
    elseif self.y_vel > 0 then
      self.sprite:setFrame(39) -- go down
    end
  end

  candidate.animations["jump_kicking"] = function(self)
    if self.frame == 1 or self.frame == 2 then
      self.sprite:setFrame(40)
    else
      self.sprite:setFrame(41)
    end
    self.frame = self.frame + 1
    if (self.frame > 7) then
      self.action = "jumping"
    end
  end

  candidate.blocking_frames = {31}

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
    1, 1,
    42,
    43, 43,
    44,
    45,
    46, 46,
    45,
    44,
    43, 43,
    42,
  }
  candidate.animations["celebrating"] = function(self)
    self.sprite:setFrame(celebrating_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #celebrating_frames) then
      self.frame = 1
      -- celebrating_frames = { -- short loop
      --   43, 43,
      --   44, 44,
      --   45, 45,
      --   46,
      --   45, 45,
      --   44, 44,
      -- }
    end
  end

  return candidate
end

return trump