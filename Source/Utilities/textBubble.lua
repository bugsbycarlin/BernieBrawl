
textBubble = {}
textBubble.__index = textBubble

-- local font_size = 14
-- local bubble_radius = 10
local outline_margin = 2

function textBubble:create(parent, group, font_size, text_string, direction, x, y, duration)

  local bubble = {}
  display_group = group

  bubble.sprite = display.newGroup()
  bubble.sprite.x = parent.x
  bubble.sprite.y = parent.y + parent.z
  display_group:insert(bubble.sprite)

  bubble.type = "textBubble"

  bubble.parent = parent

  bubble_radius = font_size / 2 + 3

  bubble.text = display.newText({
    parent=bubble.sprite,
    text=string.upper(text_string),
    x=x, y=y,
    font="Georgia-Bold", fontSize=font_size})
  if direction == "right" then
    bubble.text.anchorX = 0
  else
    bubble.text.anchorX = 1
  end
  bubble.text.anchorY = 0.5
  bubble.text:setTextColor(0, 0, 0)

  bubble.duration = duration
  bubble.start_time = system.getTimer()

  if direction == "right" then
    outline_circle = display.newCircle(bubble.sprite, x, y, bubble_radius + outline_margin)      
    outline_circle:setFillColor(0, 0, 0)

    outline_square = display.newRect(bubble.sprite, x, y, bubble.text.contentWidth / 0.75, 2 * (bubble_radius + outline_margin))
    outline_square.anchorX = 0
    outline_square:setFillColor(0, 0, 0)

    outline_circle = display.newCircle(bubble.sprite, x + bubble.text.contentWidth / 0.75, y, bubble_radius + outline_margin)      
    outline_circle:setFillColor(0, 0, 0)

    rad = bubble_radius + outline_margin
    outline_triangle = display.newPolygon(bubble.sprite, x, y + 1.5 * rad, {0, 0, -2.5 * rad, 2.5 *rad, -1.5 * rad, 0})
    outline_triangle:setFillColor(0, 0, 0)

    circle = display.newCircle(bubble.sprite, x, y, bubble_radius)      
    circle:setFillColor(1, 1, 1)

    square = display.newRect(bubble.sprite, x, y, bubble.text.contentWidth / 0.75, 2 * bubble_radius)
    square.anchorX = 0
    square:setFillColor(1, 1, 1)

    circle = display.newCircle(bubble.sprite, x + bubble.text.contentWidth / 0.75, y, bubble_radius)      
    circle:setFillColor(1, 1, 1)

    triangle = display.newPolygon(bubble.sprite, x, y + 1.5 * bubble_radius, {0, 0, -2.5 * bubble_radius, 2.5 *bubble_radius, -1.5 * bubble_radius, 0})
    triangle:setFillColor(1, 1, 1)
  else
    outline_circle = display.newCircle(bubble.sprite, x, y, bubble_radius + outline_margin)      
    outline_circle:setFillColor(0, 0, 0)

    outline_square = display.newRect(bubble.sprite, x - bubble.text.contentWidth / 0.75, y, bubble.text.contentWidth / 0.75, 2 * (bubble_radius + outline_margin))
    outline_square.anchorX = 0
    outline_square:setFillColor(0, 0, 0)

    outline_circle = display.newCircle(bubble.sprite, x - bubble.text.contentWidth / 0.75, y, bubble_radius + outline_margin)      
    outline_circle:setFillColor(0, 0, 0)

    rad = bubble_radius + outline_margin
    outline_triangle = display.newPolygon(bubble.sprite, x, y + 1.5 * rad, {0, 0, 2.5 * rad, 2.5 *rad, 1.5 * rad, 0})
    outline_triangle:setFillColor(0, 0, 0)

    circle = display.newCircle(bubble.sprite, x, y, bubble_radius)      
    circle:setFillColor(1, 1, 1)

    square = display.newRect(bubble.sprite, x - bubble.text.contentWidth / 0.75, y, bubble.text.contentWidth / 0.75, 2 * bubble_radius)
    square.anchorX = 0
    square:setFillColor(1, 1, 1)

    circle = display.newCircle(bubble.sprite, x - bubble.text.contentWidth / 0.75, y, bubble_radius)      
    circle:setFillColor(1, 1, 1)

    triangle = display.newPolygon(bubble.sprite, x, y + 1.5 * bubble_radius, {0, 0, 2.5 * bubble_radius, 2.5 *bubble_radius, 1.5 * bubble_radius, 0})
    triangle:setFillColor(1, 1, 1)
  end

  bubble.sprite:insert(bubble.text)

  function bubble:update()
    self.sprite.x = self.parent.x
    self.sprite.y = self.parent.y + self.parent.z
  end

  function bubble:finished()
    if self.duration > 0 and system.getTimer() - self.start_time > self.duration then
      print("I'm a done bubble")
      return true
    else
      return false
    end
  end

  return bubble
end

return textBubble