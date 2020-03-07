
local composer = require("composer")
local smoke = require("Source.Utilities.smoke")

level = {}
level.__index = level

-- your max_x is artificially set at the right side of the current zone.
-- your min_x is set at either 0, or your highest right value minus 1000.
-- min_x also won't go over 10,000, so you can always walk around the hotel area.
-- I don't want to have to worry about whether you can go back and revisit shops,
-- so they're intentionally set so that once you cross the next boundary, you
-- can't actually backtrack to them anyway.
-- camera maxes are also set to match.
local zones = {
  {min=0, max=1600, type="goons", num=1, pace=4000, max_bads=1},
  {min=0, max=1600, type="hotel", num=0, max_bads=3},
}

local max_smoke_clouds = 2000
local min_scale = 0.1
local max_scale = 0.4

function level:create(game)

  local object = {}
  setmetatable(object, level)

  self.candidates = {}
  self.candidates["suit"] = require("Source.Candidates.Suit")

  self.game = game
  self.player = game.player

  self.current_zone = 0
  self.player_furthest_x = 0
  self.time_since_last_bad = 0
  self.player_starting_x = 580

  self.goon_type = "suit"

  self.added_first_smoke = false

  return object
end

function level:buildLevel()

  game = self.game

  background = display.newImageRect(game.mainGroup, "Art/smoke_filled_room.png", 1600, 800)
  background.anchorX = 0
  background.x = 0
  background.anchorY = 1
  background.y = display.contentHeight / game.game_scale

end


function level:addBad(val)

  game = self.game
  player = self.player

  local start_x = math.min(player.max_x + 180, player.x + 700)
  dice = math.random(1, 99)
  if dice > 80 then
    start_x = player.x - 400
  elseif dice > 40 then
    start_x = player.x + 300
  end
  if val ~= nil then
    start_x = val
  end
  
  local fighter = self.candidates[self.goon_type]:create(start_x, display.contentCenterY, game.mainGroup, game.min_x, game.max_x, game.min_z, game.max_z, game.effects)
  if dice > 33 then
    fighter:setZ(300)
  end
  fighter.target = player
  fighter.side = "bad"
  fighter:enable()

  table.insert(game.fighters, fighter)

  fighter.fighters = game.fighters

  self.time_since_last_bad = system.getTimer()

  return fighter
end

function level:addSmoke()
  game = self.game
  effects = self.game.effects

  print(effects.counts["smoke_cloud"])
  print(#effects.effect_list)
  if effects.counts["smoke_cloud"] == nil or effects.counts["smoke_cloud"] < max_smoke_clouds then
    smoke_cloud = {}
    smoke_cloud.type = "smoke_cloud"
    smoke_cloud.sprite = display.newImageRect(game.foregroundGroup, "Art/cloud.png", 256, 256)
    scale = math.random(1000 * min_scale, 1000 * max_scale) / 1000.0
    smoke_cloud.sprite.xScale = scale
    smoke_cloud.sprite.yScale = scale
    smoke_cloud.sprite.x = math.random(0, 1600)
    smoke_cloud.sprite.y = math.random(0, 800)
    smoke_cloud.max_alpha = math.random(1,100) / 100
    smoke_cloud.sprite.alpha = 0
    smoke_cloud.start_time = system.getTimer()
    smoke_cloud.rotation_vel = -1 * math.random(1,100) / 100
    smoke_cloud.x_vel = math.random(1,100) / 200
    function smoke_cloud:update()
      if self.sprite.alpha < self.max_alpha then
        self.sprite.alpha = self.sprite.alpha + 0.01
      end
      self.sprite.rotation = self.rotation_vel
      self.sprite.x = self.sprite.x + self.x_vel
    end
    function smoke_cloud:finished()
      return false
    end
    effects:add(smoke_cloud)
  end
end

function level:checkLevel()

  -- if self.added_first_smoke == false then
  --   self.added_first_smoke = true
  --   for i = 1,2000 do
  --     self:addSmoke()
  --   end
  -- end
  for i = 1,10 do
    self:addSmoke()
  end

  game = self.game
  player = self.player
  fighters = game.fighters
  camera = game.camera
  effects = game.effects
  state = game.state

  -- remove dead bads from the stage
  local new_fighters = {}
  for i = 1, #fighters do
    fighter = fighters[i]
    if fighter ~= game.player and fighter.action == "blinking" and fighter.blinking_start_time ~= nil and system.getTimer() - fighter.blinking_start_time > 3000 then
      fighter:disable()
      display.remove(fighter)
    else
      table.insert(new_fighters, fighter)
    end
  end
  game.fighters = new_fighters
  fighters = game.fighters
  for i = 1, #fighters do
    fighters[i].fighters = game.fighters
  end

  -- count bads and active bads
  num_bads = 0
  num_active_bads = 0
  for i = 1, #fighters do
    if fighters[i].side == "bad" then
      num_bads = num_bads + 1
      if fighters[i].health > 0 then
        num_active_bads = num_active_bads + 1
      end
    end
  end

  -- check if the zone needs to be progressed, and update max_x for all fighters and the camera.
  if self.current_zone == 0
    or (zones[self.current_zone].type == "goons" and zones[self.current_zone].num <= 0 and num_active_bads == 0) 
    or (zones[self.current_zone].type == "shop" and player.x > zones[self.current_zone].max - 200) then
    self.current_zone = self.current_zone + 1
    self.time_since_last_bad = system.getTimer()
    
    -- here do the arrow effect
    if self.current_zone > 1 then
      game.effects:addArrow(game.uiGroup, display.contentWidth - 64, display.contentCenterY, 128, 0, 3000)
      if zones[self.current_zone].arrow ~= nil then
        game.effects:addArrow(game.foregroundGroup, zones[self.current_zone].arrow.x, zones[self.current_zone].arrow.y, 64, 90, -1)
      end
    end
  end

  -- don't check the rest if we somehow haven't left zone 0
  if self.current_zone == 0 then
    return
  end

  if zones[self.current_zone].type == "goons" 
    and (system.getTimer() - self.time_since_last_bad > zones[self.current_zone].pace or num_active_bads == 0)
    and zones[self.current_zone].num > 0
    and num_active_bads < zones[self.current_zone].max_bads
    and self.player_furthest_x >= zones[self.current_zone].min then
    fighter = self:addBad()
    fighter:enableAutomatic()
    zones[self.current_zone].num = zones[self.current_zone].num - 1
  end

  -- update min x for good guys, and max x for everyone and the camera
  self.player_furthest_x = math.max(self.player_furthest_x, player.x)
  for i = 1, #fighters do
    if fighters[i].side == "good" then
      fighters[i].min_x = math.min(10000, self.player_furthest_x - 1000)
    end
    fighters[i].max_x = zones[self.current_zone].max
  end
  camera.max_x = zones[self.current_zone].max - display.contentWidth - 200
end

function level:checkEnding()

end

return level