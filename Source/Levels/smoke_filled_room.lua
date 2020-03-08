
local composer = require("composer")
local smoke = require("Source.Utilities.smoke")
local textBubble = require("Source.Utilities.textBubble")

level = {}
level.__index = level

local function distance(x1, y1, x2, y2)
  return math.sqrt((x1-x2)^2 + (y1 - y2)^2)
end

-- your max_x is artificially set at the right side of the current zone.
-- your min_x is set at either 0, or your highest right value minus 1000.
-- min_x also won't go over 10,000, so you can always walk around the hotel area.
-- I don't want to have to worry about whether you can go back and revisit shops,
-- so they're intentionally set so that once you cross the next boundary, you
-- can't actually backtrack to them anyway.
-- camera maxes are also set to match.
local zones = {
  {min=0, max=1600, type="biden", num=1, pace=4000, max_bads=1},
  {min=0, max=1600, type="hotel", num=0, max_bads=3},
}

local max_smoke_clouds = 2000
local min_scale = 0.1
local max_scale = 0.4

function level:create(game)

  local object = {}
  setmetatable(object, level)

  self.candidates = {}
  self.candidates["biden"] = require("Source.Candidates.Biden")

  self.game = game
  self.player = game.player

  self.current_zone = 0
  self.player_furthest_x = 0
  self.time_since_last_bad = 0
  self.player_starting_x = 640

  self.biden = nil

  self.added_biden = false

  self.goon_type = "biden"

  self.added_first_smoke = false

  self.stage_music = audio.loadStream("Sound/level_4.mp3")

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

function level:prepareToActivate()
  self.fake_biden = self:addBiden()
  self.biden = self:addBiden()
  self.biden.sprite:setFrame(1)
  self.biden.sprite.alpha = 0
  self.fake_biden.sprite:setFrame(39)
  self.player:disable()
  self.game.uiGroup.isVisible = false
  self.biden.target = self.player
  --self.player:enable()
  --timer.performWithDelay(2500, function() self.game:activateGame() end)
end

function level:addBiden(val)

  game = self.game
  player = self.player
  
  biden = self.candidates[self.goon_type]:create(player.x + 300, player.y - 60, game.mainGroup, game.min_x, game.max_x, game.min_z, game.max_z, game.effects)
  biden.side = "bad"
  biden.xScale = -1
  biden:enable()
  biden.sprite:setFrame(39)

  table.insert(game.fighters, biden)

  biden.fighters = game.fighters

  self.time_since_last_bad = system.getTimer()

  return biden
end

