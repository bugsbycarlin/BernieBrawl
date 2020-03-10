
door = {}
door.__index = door

local function distance(x1, y1, x2, y2)
  return math.sqrt((x1-x2)^2 + (y1 - y2)^2)
end

function door:create(group, effects, player, x, y, width, height, duration, alt_image)

  local object = {}
  setmetatable(object, door)

  object.type = "door"

  if alt_image == nil then
    print("Here is the sprite")
    object.sprite = display.newImageRect(group, "Art/door.png", width, height)
  else
    object.sprite = display.newImageRect(group, "Art/" + alt_image + ".png", width, height)
  end

  object.sprite.x = x + width
  print(object.sprite.x)
  object.sprite.y = y
  print(object.sprite.y)
  object.sprite.anchorX = 1
  object.sprite.anchorY = 0
  object.sprite.xScale = 0.001
  object.sprite.isVisible = true
  
  object.player = player
  object.width = width
  object.height = height
  object.duration = duration
  object.trigger = trigger

  object.state = "closed"
  object.animating = false
  object.animation_start_time = 0

  object.effects = effects

  function object:trigger()
    return math.abs(self.player.x - (x + width / 2)) < 100 
  end

  function object:update()
    if self.state == "closed" then
      result = self:trigger()

      if result == true then
        -- open it
        if self.duration > 0 then
          self.state = "opening"
          self.sprite.isVisible = true

          self.animation_start_time = system.getTimer()
          self.effects:playSound("door_open")
        else
          self.state = "open"
          self.sprite.xScale = 1
          self.sprite.isVisible = 1
        end
      end
    elseif self.state == "opening" and self.duration > 0 then
      self.sprite.xScale = math.min(1, (system.getTimer() - self.animation_start_time) / self.duration)
      print(self.sprite.xScale)
      if system.getTimer() - self.animation_start_time >= self.duration then
        -- open
        self.state = "open"
        print("I am now open")
        print(self.sprite.xScale)
        print(self.sprite.isVisible)
      end
    end

  end

  function object:finished()
    return false
  end

  return object
end



return door