
local TrumpSpriteInfo = require("Source.Sprites.trumpSprite")
local TrumpSprite = graphics.newImageSheet("Art/trump_sprite.png", TrumpSpriteInfo:getSheet())

Trump = {}
Trump.__index = Trump

local gravity = 4
local max_x_velocity = 20
local max_y_velocity = 35

function Trump:create(x, y, group)
  local trump = display.newGroup()

  frames = {}
  for i = 1, #TrumpSpriteInfo.sheet.frames do
    table.insert(frames, i)
    print("Trump")
    print(i)
  end

  trump.name = "Donald Trump"

  group:insert(trump)
  trump.sprite = display.newSprite(trump, TrumpSprite, {frames=frames})
  trump.frameIndex = TrumpSpriteInfo.frameIndex
  trump.x = x
  trump.y_offset = 65
  trump.x_vel = 0
  trump.y_vel = 0
  trump.y = y + trump.y_offset

  trump.after_image = display.newSprite(trump, TrumpSprite, {frames=frames})
  trump.after_image.frameIndex = TrumpSpriteInfo.frameIndex
  trump.after_image.alpha = 0.5
  trump.after_image.isVisible = false

  trump.health = 100
  trump.visibleHealth = 100

  trump.action = nil
  trump.damage_timer = 0
  trump.damage_in_a_row = 0

  trump.power = 15

  trump.animationTimer = nil
  trump.physicsTimer = nil

  trump.frame = 1

  trump.target = nil
  trump.other_fighters = nil

  trump.enabled = false

  function trump:enable()
    self.enabled = true
    self.animationTimer = timer.performWithDelay(50, function() self:animationLoop() end, 0)
    self.physicsTimer = timer.performWithDelay(33, function() self:physicsLoop() end, 0)
  end

  function trump:enableAutomatic()
    self.automaticActionTimer = timer.performWithDelay(500, function() self:automaticAction() end, 0)
  end

  function trump:disable()
    self.enabled = false
    -- if self.animationTimer ~= nil then
    --   timer.cancel(self.animationTimer)
    -- end
    -- if self.physicsTimer ~= nil then
    --   timer.cancel(self.physicsTimer)
    -- end
    if self.automaticActionTimer ~= nil then
      timer.cancel(self.automaticActionTimer)
    end
  end

  function trump:automaticAction()
    print("in here")
    -- do return end
    if self.target == nil then
      return
    end
    if self.target.action ~= "dizzy" and self.target.action ~= "ko" then
      if math.abs(self.x - self.target.x) > 80 then
        if math.random(1, 100) > 20 then
          self:moveAction(10 * self.xScale, 0)
        else
          self:punchingAction()
        end
      else
        if math.random(1, 100) > 80 then
          self:moveAction(10 * self.xScale, 0)
        else
          self:punchingAction()
        end
      end
    else
      local dice = math.random(1, 100)
      if dice > 85 then
        self:moveAction(10 * self.xScale, 0)
      elseif dice > 50 then
        self:moveAction(-10 * self.xScale, 0)
      end
    end
  end

  function trump:punchingAction()
    if self.action == nil then
      self.frame = 1
      self.animationTimer._delay = 40
      self.action = "punching"
    end
  end

  function trump:kickingAction()
    if self.action == nil then
      self.frame = 1
      self.animationTimer._delay = 40
      self.action = "kicking"
    end

    if self.action == "jumping" then
      self.action = "jump_kicking"
    end
  end

  function trump:specialAction()
  end

  function trump:moveAction(x_vel, y_vel)
    if self.action ~= nil then
      return
    end

    -- Set velocity in the direction of the touch
    self.x_vel = math.max(-1 * max_x_velocity, math.min(max_x_velocity, x_vel))
    self.y_vel = -1 * math.max(0, math.min(max_y_velocity, -1 * y_vel))
    
    -- check if there's substantial upward velocity, and if so, make this a jump
    if math.abs(self.y_vel) > max_y_velocity / 2 then
      self.action = "jumping"

      -- if the time to impact is sufficiently long, then this is a flipping jump
      time_to_impact = -2 * self.y_vel / gravity 
      if math.abs(self.y_vel) > max_y_velocity / 1.2 then
        local alternator = 1
        if self.x_vel < 0 or (self.xScale == -1 and self.x_vel < 0) then
          alternator = -1
        end
        self.rotation_vel = 360.0 / time_to_impact * alternator
      end
    end
  end

  function trump:damageAction(actor)
    self.sprite:setFrame(self.frameIndex["damage"])
    self.after_image.isVisible = false
    self.x_vel = -15 * self.xScale
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

  function trump:koAction()
    self.action = "ko"
    self.damage_timer = 55
    self.y_vel = -20
    self.x_vel = -23 * self.xScale
  end

  function trump:restingAction()
    self.frame = 1
    self.after_image.isVisible = false
    self.animationTimer._delay = 50
    self.rotation = 0
    self.action = nil
  end

  function trump:animationLoop()
    if self.action == nil then
      self:restingAnimation()
    elseif self.action == "kicking" then
      self:kickingAnimation()
    elseif self.action == "punching" then
      self:punchingAnimation()
    elseif self.action == "jumping" then
      self:jumpingAnimation()
    elseif self.action == "dizzy" then
      self:dizzyAnimation()
    elseif self.action == "ko" then
      self:koAnimation()
    end

    if (self.damage_timer > 0) then
      self.damage_timer = self.damage_timer - 1  
      if self.damage_timer <= 0 and self.health > 0 then
        self:restingAction()
        if self.damage_in_a_row >= 4 then
          self.action = "dizzy"
          self.damage_timer = 45
          self.damage_in_a_row = 0
          self.rotation_vel = -1 * math.random(50, 100) / 30 * self.xScale
        end
      end
    end
  end


  local resting_frames = {
    1
  }
  function trump:restingAnimation()
    self.sprite:setFrame(resting_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #resting_frames) then
      self.frame = 1
    end
  end

  local kicking_frames = {
    1
  }
  function trump:kickingAnimation()
  end

  local punching_frames = {
    3, 3, 3, 3,
  }
  function trump:punchingAnimation()
    self.sprite:setFrame(punching_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #punching_frames) then
      self:restingAction()
    end
  end

  function trump:jumpingAnimation()
    -- if display.contentCenterY + self.y_offset - self.y > 60 then
    --   self.sprite:setFrame(20) -- flip
    -- elseif self.y_vel < 0 then
    --   self.sprite:setFrame(19) -- go up
    -- elseif self.y_vel > 0 then
    --   self.sprite:setFrame(21) -- go down
    -- end
  end

  function trump:dizzyAnimation()
    self.sprite:setFrame(2)
    if self.damage_timer % 9 == 0 then
      self.xScale = self.xScale * -1
    end
  end

  function trump:koAnimation()
    if self.xScale == 1 and self.rotation > -90 and self.y_vel ~= 0 then
      self.rotation = self.rotation - 7
    elseif self.xScale == -1 and self.rotation < 90 and self.y_vel ~= 0 then
      self.rotation = self.rotation + 7
    end
  end

  function trump:physicsLoop()
    self.x = self.x + self.x_vel
    self.y = self.y + self.y_vel

    self.x_vel = self.x_vel * 0.8

    if (self.action == "jumping" or self.action == "jump_kicking") and math.abs(self.rotation_vel) > 0 then
      self.rotation = self.rotation + self.rotation_vel
    end

    local ground_target = display.contentCenterY + self.y_offset
    if self.action == "ko" then
      ground_target = ground_target + 60
    end

    if (self.y < ground_target) then
      self.y_vel = self.y_vel + gravity
    else
      self.y = ground_target
      self.y_vel = 0
      if self.action ~= "dizzy" then
        self.rotation_vel = 0
        self.rotation = 0
      end
      if self.action == "jumping" or self.action == "jump_kicking" then
        self.action = nil
      end
      if self.action == "ko" then
        self.rotation = 0
        self.sprite:setFrame(2)
      end
    end

    if self.target ~= nil then
      if self.x > self.target.x + 10 and self.xScale == 1 and self.action == nil then
        self.xScale = -1
      end

      if self.x < self.target.x - 10 and self.xScale == -1 and self.action == nil then
        self.xScale = 1
      end
    end

    self:hitDetection()
  end

  function trump:hitDetection()
    if self.other_fighters == nil then
      return
    end
    for i = 1, #self.other_fighters do
      victim = self.other_fighters[i]
      if victim.action ~= "damaged" and victim.action ~= "ko" and self.action == "punching" then
        if (self.xScale == 1 and self.x -10 < victim.x and self.x + 105 > victim.x) or
          (self.xScale == -1 and self.x + 10 > victim.x and self.x - 105 < victim.x) then
          victim:damageAction(self)
        end
      end
    end
  end

  return trump
end

return Trump