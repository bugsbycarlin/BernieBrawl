
scriptMaker = {}
scriptMaker.__index = scriptMaker

function scriptMaker:makeScript(effects, group, default_length, default_padding, default_font_size, script)
  local script_end_time = 0
  print(default_length)
  for i = 1, #script do
    local line = script[i]
    local player = line.name
    local text = line.text
    local length = default_length
    if line.length ~= nil then
      length = line.length
    end
    local padding = default_padding
    if line.padding ~= nil then
      padding = line.padding
    end
    local font_size = default_font_size
    if line.font_size ~= nil then
      font_size = line.font_size
    end
    local offset_x = player.script_offset_x
    if player.script_side == "right" then
      offset_x = -1 * player.script_offset_x
    end
    local offset_y = player.script_offset_y
    timer.performWithDelay(script_end_time, function()
      bubble = textBubble:create(player, group, font_size, text, player.script_side, offset_x, offset_y, length)
      effects:add(bubble)
      if line.action ~= nil then
        line.action()
      end
    end)
    script_end_time = script_end_time + length + padding
  end
  return script_end_time
end

return scriptMaker