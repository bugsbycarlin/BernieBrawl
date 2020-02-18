
local candidate_template = require("Source.Candidates.candidate")

local broSpriteInfo = require("Source.Sprites.broSprite")
local broSprite = graphics.newImageSheet("Art/bro_sprite.png", broSpriteInfo:getSheet())

bro = {}
bro.__index = bro

function bro:create(x, y, group, min_x, max_x, effects)
  local candidate = candidate_template:create(x, y, group, min_x, max_x, effects, 50)

  candidate.power = 10
  candidate.automatic_rate = 500
  candidate.action_rate = 40
  candidate:setMaxHealth(30)

  candidate.frames = {}
  for i = 1, #broSpriteInfo.sheet.frames do
    table.insert(candidate.frames, i)
  end

  candidate.name = "bro"
  candidate.short_name = "bro"

  candidate.sprite = display.newSprite(candidate, broSprite, {frames=candidate.frames})
  candidate.hitIndex = broSpriteInfo.hitIndex

  candidate.after_image = display.newSprite(candidate, broSprite, {frames=candidate.frames})
  candidate.after_image.isVisible = false

  function candidate:automaticAction()
    dice = math.random(1, 100)
    if dice > 90 then
      self:moveAction(10 * self.xScale, 0)
    else 
      self:punchingAction()
    end
  end

  function candidate:damageAction(actor, extra_vel)
    self.sprite:setFrame(3)
    self.after_image.isVisible = false
    self.x_vel = -15 * self.xScale
    if extra_vel ~= nil then
      self.x_vel = self.x_vel - extra_vel * self.xScale
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

  local resting_frames = {
    4
  }
  candidate.animations["resting"] = function(self)
    self.sprite:setFrame(resting_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #resting_frames) then
      self.frame = 1
    end
  end

  local punching_frames = {
    1, 1, 1, 1,
  }
  candidate.animations["punching"] = function(self)
    self.sprite:setFrame(punching_frames[self.frame])
    self.frame = self.frame + 1
    if (self.frame > #punching_frames) then
      self:restingAction()
    end
  end

  candidate.animations["jumping"] = function(self)
    self.sprite:setFrame(2)
  end

  candidate.animations["dizzy"] = function(self)
    self.sprite:setFrame(3)
    if self.damage_timer % 9 == 0 then
      self.xScale = self.xScale * -1
    end
  end

  candidate.animations["ko"] = function(self)
    if self.xScale == 1 and self.rotation > -90 and self.y_vel ~= 0 then
      self.rotation = self.rotation - 7
    elseif self.xScale == -1 and self.rotation < 90 and self.y_vel ~= 0 then
      self.rotation = self.rotation + 7
    end
  end

  candidate.parentPhysicsLoop = candidate.physicsLoop
  function candidate:physicsLoop()
    if self.health <= 0 then
      self.ground_target = 500
    end

    candidate:parentPhysicsLoop()
  end

  return candidate
end

return bro