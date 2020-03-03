
local candidate_template = require("Source.Candidates.candidate")

local suitSpriteInfo = require("Source.Sprites.suitSprite")
local suitSprite_1 = graphics.newImageSheet("Art/suit_sprite_1.png", suitSpriteInfo:getSheet())
local suitSprite_2 = graphics.newImageSheet("Art/suit_sprite_2.png", suitSpriteInfo:getSheet())

local textBubble = require("Source.Utilities.textBubble")

suit = {}
suit.__index = suit

death_phrases = {
  "I endorse you, Bernie!",
  "I endorse you, Bernie!",
  "I endorse you, Bernie!",
  "But I spent a billion dollars",
  "I'm too rich to lose!",
  "But I polled so well last year",
  "You're unelectable!",
  "I'm secretly socialist",
  "I'm gonna vote for Trump",
  "Avenge me, Uncle Joe!",
  "I'm suspending my campaign",
  "I'm suspending my campaign",
  "I'm suspending my campaign",
}

function suit:create(x, y, group, min_x, max_x, min_z, max_z, effects_thingy)
  local candidate = candidate_template:create(x, y, group, min_x, max_x, min_z, max_z, effects_thingy, 50)

  candidate.resting_rate = 45
  candidate.action_rate = 35
  candidate.moving_rate = 18
  candidate.punching_power = 9
  candidate.kicking_power = 12
  candidate.knockback = 12
  candidate.automatic_rate = 300
  candidate.blocking_max_frames = 10
  candidate:setMaxHealth(36)

  candidate.frames = {}
  for i = 1, #suitSpriteInfo.sheet.frames do
    table.insert(candidate.frames, i)
  end

  candidate.name = "Suit"
  candidate.short_name = "suit"

  sprite_choice = math.random(1,100)
  if sprite_choice > 50 then
    candidate.sprite = display.newSprite(candidate, suitSprite_1, {frames=candidate.frames})
    candidate.after_image = display.newSprite(candidate, suitSprite_1, {frames=candidate.frames})
  else
    candidate.sprite = display.newSprite(candidate, suitSprite_2, {frames=candidate.frames})
    candidate.after_image = display.newSprite(candidate, suitSprite_2, {frames=candidate.frames})
  end

  candidate.hitIndex = suitSpriteInfo.hitIndex

  candidate.after_image.alpha = 0.5
  candidate.after_image.isVisible = false

  candidate.ko_frame = 33

  function candidate:automaticAction()

    if self.health <= 0 or self.action ~= "resting" then
      return
    end
    
    if self.z > max_z then
      self:zMoveAction(-1 * self.max_z_velocity)
      return
    end

    if self.target == nil then
      return
    end

    if self.target.x - self.x > 700 then
      self:forceMoveAction(15, 0)
    elseif self.x - self.target.x > 700 then
      self:forceMoveAction(-15, 0)
    elseif math.abs(self.target.x - self.x) > 250 then
      self:basicAutomaticMove()
    elseif self.target.action ~= "dizzy" and self.target.action ~= "ko" then
      dice = math.random(1, 100)
      if dice > 80 then
        moved = self:basicAutomaticMove()
      elseif dice > 40 then
        self:punchingAction()
      else
        self:kickingAction()
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

  -- function candidate:automaticAction()
  --   -- do return end

  --   if self.health <= 0 or self.action ~= "resting" then
  --     return
  --   end
    
  --   if self.z > max_z then
  --     -- self.automaticActionTimer._delay = self.automatic_rate / 2
  --     self:zMoveAction(-1 * self.max_z_velocity)
  --     return
  --   else
  --     -- self.automaticActionTimer._delay = self.automatic_rate
  --   end

  --   if self.target == nil then
  --     return
  --   end

  --   -- print("Joe suit HP is " .. self.health)
  --   if self.target.x - self.x > 700 then
  --     self:forceMoveAction(10, 0)
  --   elseif self.x - self.target.x > 700 then
  --     self:forceMoveAction(-10, 0)
  --   elseif math.abs(self.target.x - self.x) > 250 then
  --     self.automaticActionTimer._delay = self.automatic_rate / 2
  --     dice = math.random(1, 100)
  --     if dice > 90 then
  --       self:basicAutomaticMove()
  --     else
  --       --self:restingAction()
  --     end
  --   elseif self.target.action ~= "dizzy" and self.target.action ~= "ko" then
  --     dice = math.random(1, 100)
  --     moved = false
  --     if dice > 70 then
  --       moved = self:basicAutomaticMove()
  --     elseif dice > 50 then
  --       --self:restingAction()
  --     end
  --     if moved == false then
  --       if dice > 80 then
  --         self:punchingAction()
  --       elseif dice > 40 then
  --         self:kickingAction()
  --       else
  --         self:blockingAction()
  --       end
  --     end
  --   else
  --     local dice = math.random(1, 100)
  --     if dice > 90 then
  --       self:moveAction(10 * self.xScale, 0)
  --     elseif dice > 60 then
  --       self:moveAction(-10 * self.xScale, 0)
  --     elseif dice > 55 then
  --       self:punchingAction()
  --     end
  --   end
  -- end

  -- big override. use animation for moves.
  function candidate:moveAction(x_vel, y_vel)
    -- if self.action ~= "resting" then
    --   return
    -- end

    if self.target == nil then
      if self.x_vel < 0 then
        self.xScale = -1
      else
        self.xScale = 1
      end
    end

    self.frame = 1
    self.after_image.isVisible = false
    self.animationTimer._delay = self.moving_rate
    self.rotation = 0
    self.action = "moving"
    
  end

  function candidate:dizzyAction()
    -- if self.action == "ko" then
    --   self.y = self.y - 60
    -- end
    -- self.action = "dizzy"
    -- self.animations["dizzy"](self)
    -- self.damage_timer = 25
    -- self.damage_in_a_row = 0
    -- for i = 1, 3, 1 do
    --   self.effects_thingy:addDizzyTwit(self, self, 0, -110 + math.random(1,20) + self.z, 40 + math.random(1,20), 2250)
    -- end
  end

  candidate.parentKoAction = candidate.koAction
  function candidate:koAction()
    candidate:parentKoAction()

    dice = math.random(1, 100)
    if self.target ~= nil and dice > 70 then
      if self.target.x < self.x then
        death_bubble = textBubble:create(candidate, effects_thingy.foreground_group, death_phrases[math.random(1, #death_phrases)], "left", -64, -64, 2000)
        candidate.effects_thingy:add(death_bubble)
      else
        death_bubble = textBubble:create(candidate, effects_thingy.foreground_group, death_phrases[math.random(1, #death_phrases)], "right", 64, -64, 2000)
        candidate.effects_thingy:add(death_bubble)
      end
    end
  end

  function candidate:checkSpecialAction(x_vel, y_vel)
    return false
  end

  candidate.damaged_frames = {
    32
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
    23, 23,
    24, 24,
    25,
    26, 26, 26,
    27, 27,
    28, 28,
    29, 29,
    30, 30,
    1, 1,
  }
  candidate.animations["kicking"] = function(self)
    self.sprite:setFrame(kicking_frames[self.frame])
    if self.frame == 19 then
      -- move because the sprite doesn't finish in the same location
      self.x = self.x + 47 * self.xScale
    end
    -- if self.frame == 5 then
    --   self:forceMoveAction(15*self.xScale, 0)
    --   self.effects_thingy:playSound("swing_1")
    -- end
    self.frame = self.frame + 1
    if (self.frame > #kicking_frames) then
      self:restingAction()
    end
  end

  local moving_frames = {
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
    20, 20,
    21, 21,
    22, 22,
    1, 1,
  }
  candidate.animations["moving"] = function(self)
    self.sprite:setFrame(moving_frames[self.frame])
    if self.frame == 27 then
      -- move because the sprite doesn't finish in the same location
      self.x = self.x + 58 * self.xScale
    end
    self.frame = self.frame + 1
    if (self.frame > #moving_frames) then
      self:restingAction()
    end
  end

  local punching_frames = {
    1, 1,
    34, 34,
    35, 36,
    37, 37,
    38, 38,
    39, 39, 39, 39,
    40, 40,
    38, 38,
    37, 37,
    1, 1,
  }
  candidate.animations["punching"] = function(self)
    self.sprite:setFrame(punching_frames[self.frame])
    if self.frame == 5 or self.frame == 11 then
      self:forceMoveAction(5*self.xScale, 0)
      self.effects_thingy:playSound("swing_1")
    end
    -- second attack
    self.frame = self.frame + 1
    if self.frame == 11 and self.attack == nil then
      self.attack = {power=self.punching_power, knockback=self.knockback}
    end
    if (self.frame > #punching_frames) then
      self:restingAction()
    end
  end

  -- candidate.animations["jumping"] = function(self)
  --   -- if self.y_vel < 0 then
  --   --   self.sprite:setFrame(31) -- go up
  --   -- elseif self.y_vel > 0 then
  --   --   self.sprite:setFrame(32) -- go down
  --   -- end
  --   self.sprite:setFrame(1)
  -- end

  -- candidate.animations["jump_kicking"] = function(self)
  --   self.sprite:setFrame(33)
  -- end

  candidate.blocking_frames = {31}

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
    1
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

return suit