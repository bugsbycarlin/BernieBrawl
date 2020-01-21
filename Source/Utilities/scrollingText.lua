

ScrollingText = {}
ScrollingText.__index = ScrollingText

function ScrollingText:create(
  x,
  y,
  anchorX,
  group,
  font_name,
  font_size,
  text_strings,
  margin_y,
  delay_time,
  fade_in_time,
  display_time,
  fade_out_time,
  color)

  local scrolling_text = {}
  setmetatable(scrolling_text, ScrollingText)

  scrolling_text.text_strings = text_strings

  scrolling_text.delay_time = delay_time
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
    textbox.anchorX = anchorX
    textbox.alpha = 0.0
    table.insert(scrolling_text.texts, textbox)
  end

  return scrolling_text
end

function ScrollingText:animation()

  if self.start_time == nil then
    return
  end
  local elapsed = system.getTimer() - self.start_time
  
  for i = 1, #self.texts do
    local fade_in_start = (i - 1) * self.delay_time
    local fade_in_end = (i - 1) * self.delay_time + self.fade_in_time
    local fade_out_start = (i - 1) * self.delay_time + self.fade_in_time + self.display_time
    local fade_out_end = (i - 1) * self.delay_time + self.fade_in_time + self.display_time + self.fade_out_time
    
    if elapsed > fade_in_start and elapsed < fade_in_end then
      local fade_in_portion = (elapsed - fade_in_start) / self.fade_in_time
      self.texts[i].alpha = fade_in_portion
    elseif elapsed > fade_out_start and elapsed < fade_out_end then
      fade_out_portion = (elapsed - fade_out_start) / self.fade_out_time
      self.texts[i].alpha = 1.0 - fade_out_portion
    elseif elapsed < fade_in_start or elapsed > fade_out_end then
      self.texts[i].alpha = 0
    elseif elapsed > fade_in_end and elapsed < fade_out_start then
      self.texts[i].alpha = 1
    end
  end
end

function ScrollingText:start()
  self.time_elapsed = 0
  self.start_time = system.getTimer()
  self.animationTimer = timer.performWithDelay(30, function() self:animation() end, 0)
  -- self.animationTimer = timer.performWithDelay(30, self.animation(), 0)
end

function ScrollingText:dispose()
  timer.cancel(self.animationTimer)
end

return ScrollingText