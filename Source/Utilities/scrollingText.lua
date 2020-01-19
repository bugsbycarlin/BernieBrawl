

ScrollingText = {}
ScrollingText.__index = ScrollingText

function ScrollingText:create(
  x,
  y,
  group,
  font_name,
  font_size,
  text_strings,
  margin_y,
  fade_in_time,
  display_time,
  fade_out_time,
  color)

  local scrolling_text = {}
  setmetatable(scrolling_text, ScrollingText)

  scrolling_text.text_strings = text_strings
  scrolling_text.fade_in_time = fade_in_time
  scrolling_text.display_time = display_time
  scrolling_text.fade_out_time = fade_out_time

  scrolling_text.time_elapsed = 0
  scrolling_text.start_time = 76

  scrolling_text.texts = {}
  for i = 1, #text_strings do
    print(text_strings[i])
    textbox = display.newText(group, text_strings[i], x, y + (i - 1) * margin_y, font_name, font_size)
    textbox:setTextColor(color.r, color.g, color.b)
    textbox.alpha = 0.0
    table.insert(scrolling_text.texts, textbox)
  end

  return scrolling_text
end

function ScrollingText:animation()
  print("dang")
  if self.start_time == nil then
    return
  end
  local elapsed = system.getTimer() - self.start_time
  print(elapsed)
end

function ScrollingText:start()
  self.time_elapsed = 0
  self.start_time = system.getTimer()
  print("in here")
  -- self.animationTimer = timer.performWithDelay(30, self.animation(), 0)
end

function ScrollingText:dispose()
  timer.cancel(self.animationTimer)
end

return ScrollingText