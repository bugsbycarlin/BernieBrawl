
candidate = {}
candidate.__index = candidate

local function distance(x1, y1, x2, y2)
  return math.sqrt((x1-x2)^2 + (y1 - y2)^2)
end

function candidate:create(x, y, group, min_x, max_x, effects_thingy, sprite_offset)
  local tim = display.newGroup()

  tim.name = "tim"
  tim.short_name = "tim"

  tim.effects_thingy = effects_thingy

  tim.parent_group = group
  tim.parent_group:insert(tim)

  tim.x = x
  tim.y_offset = sprite_offset
  tim.x_vel = 0
  tim.y_vel = 0
  tim.y = y + tim.y_offset
  tim.rotation_vel = 0

  -- default values if none other are supplied
  tim.gravity = 4
  tim.resting_rate = 60
  tim.action_rate = 40
  tim.automatic_rate = 500
  tim.max_x_velocity = 20
  tim.max_y_velocity = 35
  tim.action_window = 1500
  tim.power = 10
  tim.knockback = 12

  tim.max_health = 100
  tim.health = tim.max_health
  tim.visible_health = tim.max_health

  tim.ko_frame = 1

  tim.swipe_history = {}

  tim.min_x = min_x
  tim.max_x = max_x

  tim.action = "resting"

  tim.damage_timer = 0
  tim.damage_in_a_row = 0

  tim.ground_target = display.contentCenterY + tim.y_offset

  tim.animationTimer = nil
  tim.physicsTimer = nil

  tim.frame = 1

  tim.target = nil
  tim.fighters = nil

  tim.enabled = false

  tim.animations = {}

  function tim:setMaxHealth(max_health)
    self.max_health = max_health
    self.health = max_health
    self.visible_health = max_health
  end

  function tim:enable()
    self.enabled = true
    self.animationTimer = timer.performWithDelay(self.resting_rate, function() self:animationLoop() end, 0)
    self.physicsTimer = timer.performWithDelay(33, function() self:physicsLoop() end, 0)
  end

  function tim:disable()
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

  function tim:enableAutomatic()
    self.automaticActionTimer = timer.performWithDelay(self.automatic_rate, function() self:automaticAction() end, 0)
  end

  function tim:disableAutomatic()
    self.enabled = false
    if self.automaticActionTimer ~= nil then
      timer.cancel(self.automaticActionTimer)
    end
  end

  function tim:automaticAction()
    
  end

  function tim:punchingAction()
    if self.action == "resting" then
      self.frame = 1
      self.animationTimer._delay = self.action_rate
      self.action = "punching"
    elseif self.action == "jumping" then
      self:jumpAttackAction()
    end
  end

  function tim:kickingAction()
    if self.action == "resting" then
      self.frame = 1
      self.animationTimer._delay = self.action_rate
      self.action = "kicking"
    elseif self.action == "jumping" then
      self:jumpAttackAction()
    end
  end

  function tim:jumpingAction()
    self.action = "jumping"
  end

  function tim:jumpAttackAction()
    self.action = "jump_kicking"
    self.frame = 1
  end

  function tim:specialAction()

  end

  function tim:checkSpecialAction()

  end

  function tim:moveAction(x_vel, y_vel)
    if self.action ~= "resting" then
      return
    end

    self:forceMoveAction(x_vel, y_vel)
  end

  function tim:forceMoveAction(x_vel, y_vel)
    -- Set velocity in the direction of the touch
    self.x_vel = math.max(-1 * self.max_x_velocity, math.min(self.max_x_velocity, x_vel))
    self.y_vel = math.max(-1 * self.max_y_velocity, math.min(self.max_y_velocity, y_vel))
    table.insert(self.swipe_history, {x_vel=self.x_vel, y_vel=self.y_vel, time=system.getTimer()})

    if self:checkSpecialAction(x_vel, y_vel) then
      return
    end
    
    -- check if there's substantial upward velocity, and if so, make this a jump
    if self.y_vel < -1 * self.max_y_velocity / 2 then
      self:jumpingAction()
    elseif math.abs(self.y_vel) < self.max_y_velocity / 6 then
      self.y_vel = 0
    end
  end

  function tim:damageAction(actor, extra_vel)

  end

  function tim:blockingAction()
    self.frame = 1
    self.after_image.isVisible = false
    self.animationTimer._delay = self.resting_rate
    self.rotation = 0
    self.action = "blocking"
  end

  function tim:damageAction(actor, extra_vel)
    self.sprite:setFrame(self.damaged_frames[1])
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

  function tim:koAction()
    self.action = "ko"
    self.damage_timer = 55
    self.y_vel = -20
    self.x_vel = -25 * self.xScale
  end

  function tim:dizzyAction()
    if self.action == "ko" then
      self.y = self.y - 60
    end
    self.action = "dizzy"
    self.animations["dizzy"](self)
    self.damage_timer = 45
    self.damage_in_a_row = 0
    for i = 1, 3, 1 do
      self.effects_thingy:addTwit(self, 0, -110 + math.random(1,20), 40 + math.random(1,20), 2250)
    end
  end

  function tim:celebratingAction()
    self.frame = 1
    self.after_image.isVisible = false
    self.animationTimer._delay = self.resting_rate
    self.rotation = 0
    self.action = "celebrating"
  end

  function tim:restingAction()
    self.frame = 1
    self.after_image.isVisible = false
    self.animationTimer._delay = self.resting_rate
    self.rotation = 0
    self.action = "resting"
  end

  function tim:animationLoop()
    if self.animations[self.action] ~= nil then
      self.animations[self.action](self)
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

  tim.animations["resting"] = function(self)
    self.sprite:setFrame(resting_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #resting_frames) then
      self.frame = 1
    end
  end

  function tim:physicsLoop()
    if #self.swipe_history > 0 
      and system.getTimer() - self.swipe_history[#self.swipe_history].time > self.action_window then
      self.swipe_history = {}
    end

    if self.x + self.x_vel > self.min_x and self.x + self.x_vel < self.max_x then
      self.x = self.x + self.x_vel
    end
    self.y = self.y + self.y_vel

    if math.abs(self.y_vel) < self.max_y_velocity / 4 and self.action ~= "ultra_punching" then
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
      if self.action ~= "ultra_punching" then
        self.y_vel = self.y_vel + self.gravity
      else
        self.y_vel = self.y_vel + self.gravity / 2
      end
    elseif (self.y >= current_ground_target and self.y_vel > 0) then
      self.y = current_ground_target
      self.y_vel = 0
      if self.action ~= "dizzy" then
        self.rotation_vel = 0
        self.rotation = 0
      end
      if self.action == "jumping" or self.action == "jump_kicking" then
        self:restingAction()
      end
      if self.action == "ko" then
        self.rotation = 0
        self.sprite:setFrame(self.ko_frame)
      end
    end

    if self.target ~= nil then
      if self.x > self.target.x + 10 and self.xScale == 1 and self.action == "resting" then
        self.xScale = -1
      end

      if self.x < self.target.x - 10 and self.xScale == -1 and self.action == "resting" then
        self.xScale = 1
      end
    end

    self:hitDetection()
  end

  function tim:hitDetection()
    hit_list = self.fighters
    if hit_list == nil then
      hit_list = {self.target}
    end

    if hit_list == nil then
      return
    end

    frame = self.sprite.frame
    hitIndex = self.hitIndex[frame]
    if hitIndex == nil then
      return
    end

    for i = 1, #hit_list do
      opponent = hit_list[i]

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

        -- to do: consult specific moves for damage, knockback, etc
        if collision == "reflect" then
          if self.action == "resting" then
            self.effects_thingy:randomDamage()
            self:forceMoveAction(-1 * self.knockback * self.xScale, -5)
            opponent:forceMoveAction(-1 * self.knockback * opponent.xScale, -5)
          else
            self:forceMoveAction(0, 0)
            opponent:forceMoveAction(0, 0)
          end
        elseif collision == "block" then
          self.effects_thingy:playSound("block")
          self:forceMoveAction(-0.5 * self.knockback * self.xScale, -3)
          opponent:forceMoveAction(-0.5 * self.knockback * opponent.xScale, -3)
        elseif collision == "stop" then
          self:forceMoveAction(self.x_vel / 2, self.y_vel)
          opponent:forceMoveAction(opponent.x_vel / 2, opponent.y_vel)
        elseif collision == "damage" then
          self.effects_thingy:randomDamage()
          self.damage_in_a_row = 0
          opponent:damageAction(self, self.knockback * self.xScale)
        end
      end
    end
  end

  return tim
end

return candidate