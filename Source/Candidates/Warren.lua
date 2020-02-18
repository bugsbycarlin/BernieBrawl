
local candidate_template = require("Source.Candidates.candidate")

local warrenSpriteInfo = require("Source.Sprites.warrenSprite")
local warrenSprite = graphics.newImageSheet("Art/warren_sprite.png", warrenSpriteInfo:getSheet())

local WhipSpriteInfo = require("Source.Sprites.whipSprite")
local WhipSprite = graphics.newImageSheet("Art/whip_sprite.png", WhipSpriteInfo:getSheet())

warren = {}
warren.__index = warren

local blocking_max_frames = 30

function warren:create(x, y, group, min_x, max_x, effects_thingy)
  local candidate = candidate_template:create(x, y, group, min_x, max_x, effects_thingy, 50)

  candidate.resting_rate = 50
  candidate.action_rate = 40
  candidate.power = 7
  candidate.knockback = 10
  candidate.automatic_rate = 350

  candidate.frames = {}
  for i = 1, #warrenSpriteInfo.sheet.frames do
    table.insert(candidate.frames, i)
  end

  candidate.name = "Elizabeth Warren"
  candidate.short_name = "warren"

  candidate.sprite = display.newSprite(candidate, warrenSprite, {frames=candidate.frames})
  candidate.hitIndex = warrenSpriteInfo.hitIndex

  candidate.after_image = display.newSprite(candidate, warrenSprite, {frames=candidate.frames})
  candidate.after_image.alpha = 0.5
  candidate.after_image.isVisible = false

  candidate.whip_image = display.newSprite(candidate, WhipSprite, {frames={1,2,3,4,5}})
  candidate.whip_image.isVisible = false

  candidate.ko_frame = 23

  function candidate:automaticAction()
    self:punchingAction()
    do return end
    dice = math.random(1, 100)
    if dice > 90 then
      self:moveAction(10 * self.xScale, 0)
    elseif dice > 45 then
      self:punchingAction()
    else
      self:kickingAction()
    end
  end

  function candidate:specialAction()
    self.frame = 1
    self.animationTimer._delay = self.action_rate
    self.action = "whipping"
    self.effects_thingy:playSound("whip_swing")
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
        and math.abs(x_vel_3) > self.max_x_velocity / 1.25 and x_vel_3 * self.xScale > 0 
        and math.abs(y_vel_3) < self.max_y_velocity / 5 then

        self.y_vel = 0
        self:specialAction()
        return true
      end
    end

    return false
  end

  candidate.parentForceMoveAction = candidate.forceMoveAction
  function candidate:forceMoveAction(x_vel, y_vel)
    self:parentForceMoveAction(x_vel, y_vel)
    
    -- check if there's substantial upward velocity, and if so, make this a jump
    if self.y_vel < -1 * self.max_y_velocity / 2 then
      self:jumpingAction()

      -- if the time to impact is sufficiently long, then this is a flipping jump
      time_to_impact = -2 * self.y_vel / self.gravity 
      if math.abs(self.y_vel) > self.max_y_velocity / 1.2 then
        local alternator = 1
        if self.x_vel < 0 or (self.xScale == -1 and self.x_vel < 0) then
          alternator = -1
        end
        self.rotation_vel = 360.0 / time_to_impact * alternator
      end
    else
      self.y_vel = 0
    end
  end

  candidate.damaged_frames = {
    22
  }

  candidate.parentAnimationLoop = candidate.animationLoop
  function candidate:animationLoop()
    if self.action == "whipping" then
      self.whip_image.isVisible = true
    else
      self.whip_image.isVisible = false
    end

    self:parentAnimationLoop()
  end


  local resting_frames = {
    5, 5, 5,
    6, 6, 6,
    5, 5, 5,
    1, 1, 1,
    5, 5, 5,
    6, 6, 6,
    5, 5,
    1, 1,
    2, 2,
    3, 3,
    4, 4
  }
  candidate.animations["resting"] = function(self)
    self.sprite:setFrame(resting_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #resting_frames) then
      self.frame = 1
    end
  end

  local kicking_frames = {
    7, 7,
    8, 8,
    9, 9,
    10, 10,
    11, 11,
    12, 12,
    9, 9,
  }
  candidate.animations["kicking"] = function(self)
    self.sprite:setFrame(kicking_frames[self.frame])
    if (self.frame >= 7) then
      self.after_image.isVisible = true
      self.after_image:setFrame(kicking_frames[self.frame - 1])
    end
    if self.frame == 3 or self.frame == 8 then
      self.effects_thingy:playSound("swing_1")
    end
    if self.frame == 9 or self.frame == 11 then
      -- self.x = self.x + 20 * self.xScale
      self:forceMoveAction(13*self.xScale, 0)
      -- if self.xScale == 1 then
      --   self.x = self.x + 20
      -- else
      --   self.x = self.x - 20
      -- end
    end
    if self.frame == 13 then
      -- self.x = self.x + 40 * self.xScale
      -- if self.xScale == 1 then
      --   self.x = self.x + 40
      -- else
      --   self.x = self.x - 40
      -- end
      self:forceMoveAction(13*self.xScale, 0)
    end
    self.frame = self.frame + 1
    if (self.frame > #kicking_frames) then
      self:restingAction()
    end
  end

  local punching_frames = {
    13, 13,
    14, 14,
    15, 15,
    14, 14,
    15, 15,
    16, 16,
    17, 17, 17, 17,
    16, 16,
  }
  candidate.animations["punching"] = function(self)
    self.sprite:setFrame(punching_frames[self.frame])
    if self.frame == 3 then
      self.effects_thingy:playSound("swing_3")
      self:forceMoveAction(8*self.xScale, 0)
    elseif self.frame == 7 then
      self.effects_thingy:playSound("swing_3")
      self:forceMoveAction(8*self.xScale, 0)
    elseif self.frame == 13 then
      -- punch(self, self.target)
      self.effects_thingy:playSound("swing_1")
      self:forceMoveAction(10*self.xScale, 0)
    end
    self.frame = self.frame + 1
    if (self.frame > #punching_frames) then
      self:restingAction()
    end
  end

  local whipping_frames = {
    3, 3,
    16, 16,
    17, 17, 17, 17, 17, 17, 17, 17,
    18, 18, 18,
  }
  local actual_whip_frames = {
    1, 1,
    2, 2,
    3, 3, 4, 4, 4, 4, 4, 4,
    5, 5, 5,
  }
  candidate.animations["whipping"] = function(self)
    self.sprite:setFrame(whipping_frames[self.frame])
    self.whip_image:setFrame(actual_whip_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #whipping_frames) then
      self:restingAction()
    end
  end

  candidate.animations["jumping"] = function(self)
    if display.contentCenterY + self.y_offset - self.y > 60 then
      self.sprite:setFrame(20) -- flip
    elseif self.y_vel < 0 then
      self.sprite:setFrame(19) -- go up
    elseif self.y_vel > 0 then
      self.sprite:setFrame(21) -- go down
    end
  end

  candidate.animations["jump_kicking"] = function(self)
    if display.contentCenterY + self.y_offset - self.y > 60 or self.y_vel < 0 then
      self.sprite:setFrame(11) -- kick
    else
      self.sprite:setFrame(20) -- go down
    end
  end

  candidate.animations["blocking"] = function(self)
    self.sprite:setFrame(25)
    self.frame = self.frame + 1
    if self.frame > blocking_max_frames then
      self:restingAction()
    end
  end

  candidate.animations["dizzy"] = function(self)
    self.sprite:setFrame(24)
  end

  candidate.animations["ko"] = function(self)
    if self.xScale == 1 and self.rotation > -90 and self.y_vel ~= 0 then
      self.rotation = self.rotation - 7
    elseif self.xScale == -1 and self.rotation < 90 and self.y_vel ~= 0 then
      self.rotation = self.rotation + 7
    end
  end

  local celebrating_frames = {
    25, 25,
    26, 26, 26, 26, 26,
    25, 25,
    26, 26, 26, 26, 26,
    7, 7,
    8, 8,
    9, 9,
  }
  candidate.animations["celebrating"] = function(self)
    self.sprite:setFrame(celebrating_frames[self.frame])
    if self.frame == 3 or self.frame == 10 then
      self.y_vel = -10
      self.xScale = self.xScale * -1
    end
    self.frame = self.frame + 1
    if (self.frame > #celebrating_frames) then
      self.frame = 1
    end
  end

  return candidate
end

return warren