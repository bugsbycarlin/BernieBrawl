
local composer = require("composer")
local smoke = require("Source.Utilities.smoke")
-- local textBubble = require("Source.Utilities.textBubble")
local scriptMaker = require("Source.Utilities.scriptMaker")

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

local max_smoke_clouds = 1500
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
  self.time_since_last_bad = 0
  self.player_starting_x = 640

  self.biden = nil

  self.added_biden = false

  self.goon_type = "biden"

  self.added_first_smoke = false

  self.finished = false

  self.skip_intro = false

  self.stage_music = audio.loadStream("Sound/level_4.mp3")

  return object
end

function level:buildLevel()

  game = self.game

  background = display.newImageRect(game.mainGroup, "Art/smoke_filled_room.png", 1600, 800)
  background.anchorX = 0
  background.x = 0
  background.anchorY = 0
  background.y = 0

  audio.stop()
  audio.setVolume(1, { channel = 2})
  audio.play(self.stage_music, {channel=2, loops=-1})

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
  -- biden:enable()
  biden.sprite:setFrame(39)

  table.insert(game.fighters, biden)

  biden.fighters = game.fighters

  self.time_since_last_bad = system.getTimer()

  self.added_biden = true

  return biden
end

function level:addSmoke()
  game = self.game
  effects = self.game.effects
  biden = self.biden

  if effects.counts["smoke_cloud"] == nil or effects.counts["smoke_cloud"] < max_smoke_clouds then
    smoke_cloud = {}
    smoke_cloud.type = "smoke_cloud"
    smoke_cloud.sprite = display.newImageRect(game.foregroundGroup, "Art/cloud.png", 256, 256)
    scale = math.random(1000 * min_scale, 1000 * max_scale) / 1000.0
    smoke_cloud.sprite.xScale = scale
    smoke_cloud.sprite.yScale = scale
    smoke_cloud.sprite.x = math.random(0, 1600)
    smoke_cloud.sprite.y = math.random(200, 800)
    smoke_cloud.max_alpha = math.random(1,100) / 100
    smoke_cloud.sprite.alpha = 0
    smoke_cloud.start_time = system.getTimer()
    smoke_cloud.rotation_vel = -1 * math.random(1,100) / 100
    smoke_cloud.x_vel = math.random(1,100) / 200
    smoke_cloud.max_x_vel = smoke_cloud.x_vel
    function smoke_cloud:update()
      if biden.health <= 0 then
        -- self.x_vel = self.x_vel + 1 + math.random(1,100) / 200.0
        self.x_vel = self.x_vel * 1.07
      end
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

  -- print(audio.isChannelPlaying(1))
  -- print(audio.isChannelPlaying(2))
  -- if audio.isChannelPlaying(1) == false and audio.isChannelPlaying(2) == false then
  --   audio.play(self.stage_music, {channel=2, loops=-1})
  -- end

  if game.state == "active" and self.biden.health > 0 then
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
  if self.current_zone == 0 and self.skip_intro == false then
    self.current_zone = self.current_zone + 1
    self.time_since_last_bad = system.getTimer()

      game.state = "pre_fight_sequence_1"
      timer.performWithDelay(1500, function()
        player.script_side = "left"
        self.biden.script_side = "right"
        script_end_time = scriptMaker:makeScript(
          effects,
          game.foregroundGroup,
          2000, -- default length
          0, -- default padding
          14, -- default font size
          {
            {name=self.biden, text="How you doing, Bernie?"},
            {name=player, text="I'm angry, Joe.", padding=1200},
            {name=player, text="I don't want to see the nomination"},
            {name=player, text="decided in a smoke filled room."},
            {name=self.biden, text="As if it really matters.", action=function() game.state = "pre_fight_sequence_2" end},
            {name=player, text="The people won't stand for it."},
            {name=self.biden, text="The people don't matter, Bernie."},
            {name=self.biden, text="None of this really matters.", padding=1000},
            {name=self.biden, text="It's a smoke filled world."},
          })
        timer.performWithDelay(script_end_time, function()
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
      end)
  elseif self.current_zone == 0 and self.skip_intro == true then
      self.current_zone = self.current_zone + 1
      player:enable()
      self.biden:disable()
      self.biden:enable()
      self.biden:enableAutomatic()
      self.biden.sprite.alpha = 1

      game.state = "active"
      game.uiGroup.isVisible = true
      fighters = {self.player, self.biden}
      player.fighters = fighters
      self.biden.fighters = fighters
      game.fighters = fighters
      if self.fake_biden ~= nil then
        self.fake_biden:disable()
      end
      display.remove(self.fake_biden)
      self.fake_biden = nil
      self.biden.target = player

  end

  if self.current_zone == 1 and self.added_biden == true and self.player.health > 0 and self.biden.health <= 0 and self.biden.y_vel == 0 and self.finished == false then
    self.finished = true

    game.state = "post_fight"
    

    timer.performWithDelay(3000, function()
      self.player:celebratingAction()
    end)

    timer.performWithDelay(5000, function()
      script_end_time = scriptMaker:makeScript(
        effects,
        game.foregroundGroup,
        3000, -- default length
        0, -- default padding
        14, -- default font size
        {
          {name=player, text="Fuck around and find out, Joe.",},
        })
      -- timer.performWithDelay(script_end_time, function()

      -- end)
    end)
  end

  if game.state == "active" then
    player.min_x = 500
    player.max_x = 1100
    self.biden.min_x = 500
    self.biden.max_x = 1100
    camera.max_x = 700
    camera.min_x = 0
  end

  -- update min x for good guys, and max x for everyone and the camera
  -- self.player_furthest_x = math.max(self.player_furthest_x, player.x)
  -- for i = 1, #fighters do
  --   if fighters[i].side == "good" then
  --     fighters[i].min_x = math.min(10000, self.player_furthest_x - 1000)
  --   end
  --   fighters[i].max_x = zones[self.current_zone].max
  -- end
  -- camera.max_x = zones[self.current_zone].max - display.contentWidth - 200

end

function level:checkEnding()

end

return level