function level:addSmoke()
  game = self.game
  effects = self.game.effects

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
    smoke_cloud.max_x_vel = smoke_cloud.x_vel
    function smoke_cloud:update()
      -- if game.state == "active" and self.sprite.x > 500 and self.sprite.x < 1100 then
      --   for i = 1, #game.fighters do
      --     m = distance(self.sprite.x, self.sprite.y, game.fighters[i].x, game.fighters[i].y + game.fighters[i].z)
      --     print(m)
      --     if m < 70 then
      --       self.x_vel = self.x_vel + 0.02 * game.fighters[i].x_vel
      --     end
      --   end
      -- end
      -- if self.x_vel > self.max_x_vel then
      --   self.x_vel = self.x_vel * 0.95
      -- end
      if self.sprite.alpha < self.max_alpha then
        self.sprite.alpha = self.sprite.alpha + 0.01
      end
      self.sprite.rotation = self.rotation_vel
      self.sprite.x = self.sprite.x + self.x_vel
    end
    function smoke_cloud:finished()
      return self.sprite.x < 0 or self.sprite.x > 1500
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
  if game.state == "active" then
    for i = 1,10 do
      self:addSmoke()
    end
  end
  if game.state == "pre_fight_sequence_2" then
    for i = 1,3 do
      self:addSmoke()
    end
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

  if game.state == "pre_fight_sequence_1" then
    player:disable()
    if self.biden ~= nil then
      self.biden:disable()
    end
    if self.fake_biden ~= nil then
      self.fake_biden:disable()
    end
    self.biden.sprite:setFrame(1)
    self.biden.sprite.alpha = 0
    self.biden.alpha_tracker = 0
    self.fake_biden.sprite:setFrame(39)
  end

  if game.state == "pre_fight_sequence_2" then
    player:disable()
    if self.biden ~= nil then
      self.biden:disable()
    end
    if self.fake_biden ~= nil then
      self.fake_biden:disable()
    end
    self.biden.alpha_tracker = math.min(1, self.biden.alpha_tracker + 0.004)
    self.biden.sprite.alpha = self.biden.alpha_tracker
    self.fake_biden.sprite.alpha = math.max(0, self.fake_biden.sprite.alpha - 0.004)
  end

  -- check if the zone needs to be progressed, and update max_x for all fighters and the camera.
  if self.current_zone == 0 then
    self.current_zone = self.current_zone + 1
    self.time_since_last_bad = system.getTimer()
    
    -- here do the arrow effect
    -- if self.current_zone > 1 then
    --   game.effects:addArrow(game.uiGroup, display.contentWidth - 64, display.contentCenterY, 128, 0, 3000)
    --   if zones[self.current_zone].arrow ~= nil then
    --     game.effects:addArrow(game.foregroundGroup, zones[self.current_zone].arrow.x, zones[self.current_zone].arrow.y, 64, 90, -1)
    --   end
    -- end

      game.state = "pre_fight_sequence_1"
      timer.performWithDelay(1500, function() 
        
        timer.performWithDelay(0, function()
          bubble = textBubble:create(self.biden, game.foregroundGroup, "How you doing, Bernie?", "left", -50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(2000, function()
          bubble = textBubble:create(player, game.foregroundGroup, "I'm angry, Joe.", "right", 50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(4000, function()
          bubble = textBubble:create(player, game.foregroundGroup, "I don't want to see the nomination", "right", 50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(6000, function()
          bubble = textBubble:create(player, game.foregroundGroup, "decided in a smoke filled room.", "right", 50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(8000, function()
          bubble = textBubble:create(self.biden, game.foregroundGroup, "As if it really matters.", "left", -50, -105, 2000)
          effects:add(bubble)
          game.state = "pre_fight_sequence_2"
          if audio.isChannelPlaying(1) == false and audio.isChannelPlaying(2) == false then
            audio.play(self.stage_music, {channel=2, loops=-1})
          end
        end)
        timer.performWithDelay(10000, function()
          bubble = textBubble:create(player, game.foregroundGroup, "The people won't stand for it.", "right", 50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(12000, function()
          bubble = textBubble:create(self.biden, game.foregroundGroup, "The people don't matter, Bernie.", "left", -50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(14000, function()
          bubble = textBubble:create(self.biden, game.foregroundGroup, "None of this really matters.", "left", -50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(17000, function()
          bubble = textBubble:create(self.biden, game.foregroundGroup, "It's a smoke filled world.", "left", -50, -105, 2000)
          effects:add(bubble)
        end)
        timer.performWithDelay(19000, function()
          player:enable()
          self.biden:enable()
          self.biden:enableAutomatic()
          game.state = "active"
          game.uiGroup.isVisible = true
          fighters = {self.player, self.biden}
          player.fighters = fighters
          self.biden.fighters = fighters
          game.fighters = fighters
          display.remove(self.fake_biden)
          self.fake_biden = nil
          self.biden.target = player
        end)
        -- timer.performWithDelay(5000, function()
        --   bubble = textBubble:create(player, game.foregroundGroup, "And you said you'd never take Super PAC money.", "right", 50, -105, 2000)
        --   effects:add(bubble)
        -- end)
        -- timer.performWithDelay(7500, function()
        --   bubble = textBubble:create(self.warren, game.foregroundGroup, "You can't get the job done, Bernie.", "left", -50, -105, 2000)
        --   effects:add(bubble)
        -- end)
        -- timer.performWithDelay(10000, function()
        --   bubble = textBubble:create(self.warren, game.foregroundGroup, "So I have a plan to take your lane.", "left", -50, -105, 2000)
        --   effects:add(bubble)
        -- end)
        -- timer.performWithDelay(12500, function()
        --   bubble = textBubble:create(self.warren, game.foregroundGroup, "Step one is to mess you up.", "left", -50, -105, 2000)
        --   effects:add(bubble)
        -- end)
        -- timer.performWithDelay(15000, function()
        --   bubble = textBubble:create(player, game.foregroundGroup, "Fine, you want a childish playground fight?", "right", 50, -105, 2000)
        --   effects:add(bubble)
        -- end)
        -- timer.performWithDelay(17500, function()
        --   bubble = textBubble:create(player, game.foregroundGroup, "We're on a playground.", "right", 50, -105, 1000)
        --   effects:add(bubble)
        -- end)
        -- timer.performWithDelay(19000, function()
        --   bubble = textBubble:create(player, game.foregroundGroup, "Let's fight.", "right", 50, -105, 1500)
        --   effects:add(bubble)
        -- end)
        --   timer.performWithDelay(1000, function() 
        --   game.state = "pre_fight_3" 
        -- end)
        -- timer.performWithDelay(20500, function()
        --   player:enable()
        --   self.warren:enable()
        --   self.warren:enableAutomatic()
        --   zones[self.current_zone].num = 0
        --   game.state = "active"
        --   game.uiGroup.isVisible = true
        -- end)
      end)
    
  end

  -- don't check the rest if we somehow haven't left zone 0
  if self.current_zone == 0 then
    return
  end

  -- if zones[self.current_zone].type == "goons" 
  --   and (system.getTimer() - self.time_since_last_bad > zones[self.current_zone].pace or num_active_bads == 0)
  --   and zones[self.current_zone].num > 0
  --   and num_active_bads < zones[self.current_zone].max_bads
  --   and self.player_furthest_x >= zones[self.current_zone].min then
  --   fighter = self:addBad()
  --   fighter:enableAutomatic()
  --   zones[self.current_zone].num = zones[self.current_zone].num - 1
  -- end

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