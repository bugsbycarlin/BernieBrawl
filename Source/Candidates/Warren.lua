
local WarrenSpriteInfo = require("Source.Sprites.warrenSprite")
local WarrenSprite = graphics.newImageSheet("Art/warren_sprite.png", WarrenSpriteInfo:getSheet())

local WhipSpriteInfo = require("Source.Sprites.whipSprite")
local WhipSprite = graphics.newImageSheet("Art/whip_sprite.png", WhipSpriteInfo:getSheet())

Warren = {}
Warren.__index = Warren

local gravity = 4
local max_x_velocity = 20
local max_y_velocity = 35

local function distance(x1, y1, x2, y2)
  return math.sqrt((x1-x2)^2 + (y1 - y2)^2)
end

function Warren:create(x, y, group)
  local warren = display.newGroup()

  warren.frames = {}
  for i = 1, #WarrenSpriteInfo.sheet.frames do
    table.insert(warren.frames, i)
  end

  warren.name = "Elizabeth Warren"

  group:insert(warren)
  warren.sprite = display.newSprite(warren, WarrenSprite, {frames=warren.frames})
  warren.frameIndex = WarrenSpriteInfo.frameIndex
  warren.hitIndex = WarrenSpriteInfo.hitIndex
  -- for i = 1, #warren.hitIndex do
  --   print(i .. ": " .. #warren.hitIndex[i])
  -- end
  warren.x = x
  warren.y_offset = 60
  warren.x_vel = 0
  warren.y_vel = 0
  warren.y = y + warren.y_offset

  warren.after_image = display.newSprite(warren, WarrenSprite, {frames=warren.frames})
  warren.after_image.frameIndex = WarrenSpriteInfo.frameIndex
  warren.after_image.alpha = 0.5
  warren.after_image.isVisible = false

  warren.whip_image = display.newSprite(warren, WhipSprite, {frames={1,2,3,4,5}})
  warren.whip_image.isVisible = false

  warren.health = 100
  warren.visibleHealth = 100

  warren.action = nil
  warren.damage_timer = 0
  warren.damage_in_a_row = 0

  warren.power = 5

  warren.animationTimer = nil
  warren.physicsTimer = nil

  warren.frame = 1

  warren.target = nil
  warren.other_fighters = nil

  warren.enabled = false

  function warren:enable()
    self.enabled = true
    self.animationTimer = timer.performWithDelay(50, function() self:animationLoop() end, 0)
    self.physicsTimer = timer.performWithDelay(33, function() self:physicsLoop() end, 0)
  end

  function warren:enableAutomatic()
    self.automaticActionTimer = timer.performWithDelay(500, function() self:automaticAction() end, 0)
  end

  function warren:disable()
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

  function warren:automaticAction()

  end

  function warren:punchingAction()
    if self.action == nil then
      self.frame = 1
      self.animationTimer._delay = 40
      self.action = "punching"
    end
  end

  function warren:kickingAction()
    if self.action == nil then
      self.frame = 1
      self.animationTimer._delay = 40
      self.action = "kicking"
    end

    if self.action == "jumping" then
      self.action = "jump_kicking"
    end
  end

  function warren:specialAction()
    if self.action == nil then
      self.frame = 1
      self.animationTimer._delay = 40
      self.action = "whipping"
      self.whip_image.isVisible = true
    end
  end

  function warren:moveAction(x_vel, y_vel)
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

  function warren:damageAction(actor, extra_vel)
    self.sprite:setFrame(self.frameIndex["damage"])
    self.after_image.isVisible = false
    self.x_vel = -15 * self.xScale
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

  function warren:koAction()
    self.action = "ko"
    self.damage_timer = 55
    self.y_vel = -20
    self.x_vel = -23 * self.xScale
  end

  function warren:restingAction()
    self.frame = 1
    self.after_image.isVisible = false
    self.whip_image.isVisible = false
    self.animationTimer._delay = 50
    self.rotation = 0
    self.action = nil
  end

  function warren:animationLoop()
    if self.action == nil then
      self:restingAnimation()
    elseif self.action == "kicking" then
      self:kickingAnimation()
    elseif self.action == "punching" then
      self:punchingAnimation()
    elseif self.action == "whipping" then
      self:whippingAnimation()
    elseif self.action == "jumping" then
      self:jumpingAnimation()
    elseif self.action == "jump_kicking" then
      self:jumpKickingAnimation()
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
  function warren:restingAnimation()
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
  function warren:kickingAnimation()
    self.sprite:setFrame(kicking_frames[self.frame])
    if (self.frame >= 7) then
      self.after_image.isVisible = true
      self.after_image:setFrame(kicking_frames[self.frame - 1])
    end
    if self.frame == 9 or self.frame == 11 then
      if self.xScale == 1 then
        self.x = self.x + 20
      else
        self.x = self.x - 20
      end
    end
    if self.frame == 13 then
      if self.xScale == 1 then
        self.x = self.x + 40
      else
        self.x = self.x - 40
      end
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
  function warren:punchingAnimation()
    self.sprite:setFrame(punching_frames[self.frame])
    if self.frame == 3 or self.frame == 7 or self.frame == 13 then
      -- punch(self, self.target)
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
  function warren:whippingAnimation()
    self.sprite:setFrame(whipping_frames[self.frame])
    self.whip_image:setFrame(actual_whip_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #whipping_frames) then
      self:restingAction()
    end
  end

  function warren:jumpingAnimation()
    if display.contentCenterY + self.y_offset - self.y > 60 then
      self.sprite:setFrame(20) -- flip
    elseif self.y_vel < 0 then
      self.sprite:setFrame(19) -- go up
    elseif self.y_vel > 0 then
      self.sprite:setFrame(21) -- go down
    end
  end

  function warren:jumpKickingAnimation()
    if display.contentCenterY + self.y_offset - self.y > 60 or self.y_vel < 0 then
      self.sprite:setFrame(11) -- kick
    else
      self.sprite:setFrame(20) -- go down
    end
  end

  function warren:dizzyAnimation()
    self.sprite:setFrame(24)
    if self.damage_timer % 9 == 0 then
      self.xScale = self.xScale * -1
    end
  end

  function warren:koAnimation()
    if self.xScale == 1 and self.rotation > -90 and self.y_vel ~= 0 then
      self.rotation = self.rotation - 7
    elseif self.xScale == -1 and self.rotation < 90 and self.y_vel ~= 0 then
      self.rotation = self.rotation + 7
    end
  end

  function warren:physicsLoop()
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
        self.sprite:setFrame(23)
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

    -- hit detection
    self:hitDetection()
  end

  -- function warren:hitDetection()
  --   if self.other_fighters == nil then
  --     return
  --   end
  --   for i = 1, #self.other_fighters do
  --     victim = self.other_fighters[i]
      
  --     if victim.action ~= "damaged" and victim.action ~= "ko" then
  --       if self.action == "punching" then
  --         if self.frame == 3 or self.frame == 7 or self.frame == 13 then
  --           if (self.xScale == 1 and self.x - 10 < victim.x and self.x + 105 > victim.x) or
  --             (self.xScale == -1 and self.x + 10 > victim.x and self.x - 105 < victim.x) then
  --             victim:damageAction(self)
  --           end
  --         end
  --       elseif self.action == "kicking" then
  --         if self.frame == 3 or self.frame == 9 then
  --           if (self.xScale == 1 and self.x - 10 < victim.x and self.x + 105 > victim.x) or
  --             (self.xScale == -1 and self.x + 10 > victim.x and self.x - 105 < victim.x) then
  --             victim:damageAction(self)
  --           end
  --         end
  --       elseif self.action == "whipping" then
  --         if (self.frame == 6) then
  --           if math.abs(self.x - victim.x) < 200 then
  --             victim:damageAction(self)
  --             victim.damage_timer = 50
  --           end
  --           -- audio.play(punch_sound)
  --         end
  --       end
  --     end
  --   end
  -- end

  function warren:hitDetection()
    -- to do: this should maybe run when the frame has changed instead of on the physics timer
    if self.other_fighters == nil then
      return
    end

    frame = self.sprite.frame
    hitIndex = self.hitIndex[frame]
    if hitIndex == nil then
      return
    end

    for i = 1, #self.other_fighters do
      opponent = self.other_fighters[i]

      
      if opponent.action ~= "damaged" and opponent.action ~= "ko" then

        opponent_frame = opponent.sprite.frame
        opponent_hitIndex = opponent.hitIndex[opponent_frame]

        collision = nil

        for j = 1, #hitIndex do
          if hitIndex[j].purpose ~= "vulnerability" and opponent_hitIndex ~= nil then
            for k = 1, #opponent_hitIndex do
              x1, y1 = self:localToContent(hitIndex[j].x, hitIndex[j].y)
              x2, y2 = opponent:localToContent(opponent_hitIndex[k].x, opponent_hitIndex[k].y)
              if distance(x1, y1, x2, y2) < hitIndex[j].radius + opponent_hitIndex[k].radius then
                if hitIndex[j].purpose == "attack" and opponent_hitIndex[k].purpose == "vulnerability" and collision ~= "reflect" then
                  collision = "damage"
                elseif collision == nil then
                  collision = "reflect"
                end
              end
            end
          end
        end

        if collision == "reflect" then
          self:moveAction(-15 * self.xScale, -5)
          opponent:moveAction(-15 * opponent.xScale, -5)
        elseif collision == "damage" then
          opponent:damageAction(self, 15 * self.xScale)
        end
      end
    end
  end

  return warren
end

return Warren