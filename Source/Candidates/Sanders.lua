
local sandersSpriteInfo = require("Source.Sprites.sandersSprite")
local sandersSprite = graphics.newImageSheet("Art/sanders_sprite.png", sandersSpriteInfo:getSheet())

sanders = {}
sanders.__index = sanders

local gravity = 4

local resting_rate = 60
local action_rate = 40
local sprite_offset = 47

-- local power = 100
local power = 12
local knockback = 12
local blocking_max_frames = 30

local action_window = 1500

local function distance(x1, y1, x2, y2)
  return math.sqrt((x1-x2)^2 + (y1 - y2)^2)
end

function sanders:create(x, y, group, min_x, max_x, effects_thingy)
  local candidate = display.newGroup()

  candidate.frames = {}
  for i = 1, #sandersSpriteInfo.sheet.frames do
    table.insert(candidate.frames, i)
  end

  candidate.name = "Bernie Sanders"
  candidate.short_name = "sanders"

  candidate.effects_thingy = effects_thingy

  candidate.parent_group = group
  candidate.parent_group:insert(candidate)

  candidate.sprite = display.newSprite(candidate, sandersSprite, {frames=candidate.frames})
  candidate.hitIndex = sandersSpriteInfo.hitIndex
  candidate.x = x
  candidate.y_offset = sprite_offset
  candidate.x_vel = 0
  candidate.y_vel = 0
  candidate.y = y + candidate.y_offset
  candidate.rotation_vel = 0

  candidate.ko_frame = 33

  candidate.max_x_velocity = 20
  candidate.max_y_velocity = 35

  candidate.swipe_history = {}

  candidate.min_x = min_x
  candidate.max_x = max_x

  candidate.after_image = display.newSprite(candidate, sandersSprite, {frames=candidate.frames})
  candidate.after_image.alpha = 0.5
  candidate.after_image.isVisible = false

  candidate.health = 100
  candidate.visibleHealth = 100

  candidate.action = nil
  candidate.damage_timer = 0
  candidate.damage_in_a_row = 0

  candidate.power = power

  candidate.ground_target = display.contentCenterY + candidate.y_offset

  candidate.animationTimer = nil
  candidate.physicsTimer = nil

  candidate.frame = 1

  candidate.target = nil
  candidate.fighters = nil

  candidate.enabled = false

  function candidate:enable()
    self.enabled = true
    self.animationTimer = timer.performWithDelay(resting_rate, function() self:animationLoop() end, 0)
    self.physicsTimer = timer.performWithDelay(33, function() self:physicsLoop() end, 0)
  end

  function candidate:disable()
    self.enabled = false
    if self.animationTimer ~= nil then
      timer.cancel(self.animationTimer)
    end
    if self.physicsTimer ~= nil then
      timer.cancel(self.physicsTimer)
    end
    if self.automaticActionTimer ~= nil then
      timer.cancel(self.automaticActionTimer)
    end
  end

  function candidate:enableAutomatic()
    self.automaticActionTimer = timer.performWithDelay(300, function() self:automaticAction() end, 0)
  end

  function candidate:disableAutomatic()
    self.enabled = false
    if self.automaticActionTimer ~= nil then
      timer.cancel(self.automaticActionTimer)
    end
  end

  function candidate:automaticAction()
    
  end

  function candidate:punchingAction()
    if self.action == nil then
      self.frame = 1
      self.animationTimer._delay = action_rate
      self.action = "punching"
    elseif self.action == "jumping" then
      self:jumpAttackAction()
    end
  end

  function candidate:kickingAction()
    if self.action == nil then
      self.frame = 1
      self.animationTimer._delay = action_rate
      self.action = "kicking"
    elseif self.action == "jumping" then
      self:jumpAttackAction()
    end
  end

  function candidate:jumpAttackAction()
    self.action = "jump_kicking"
    self.frame = 1
    -- self.sprite:setFrame(33)
    --self:forceMoveAction(10*self.xScale, 0)
  end

  function candidate:specialAction()
    self.action = "summoning"
    self.frame = 1
  end

  function candidate:moveAction(x_vel, y_vel)
    if self.action ~= nil then
      return
    end

    self:forceMoveAction(x_vel, y_vel)
  end

  function candidate:forceMoveAction(x_vel, y_vel)
    -- Set velocity in the direction of the touch
    self.x_vel = math.max(-1 * self.max_x_velocity, math.min(self.max_x_velocity, x_vel))
    self.y_vel = math.max(-1 * self.max_y_velocity, math.min(self.max_y_velocity, y_vel))
    print("Y velocity is")
    print(self.y_vel)
    table.insert(self.swipe_history, {x_vel=self.x_vel, y_vel=self.y_vel, time=system.getTimer()})




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
        return
      end
    end
    
    -- check if there's substantial backward velocity with downward velocity,
    -- and if so, make this a block
    -- if (self.xScale == 1 and self.x_vel < -1 * self.max_x_velocity / 2 and self.y_vel > self.max_y_velocity / 10)
    --   or (self.xScale == -1 and self.x_vel > self.max_x_velocity / 2 and self.y_vel > self.max_y_velocity / 10) then
    --   self.y_vel = 0
    --   self:blockingAction()
    
    -- check if there's substantial upward velocity, and if so, make this a jump
    if self.y_vel < -1 * self.max_y_velocity / 2 then
      self.action = "jumping"

      -- if the time to impact is sufficiently long, then this is a flipping jump
      -- time_to_impact = -2 * self.y_vel / gravity 
      -- if math.abs(self.y_vel) > self.max_y_velocity / 1.2 then
      --   local alternator = 1
      --   if self.x_vel < 0 or (self.xScale == -1 and self.x_vel < 0) then
      --     alternator = -1
      --   end
      --   self.rotation_vel = 360.0 / time_to_impact * alternator
      -- end
    elseif math.abs(self.y_vel) < self.max_y_velocity / 6 then
      self.y_vel = 0
    end
  end

  function candidate:damageAction(actor, extra_vel)
    self.sprite:setFrame(31)
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

  function candidate:blockingAction()
    self.frame = 1
    self.after_image.isVisible = false
    self.animationTimer._delay = resting_rate
    self.rotation = 0
    self.action = "blocking"
  end

  function candidate:koAction()
    self.action = "ko"
    self.damage_timer = 55
    self.y_vel = -20
    self.x_vel = -25 * self.xScale
  end

  function candidate:dizzyAction()
    if self.action == "ko" then
      self.y = self.y - 60
    end
    self.action = "dizzy"
    self:dizzyAnimation()
    self.damage_timer = 45
    self.damage_in_a_row = 0
    for i = 1, 3, 1 do
      self.effects_thingy:addTwit(self, 0, -110 + math.random(1,20), 40 + math.random(1,20), 2250)
    end
  end

  function candidate:celebratingAction()
    self.frame = 1
    self.after_image.isVisible = false
    self.animationTimer._delay = resting_rate
    self.rotation = 0
    self.action = "celebrating"
  end

  function candidate:restingAction()
    self.frame = 1
    self.frame = math.random(1, 32)
    self.after_image.isVisible = false
    self.animationTimer._delay = resting_rate
    self.rotation = 0
    self.action = nil
  end

  function candidate:animationLoop()
    if self.action == nil then
      self:restingAnimation()
    elseif self.action == "kicking" then
      self:kickingAnimation()
    elseif self.action == "punching" then
      self:punchingAnimation()
    elseif self.action == "summoning" then
      self:summoningAnimation()
    elseif self.action == "jumping" then
      self:jumpingAnimation()
    elseif self.action == "jump_kicking" then
      self:jumpKickingAnimation()
    elseif self.action == "blocking" then
      self:blockingAnimation()
    elseif self.action == "dizzy" then
      self:dizzyAnimation()
    elseif self.action == "ko" then
      self:koAnimation()
    elseif self.action == "celebrating" then
      self:celebratingAnimation()
    end

    if (self.damage_timer > 0) then
      self.damage_timer = self.damage_timer - 1  
      if self.damage_timer <= 0 and self.health > 0 then
        if self.action == "ko" then
          self:dizzyAction()
        else
          self:restingAction()
        end
      end
    end
  end


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
  function candidate:restingAnimation()
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
  function candidate:kickingAnimation()
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
  function candidate:punchingAnimation()
    self.sprite:setFrame(punching_frames[self.frame])
    -- if self.frame == 5 or self.frame == 13 then
    --   self:forceMoveAction(10*self.xScale, 0)
    --   self.effects_thingy:playSound("swing_1")
    -- end
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
  function candidate:summoningAnimation()
    self.sprite:setFrame(summoning_frames[self.frame])
    self.frame = self.frame + 1
    if self.frame == 6 then
      self.effects_thingy:addBro(self.parent_group, self, self.x - 250, self.y + 100, 10, -30, self.min_x, self.max_x)
    end
    if self.frame == 12 then
      self.effects_thingy:addBro(self.parent_group, self, self.x + 250, self.y + 100, -10, -30, self.min_x, self.max_x)
    end
    if (self.frame > #summoning_frames) then
      self:restingAction()
    end
  end

  function candidate:jumpingAnimation()
    if self.y_vel < 0 then
      self.sprite:setFrame(22) -- go up
    elseif self.y_vel > 0 then
      self.sprite:setFrame(24) -- go down
    end
  end

  function candidate:jumpKickingAnimation()
    self.sprite:setFrame(23)
    self.frame = self.frame + 1
    if (self.frame > 5) then
      self.action = "jumping"
    end
  end

  function candidate:blockingAnimation()
    self.sprite:setFrame(30)
    self.frame = self.frame + 1
    if self.frame > blocking_max_frames then
      self:restingAction()
    end
  end

  function candidate:dizzyAnimation()
    self.sprite:setFrame(32)
  end

  function candidate:koAnimation()
    if self.xScale == 1 and self.rotation > -90 and self.y_vel ~= 0 then
      self.rotation = self.rotation - 7
    elseif self.xScale == -1 and self.rotation < 90 and self.y_vel ~= 0 then
      self.rotation = self.rotation + 7
    end
  end

  local celebrating_frames = {
    29, 29, 29, 29, 29, 29, 29,
  }
  function candidate:celebratingAnimation()
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

  function candidate:physicsLoop()
    if #candidate.swipe_history > 0 
      and system.getTimer() - candidate.swipe_history[#candidate.swipe_history].time > action_window then
      print("Was " .. #candidate.swipe_history)
      candidate.swipe_history = {}
      print("clearing")
    end

    if self.x + self.x_vel > self.min_x and self.x + self.x_vel < self.max_x then
      self.x = self.x + self.x_vel
    end
    self.y = self.y + self.y_vel

    if math.abs(self.y_vel) < self.max_y_velocity / 4 then
      self.x_vel = self.x_vel * 0.8
    else
      self.x_vel = self.x_vel * 0.9
    end

    if (self.action == "jumping" or self.action == "jump_kicking") and math.abs(self.rotation_vel) > 0 then
      self.rotation = self.rotation + self.rotation_vel
    end

    local current_ground_target = self.ground_target
    if self.action == "ko" then
      current_ground_target = current_ground_target + 60
    end

    if (self.y < current_ground_target) then
      self.y_vel = self.y_vel + gravity
    elseif (self.y >= current_ground_target and self.y_vel > 0) then
      self.y = current_ground_target
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
        self.sprite:setFrame(self.ko_frame)
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

  function candidate:hitDetection()
    if self.fighters == nil then
      return
    end

    frame = self.sprite.frame
    hitIndex = self.hitIndex[frame]
    if hitIndex == nil then
      return
    end

    for i = 1, #self.fighters do
      opponent = self.fighters[i]

      
      if opponent.name ~= self.name and opponent.action ~= "damaged" and opponent.action ~= "ko" then

        opponent_frame = opponent.sprite.frame
        opponent_hitIndex = opponent.hitIndex[opponent_frame]

        collision = nil

        for j = 1, #hitIndex do
          if hitIndex[j].purpose ~= "vulnerability" and opponent_hitIndex ~= nil then
            for k = 1, #opponent_hitIndex do
              x1, y1 = self:localToContent(hitIndex[j].x, hitIndex[j].y)
              x2, y2 = opponent:localToContent(opponent_hitIndex[k].x, opponent_hitIndex[k].y)
              if distance(x1, y1, x2, y2) < hitIndex[j].radius + opponent_hitIndex[k].radius then
                if hitIndex[j].purpose == "attack" and opponent_hitIndex[k].purpose == "vulnerability" then
                  collision = "damage"
                elseif hitIndex[j].purpose == "attack" and opponent_hitIndex[k].purpose == "defense" and collision == nil then
                  collision = "block" 
                  print("a block happened") 
                elseif hitIndex[j].purpose == "defense" and opponent_hitIndex[k].purpose == "defense" and collision == nil then
                  collision = "stop"
                elseif hitIndex[j].purpose == "attack" and opponent_hitIndex[k].purpose == "attack" and collision == nil then
                  collision = "reflect"
                end
              end
            end
          end
        end

        if collision == "reflect" then
          if self.action == nil then
            self.effects_thingy:randomDamage()
            self:forceMoveAction(-1 * knockback * self.xScale, -5)
            opponent:forceMoveAction(-1 * knockback * opponent.xScale, -5)
          else
            self:forceMoveAction(0, 0)
            opponent:forceMoveAction(0, 0)
          end
        elseif collision == "block" then
          self.effects_thingy:playSound("block")
          print("doing the block thing")
          self:forceMoveAction(-0.5 * knockback * self.xScale, -3)
          opponent:forceMoveAction(-0.5 * knockback * opponent.xScale, -3)
        elseif collision == "stop" then
          self:forceMoveAction(self.x_vel / 2, self.y_vel)
          opponent:forceMoveAction(opponent.x_vel / 2, opponent.y_vel)
        elseif collision == "damage" then
          self.effects_thingy:randomDamage()
          self.damage_in_a_row = 0
          opponent:damageAction(self, knockback * self.xScale)
        end
      end
    end
  end

  return candidate
end

return sanders