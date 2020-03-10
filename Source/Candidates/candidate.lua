
candidate = {}
candidate.__index = candidate

local z_threshold = 40
candidate.default_ground_target = 535

local function distance(x1, y1, x2, y2)
  -- whyyyyy?
  if x2 == nil then
    return 100000
  end
  return math.sqrt((x1-x2)^2 + (y1 - y2)^2)
end

function candidate:create(x, y, group, min_x, max_x, min_z, max_z, effects, sprite_offset)
  local tim = display.newGroup()

  tim.name = "tim"
  tim.short_name = "tim"

  tim.effects = effects

  tim.parent_group = group
  tim.parent_group:insert(tim)

  tim.x = x
  tim.y_offset = sprite_offset
  tim.x_vel = 0
  tim.y_vel = 0
  tim.y = y + tim.y_offset
  tim.z = 0
  tim.z_vel = 0
  tim.rotation_vel = 0

  -- default values if none other are supplied
  tim.gravity = 4
  tim.resting_rate = 60
  tim.action_rate = 40
  tim.automatic_rate = 500
  tim.max_x_velocity = 20
  tim.max_y_velocity = 35
  tim.max_z_velocity = 10
  tim.action_window = 1500
  tim.punching_power = 9
  tim.kicking_power = 12
  tim.knockback = 12
  tim.blocking_max_frames = 30

  tim.whooping_threshold = 7

  tim.max_health = 100
  tim.health = tim.max_health
  tim.visible_health = tim.max_health

  tim.ko_frame = 1
  tim.ko_time = 55

  tim.can_blink = true

  tim.script_offset_x = 50
  tim.script_offset_y = -105
  tim.script_side = "right"

  tim.swipe_history = {}

  tim.min_x = min_x
  tim.max_x = max_x

  tim.min_z = min_z
  tim.max_z = max_z

  tim.shake_screen_on_contact = false

  tim.action = "resting"

  tim.move_decay = 0
  tim.move_direction = nil
  tim.moving = false
  tim.animate_move = false

  tim.damage_timer = 0
  tim.damage_in_a_row = 0

  tim.ground_target = candidate.default_ground_target + tim.y_offset

  tim.animationTimer = nil
  tim.physicsTimer = nil

  tim.frame = 1

  tim.target = nil
  tim.fighters = nil

  tim.enabled = false

  tim.animations = {}

  tim.attack = nil

  tim.flexible_target = false
  tim.side = ""

  -- tim.shadow = display.newImageRect(tim, "Art/shadow.png", 128, 128)
  -- tim.shadow.y = tim.ground_target - tim.y

  function tim:setZ(z_value)
    -- if z_value < min_z then
    --   self:setZ(min_z)
    -- elseif z_value > max_z then
    --   self:setZ(max_z)
    -- else
    --   self.z = z_value
    --   self.sprite.y = z_value
    --   self.after_image.y = z_value
    --   -- self.shadow.y = self.ground_target - self.y + self.y_offset + z_value
    -- end
    self.z = z_value
    self.sprite.y = z_value
    self.after_image.y = z_value
  end

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
    for i = 1,#self.fighters do
      if self.fighters[i].target == self then
        self.fighters[i].target = nil
      end
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

  function tim:basicAutomaticMove()
    local moved = false

    if self.target == nil then
      dice = math.random(1, 100)
      if dice > 50 then
        self:moveAction(10, 0)
      else
        self:moveAction(-10, 0)
      end
      return true
    end

    if self.x < self.target.x - 96 then
      self:moveAction(10, 0)
      moved = true
    elseif self.x > self.target.x + 96 then
      self:moveAction(-10, 0)
      moved = true
    end

    if self.action == "resting" then
      if self.z < self.target.z - z_threshold then
        self:zMoveAction(self.max_z_velocity * 0.7)
        moved = true
      elseif self.z > self.target.z + z_threshold then
        self:zMoveAction(-1 * self.max_z_velocity * 0.7)
        moved = true
      end
    end

    return moved
  end

  function tim:punchingAction()
    if self.action == "resting" then
      self.move_decay = 0
      self.moving = false
      self.frame = 1
      self.animationTimer._delay = self.action_rate
      self.action = "punching"
      self.attack = {power=tim.punching_power, knockback=tim.knockback}
    elseif self.action == "jumping" then
      self:jumpAttackAction()
    end
  end

  function tim:kickingAction()
    if self.action == "resting" then
      self.move_decay = 0
      self.moving = false
      self.frame = 1
      self.animationTimer._delay = self.action_rate
      self.action = "kicking"
      self.attack = {power=tim.kicking_power, knockback=tim.knockback}
    elseif self.action == "jumping" then
      self:jumpAttackAction()
    end
  end

  function tim:jumpingAction()
    self.move_decay = 0
    self.moving = false
    self.action = "jumping"
  end

  function tim:jumpAttackAction()
    self.move_decay = 0
    self.moving = false
    self.action = "jump_kicking"
    self.frame = 1
    self.attack = {power=2 * tim.kicking_power, knockback=tim.knockback}
  end

  function tim:specialAction()

  end

  function tim:checkSpecialAction()

  end

  function tim:moveAction(x_vel, y_vel)
    if self.action ~= "resting" and self.action ~= "moving" then
      return
    end

    self.move_decay = 0
    self.moving = true

    if x_vel > 0.1 then
      self.move_direction = "right"
    elseif x_vel < 0.1 then
      self.move_direction = "left"
    else
      self.move_direction = nil
    end

    self:forceMoveAction(x_vel, y_vel)

    if self.target == nil or self.target.action == "ko" or self.target.action == "blinking" then
      if self.x_vel < 0 then
        self.xScale = -1
      else
        self.xScale = 1
      end
    end
  end

  function tim:zMoveAction(z_vel)
    if self.action ~= "resting" then
      return
    end

    self.move_decay = 0
    self.moving = true

    if z_vel < 0 then
      self.move_direction = "up"
    else
      self.move_direction = "down"
    end

    self.z_vel = math.max(-1 * self.max_z_velocity, math.min(self.max_z_velocity, z_vel))
  end

  function tim:forceMoveAction(x_vel, y_vel)
    -- Set velocity in the direction of the touch
    self.x_vel = math.max(-1 * self.max_x_velocity, math.min(self.max_x_velocity, x_vel))
    self.y_vel = math.max(-1 * self.max_y_velocity, math.min(self.max_y_velocity, y_vel))
    -- to do: only do this on voluntary moves.
    table.insert(self.swipe_history, {x_vel=self.x_vel, y_vel=self.y_vel, time=system.getTimer()})

    if self:checkSpecialAction(x_vel, y_vel) then
      return
    end
    
    -- check if there's substantial upward velocity, and if so, make this a jump
    if self.y_vel < -1 * self.max_y_velocity / 2 then
      -- do this for much stronger jumps
      if self.x_vel < 0 then
        self.x_vel = -1 * self.max_x_velocity
      else
        self.x_vel = self.max_x_velocity
      end
      self:jumpingAction()
    elseif math.abs(self.y_vel) < self.max_y_velocity / 6 then
      self.y_vel = 0
    end
  end

  function tim:adjustVelocity(x_vel_delta, y_vel_delta)
    -- Add velocity to existing velocity
    self.x_vel = math.max(-1 * self.max_x_velocity, math.min(self.max_x_velocity, self.x_vel + x_vel_delta))
    self.y_vel = math.max(-1 * self.max_y_velocity, math.min(self.max_y_velocity, self.y_vel + y_vel_delta))

    -- check if there's substantial upward velocity, and if so, make this a jump
    -- if self.y_vel < -1 * self.max_y_velocity / 2 then
    --   self:jumpingAction()
    -- elseif math.abs(self.y_vel) < self.max_y_velocity / 6 then
    --   self.y_vel = 0
    -- end
  end

  function tim:blockingAction()
    self.move_decay = 0
    self.moving = false
    self.sprite:setFrame(self.blocking_frames[1])
    self.after_image.isVisible = false
    self.animationTimer._delay = self.resting_rate
    self.rotation = 0
    self.action = "blocking"
  end

  function tim:damageAction(type, damage_value, knockback, y_vel, rotation)
    self.move_decay = 0
    self.moving = false
    self.after_image.isVisible = false
    self.health = self.health - damage_value
    self:adjustVelocity(knockback * -1 * self.xScale, y_vel)
    self.rotation = rotation * self.xScale
    self.animationTimer._delay = self.resting_rate
    
    if type == "damaged" then
      self.sprite:setFrame(self.damaged_frames[1])
      self.damage_timer = 4
      previous_action = self.action
      self.action = "damaged"
      if self.damage_in_a_row >= self.whooping_threshold or self.health <= 0 or previous_action == "jumping" or previous_action == "jump_kicking" then
        self:koAction()
      end
    elseif type == "knockback" then
      self.sprite:setFrame(self.blocking_frames[1])
      self.action = "knockback"
    end
  end

  function tim:koAction()
    self.move_decay = 0
    self.moving = false
    self.action = "ko"
    self.damage_timer = self.ko_time
    self.damage_in_a_row = 0
    self.y_vel = -20
    self.x_vel = -25 * self.xScale
  end

  function tim:blinkingAction()
    self.move_decay = 0
    self.moving = false
    self.action = "blinking"
    self.blinking_start_time = system.getTimer()
  end

  function tim:dizzyAction()
    self.move_decay = 0
    self.moving = false
    if self.action == "ko" then
      self.y = self.y - 60
    end
    self.action = "dizzy"
    self.animations["dizzy"](self)
    self.damage_timer = 45
    self.damage_in_a_row = 0
    for i = 1, 3, 1 do
      self.effects:addDizzyTwit(self, self, 0, -110 + math.random(1,20) + self.z, 40 + math.random(1,20), 2250)
    end
  end

  function tim:celebratingAction()
    self.move_decay = 0
    self.moving = false
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
      if self.damage_timer <= 0 then
        if self.health > 0 then
          -- if self.action == "ko" then
          --   self:dizzyAction()
          -- else
          --   self:restingAction()
          -- end
          if self.action == "ko" then
            self.y = self.y - 60
          end
          self:restingAction()
        elseif self.health <= 0 and self.can_blink then
          self:blinkingAction()
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

  tim.animations["blocking"] = function(self)
    self.sprite:setFrame(self.blocking_frames[1])
    self.frame = self.frame + 1
    if self.frame > self.blocking_max_frames then
      self:restingAction()
    end
  end

  tim.animations["knockback"] = function(self)
    self.sprite:setFrame(self.blocking_frames[1])
  end

  tim.animations["blinking"] = function(self)
    if self.blinking_start_time == nil then
      return
    end
    blinking_time = system.getTimer() - self.blinking_start_time
    if math.floor(blinking_time / 150) % 2 == 0 then
      self.sprite.isVisible = false
    else
      self.sprite.isVisible = true
    end
  end

  function tim:physicsLoop()
    if #self.swipe_history > 0 
      and system.getTimer() - self.swipe_history[#self.swipe_history].time > self.action_window then
      self.swipe_history = {}
    end

    if (self.x + self.x_vel > self.min_x or self.x_vel > 0) and (self.x + self.x_vel < self.max_x or self.x_vel < 0) then
      -- print("Moving from " .. self.x .. " to " .. (self.x + self.x_vel) .. " .. at speed " .. self.x_vel)
      self.x = self.x + self.x_vel
    end
    if self.action ~= "pre_jumping" then
      self.y = self.y + self.y_vel
    end
    if (self.z + self.z_vel > self.min_z or self.z_vel > 0) and (self.z + self.z_vel < self.max_z or self.z_vel < 0) then
      self:setZ(self.z + self.z_vel)
    end

    if (math.abs(self.x_vel) > 0 or math.abs(self.z_vel) > 0) and self.moving == true and self.animate_move == true then
      self.move_decay = self.move_decay + 1
      if self.move_decay > #self.moving_frames then
        self.x_vel = 0
        self.z_vel = 0
        self.move_decay = 0
        self.moving = false
        self:restingAction()
      else
        self.sprite:setFrame(self.moving_frames[self.move_decay])
      end
    end

    if math.abs(self.y_vel) < self.max_y_velocity / 4 and self.action ~= "ultra_punching" then
      self.x_vel = self.x_vel * 0.8
    else
      self.x_vel = self.x_vel * 0.9
    end
    self.z_vel = self.z_vel * 0.8

    if (self.action == "jumping" or self.action == "jump_kicking") and math.abs(self.rotation_vel) > 0 then
      self.rotation = self.rotation + self.rotation_vel
    end

    local current_ground_target = self.ground_target
    if self.action == "ko" then
      current_ground_target = current_ground_target + 60
    end

    if self.action == "knockback" and math.abs(self.x_vel) < self.max_x_velocity / 10 then
      self:restingAction()
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

    local acquire_target_threshold = 256
    local switch_target_threshold = 100
    local close_enough_to_target = false

    for i = 1, #self.fighters do
      fighter = self.fighters[i]
      if fighter.enabled == true and fighter.action ~= "ko" and fighter.action ~= "blinking" and fighter ~= self and self.side ~= fighter.side then
        if self.target == nil then
          if distance(self.x, self.y, fighter.x, fighter.y) < acquire_target_threshold then
            self.target = fighter
            close_enough_to_target = true
          end
        else
          if distance(self.x, self.y, fighter.x, fighter.y) < acquire_target_threshold then
            close_enough_to_target = true
          end
          if distance(self.x, self.y, fighter.x, fighter.y) < distance(self.x, self.y, self.target.x, self.target.y) - switch_target_threshold then
            self.target = fighter
          end
        end
      end
    end
    if close_enough_to_target == false and self.flexible_target == true then
      self.target = nil
    end

    -- -- Don't try to 
    -- if self.x == nil or (self.target ~= nil and self.target.x == nil) then
    --   return
    -- end

    -- face the current target, if there is one
    if self.target ~= nil and self.target.x ~= nil and self.target.action ~= "ko" and self.target.action ~= "blinking" and self.x ~= nil then
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
    -- Each sprite frame has a covering of circles marked "attack", "vulnerability", or "defense".
    -- A collision happens when Alice's circles touch Bob's circles.
    -- But it's necessary to resolve all the different touch points at once, symmetrically.
    -- That is, Alice is doing several things to Bob and Bob is doing several things to Alice,
    -- and these must all be boiled down to a result for Alice and a result for Bob.

    -- The priority list of results is as follows.
    -- Highest: recieve full damage and full knockback, action set to "damaged"
    -- recieve partial damage and partial knockback, action set to "knockback"
    -- recieve full knockback, action set to "knockback"
    -- recieve partial knockback, action unchanged (eg "block")
    -- Lowest: slow approach velocity, action unchanged
    -- priority = {
    --   5="full_damage",
    --   4="partial_damage",
    --   3="full_knockback",
    --   2="partial_knockback",
    --   1="slowdown",
    -- }

    -- For each other fighter, all collisions are examined. Each collision generates a result for Alice and a result for Bob.
    -- For instance, if Alice's attack touches Bob's vulnerability, the result is that Bob recieves full damage and full knockback,
    -- and his action is set to "damaged".
    -- Or, if Alice's attack touches Bob's attack, the result is both Alice and Bob recieve partial damage and partial knockback.

    -- The highest priority effect is chosen for each fighter independent of the other.

    -- To prevent a single attack landing multiple times, if any attack surface is touching, the fighter's attack is *deactivated*.
    -- If the fighter's attack is deactivated, attack circles are ignored. It will take a new attack to reactivate and deal damage again.

    -- Note that since there are potentially more than two fighters, a player can potentially collide multiple times.

    -- first, get the list of fighters, using {self.target} if necessary, and return if it's empty. 
    hit_list = self.fighters
    if hit_list == nil then
      hit_list = {self.target}
    end
    if hit_list == nil then
      return
    end

    -- then, get the hit detection circles for the fighter's current frame
    frame = self.sprite.frame
    hitIndex = self.hitIndex[frame]
    if hitIndex == nil then
      return
    end

    -- determines how much the circles have to touch before it counts as a collision. higher value prevents over-sensitive collisions.
    local insensitivity = 6

    -- Loop through fighters (skipping self)
    for i = 1, #hit_list do
      opponent = hit_list[i]

      fighter_result = -1
      opponent_result = -1

      local z_diff = math.abs(opponent.z - self.z)

      if opponent ~= self 
        and z_diff < z_threshold 
        and self.side ~= opponent.side 
        and (self.ally == nil or self.ally ~= opponent) 
        and (opponent.ally == nil or opponent.ally ~= self)
        and self.action ~= "ko" and opponent.action ~= "ko" 
        and self.action ~= "blinking" and opponent.action ~= "blinking" then
        -- Get the opponent's hit detection circles
        opponent_frame = opponent.sprite.frame
        opponent_hitIndex = opponent.hitIndex[opponent_frame]

        for j = 1, #hitIndex do
          for k = 1, #opponent_hitIndex do
            x1, y1 = self:localToContent(hitIndex[j].x, hitIndex[j].y + self.z)
            x2, y2 = opponent:localToContent(opponent_hitIndex[k].x, opponent_hitIndex[k].y + opponent.z)
            if distance(x1, y1, x2, y2) < hitIndex[j].radius + opponent_hitIndex[k].radius - insensitivity then
              -- a collision has occured. Determine the consequence based on the type.
              if self.attack ~= nil and hitIndex[j].purpose == "attack" and opponent_hitIndex[k].purpose == "vulnerability" then
                -- Alice hits Bob in his vulnerability. Full damage to Bob and nothing to Alice.
                opponent_result = math.max(opponent_result, 5)
              elseif self.attack ~= nil and hitIndex[j].purpose == "attack" and opponent.attack ~= nil and opponent_hitIndex[k].purpose == "attack" then
                -- Alice and Bob punch each other in the fists. Partial damage each.
                fighter_result = math.max(fighter_result, 4)
                opponent_result = math.max(opponent_result, 4)
              elseif self.attack ~= nil and hitIndex[j].purpose == "attack" and opponent_hitIndex[k].purpose == "defense" then
                -- Alice punches Bob in his defense surface. Full knockback for Alice, partial knockback for Bob.
                fighter_result = math.max(fighter_result, 3)
                opponent_result = math.max(opponent_result, 2)
              elseif hitIndex[j].purpose == "defense" and opponent.attack ~= nil and opponent_hitIndex[k].purpose == "attack" then
                -- Bob punches Alice in her defense surface. Full knockback for Bob, partial knockback for Alice.
                fighter_result = math.max(fighter_result, 2)
                opponent_result = math.max(opponent_result, 3)
              elseif hitIndex[j].purpose == "defense" and opponent_hitIndex[k].purpose == "defense" then
                -- defense on defense contact is made. Slow approach velocities for both.
                fighter_result = math.max(fighter_result, 1)
                opponent_result = math.max(opponent_result, 1)
              elseif hitIndex[j].purpose == "defense" and opponent_hitIndex[k].purpose == "vulnerability" then
                -- defense on vulnerability contact is made. Slow approach velocities for both.
                fighter_result = math.max(fighter_result, 1)
                opponent_result = math.max(opponent_result, 1)
              elseif hitIndex[j].purpose == "vulnerability" and opponent.attack ~= nil and opponent_hitIndex[k].purpose == "attack" then
                -- Bob hits alice in her vulnerability. Full damage to Alice and nothing to Bob.
                fighter_result = math.max(fighter_result, 5)
              elseif hitIndex[j].purpose == "vulnerability" and opponent_hitIndex[k].purpose == "defense" then
                -- defense on vulnerability contact is made. Slow approach velocities for both.
                fighter_result = math.max(fighter_result, 1)
                opponent_result = math.max(opponent_result, 1)
              elseif hitIndex[j].purpose == "vulnerability" and opponent_hitIndex[k].purpose == "vulnerability" then
                -- Vulnerability on vulnerability contact is made. Slow approach velocities for both.
                fighter_result = math.max(fighter_result, 1)
                opponent_result = math.max(opponent_result, 1)
              end
            end
          end
        end

        -- Now we have planned results for both the fighter and the opponent. Time to resolve the results.
        symmetric_pair = {
          {fighter_result, self, opponent},
          {opponent_result, opponent, self},
        }

        for p = 1, #symmetric_pair do
          local result = symmetric_pair[p][1]
          local A = symmetric_pair[p][2]
          local B = symmetric_pair[p][3]
        
          if result == 5 then
            -- full damage and full knockback for the fighter
            A.effects:randomDamageSound()
            B.damage_in_a_row = 0
            A.damage_in_a_row = A.damage_in_a_row + 1
            A:damageAction("damaged", B.attack.power, B.attack.knockback, -5, 15)
            if B.shake_screen_on_contact then
              effects:shakeScreen(1, 200)
              effects:shakeScreen(10, 100)
            end
          elseif result == 4 then
            -- partial damage and partial knockback for the fighter
            -- (note this is one sided, because what happens to the other fighter is independent)
            A.effects:randomDamageSound()
            B.damage_in_a_row = 0
            A:damageAction("knockback", B.attack.power / 2, A.attack.knockback / 2, 0, 0)
          elseif result == 3 then
            -- full knockback for the fighter
            A.effects:randomDamageSound()
            -- A:damageAction("knockback", 0, A.attack.knockback, 0, 0)
            A:adjustVelocity(A.attack.knockback * -2 * A.xScale, 0)
          elseif result == 2 then
            -- partial knockback for the fighter
            A.effects:randomDamageSound()
            -- A:damageAction("knockback", 0, B.attack.knockback / 2, 0, 0)
            -- A:adjustVelocity(B.attack.knockback * -0.5 * A.xScale, 0)
            A:damageAction("knockback", B.attack.power / 8, B.attack.knockback * 0.5, 0, 0)
          elseif result == 1 then
            -- if the fighter's x velocity is approaching the opponent, curtail it.
            -- BUT WHAT ABOUT ULTRA PUNCHING?
            if A.x < B.x and A.x_vel > 0 then
              A.x_vel = A.x_vel * 0.6
            elseif A.x > B.x and A.x_vel < 0 then
              A.x_vel = A.x_vel * 0.6
            end
          end
        end

        if opponent_result >= 4 or opponent_result == 2  or fighter_result == 3 then
          self.attack = nil
        end
        if fighter_result >= 4 or fighter_result == 2  or opponent_result == 3 then
          opponent.attack = nil
        end
      end
    end

  end

  return tim
end

return candidate