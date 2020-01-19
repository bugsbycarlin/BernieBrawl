local frayingSpriteInfo =
{
    frames = {
        {
            -- frame_1
            x=0,
            y=0,
            width=240,
            height=20,

        },
        {
            -- frame_2
            x=0,
            y=20,
            width=240,
            height=20,

        },
        {
            -- frame_3
            x=0,
            y=40,
            width=240,
            height=20,
        },
    },

    sheetContentWidth = 240,
    sheetContentHeight = 60
}

HealthBar = {}
HealthBar.__index = HealthBar

function HealthBar:create(x, y, group)
  local healthbar = {}
  setmetatable(healthbar, HealthBar)
  healthbar.background_bar = display.newImageRect(group, "Art/black_background_bar.png", 244, 24)
  healthbar.background_bar.x = x - 2
  healthbar.background_bar.y = y - 2
  healthbar.background_bar.anchorX = 0
  healthbar.background_bar.anchorY = 0
  healthbar.foreground_bar = display.newImageRect(group, "Art/flag_health_bar.png", 240, 20)
  healthbar.foreground_bar.x = x
  healthbar.foreground_bar.y = y
  healthbar.foreground_bar.anchorX = 0
  healthbar.foreground_bar.anchorY = 0
  local sheet = graphics.newImageSheet("Art/fray.png", frayingSpriteInfo)
  healthbar.overlay_bar = display.newSprite(group, sheet, {frames={1,2,3}})
  -- healthbar.overlay_bar = display.newImageRect(group, "Art/black_fraying_bar.png", 240, 20)
  healthbar.overlay_bar.x = x + 240
  healthbar.overlay_bar.y = y
  healthbar.overlay_bar.anchorX = 1
  healthbar.overlay_bar.anchorY = 0
  healthbar.overlay_bar.isVisible = false
  healthbar.health_percent = 100
  return healthbar
end

function HealthBar:setHealth(health_percent)
  self.health_percent = health_percent
  self.overlay_bar.isVisible = false
  self.foreground_bar.isVisible = true
  if (self.health_percent < 100) then
    self.overlay_bar.isVisible = true
    self.overlay_bar:setFrame(math.random(1, 3))
    self.overlay_bar.xScale = (100 - self.health_percent) / 100.0
    if (self.health_percent < 1) then
      self.foreground_bar.isVisible = false
      self.overlay_bar.isVisible = false
    end
  end
end

return HealthBar