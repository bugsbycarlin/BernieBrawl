
local composer = require("composer")

local scene = composer.newScene()

local healthBar = require("Source.Utilities.healthBar")

local effects_system = require("Source.Utilities.effects")

local textBubble = require("Source.Utilities.textBubble")

local function gotoPostfight()
  composer.removeScene("Source.Scenes.postfight")
  composer.gotoScene("Source.Scenes.postfight", {effect = "crossFade", time = 2000})
end

local function pause(event)
  audio.pause(2)
  composer.gotoScene("Source.Scenes.pause")
  paused = true

  return true
end

number_sheet =
{
    frames = {
    
        { x=0, y=0, width=568, height=320,},
        { x=0, y=320, width=568, height=320,},
        { x=0, y=640, width=568, height=320,},
        { x=0, y=960, width=568, height=320,},
        { x=0, y=1280, width=568, height=320,},
        { x=0, y=1600, width=568, height=320,},
        { x=0, y=1920, width=568, height=320,},
        { x=0, y=2240, width=568, height=320,},
        { x=0, y=2560, width=568, height=320,},
        { x=0, y=2880, width=568, height=320,},

    },

    sheetContentWidth = 568,
    sheetContentHeight = 4096
}
local numbers = graphics.newImageSheet("Art/number_sheet.png", number_sheet)

function scene:initializeAllKindsOfStuff()

  self.candidates = {}
  self.candidates["sanders"] = require("Source.Candidates.Sanders")

  self.paused = false

  self.show_hitboxes = false

  self.mobile_controls = false

  self.state = "undefined"

  self.game_scale = 0.75

  self.min_x = 0
  self.max_x = 12000
  self.min_z = -90
  self.max_z = 100

  self.camera = {
    x = 0,
    y = 0,
    move = true,
    speed = 0.2,
    offset_x = 100, -- how far off center should Bernie be?
    offset_y = -50, -- how igh above Bernie should the camera be?
    min_x = 0,
    max_x = self.max_x - display.contentWidth - 200,
    min_y = -500,
    max_y = 370,
    target_center_x = display.contentCenterX / self.game_scale,
    target_center_y = display.contentCenterY / self.game_scale,

    setToTarget = function(self, drift, object_x, object_y, reference, groups, parallax_values)
      diff_x = self.offset_x + object_x - self.target_center_x
      diff_y = self.offset_y + object_y - self.target_center_y

      if drift then
        -- blend with old camera position
        self.x = math.min(self.max_x, math.max(self.min_x, self.speed * diff_x + (1 - self.speed) * self.x))
        self.y = math.min(self.max_y, math.max(self.min_y, self.speed * diff_y + (1 - self.speed) * self.y))
      else
        -- set new camera position
        self.x = math.min(self.max_x, math.max(self.min_x, diff_x))
        self.y = math.min(self.max_y, math.max(self.min_y, diff_y))
      end

      -- assign to groups
      for i = 1,#groups do
        groups[i].x = -1 * parallax_values[i] * self.x
        groups[i].y = -1 * self.y
      end
    end,
  }

  self.keydown = {
    left=false,
    right=false,
    up=false,
    down=false,
    a=false,
    s=false,
    d=false,
  }

  self.keyup = {
    left=false,
    right=false,
    up=false,
    down=false,
  }

  self.shop_selection = 0

  self.fighters = {}

  function scene:gotoGame(game_scene)
    composer.setVariable("game_scene", game_scene)
    composer.gotoScene("Source.Scenes.gameIntermediary")
  end

  function scene:gotoComic(comic_scene)
    composer.setVariable("comic_scene", comic_scene)
    composer.gotoScene("Source.Scenes.comic")
  end

  function scene:activateGame()
    for i = 1, #self.fighters do
      if self.fighters[i] ~= self.player then
        self.fighters[i]:enableAutomatic()
      end
    end
    self.state = "active"
  end

  function scene:checkMobileButtonUI()
    if self.state ~= "active" then
      if self.state == "ending" then
        self.red_button.alpha = 0.0
        self.green_button.alpha = 0.0
        self.blue_button.alpha = 0.0
        self.right_panel.alpha = 0.0
      else
        self.red_button.alpha = 0.5
        self.green_button.alpha = 0.5
        self.blue_button.alpha = 0.5
        self.right_panel.alpha = 0.5
      end
    elseif self.player.action ~= "resting" and self.player.action ~= "blocking" then
      self.red_button.alpha = 0.5
      self.green_button.alpha = 0.5
      if self.player.action ~= "jumping" then
        self.blue_button.alpha = 0.5
        self.right_panel.alpha = 0.5
      else
        self.blue_button.alpha = 1.0
        self.right_panel.alpha = 1.0
      end
    elseif self.player.action == "blocking" then
      self.red_button.alpha = 0.5
      self.green_button.alpha = 1.0
      self.blue_button.alpha = 1.0
      self.right_panel.alpha = 1.0
    else
      self.red_button.alpha = 1.0
      self.green_button.alpha = 1.0
      self.blue_button.alpha = 1.0
      self.right_panel.alpha = 1.0
    end
  end

  function scene:showHitBoxes()
    for i = self.hitBoxGroup.numChildren, 1, -1 do
      self.hitBoxGroup[i]:removeSelf()
      self.hitBoxGroup[1] = nil
    end
    for i = 1,#self.fighters do
      frame = self.fighters[i].sprite.frame
      local hitIndex = self.fighters[i].hitIndex[frame]
      if hitIndex ~= nil and #hitIndex > 0 then
        for j = 1, #hitIndex do
          x,y = self.fighters[i]:localToContent(hitIndex[j].x, hitIndex[j].y + self.fighters[i].z)
          local circle = display.newCircle(self.hitBoxGroup, x, y, hitIndex[j].radius * self.game_scale)
          circle.alpha = 0.5
          purpose = hitIndex[j].purpose
          if purpose == "attack" then
            circle:setFillColor( 0.8, 0.5, 0.5 )
          elseif purpose == "defense" then
            circle:setFillColor( 0.5, 0.5, 0.8 )
          elseif purpose == "vulnerability" then
            circle:setFillColor( 0.5, 0.8, 0.5 )
          end
        end
      end
    end
  end

  function scene:debugGrid()
    for x = 0, 12000, 50 do
      line = display.newLine(self.foregroundGroup, x, -400, x, 800)
      line:setStrokeColor(0.5, 0.5, 0.5, 0.5)
    end

    for y = -400, 800, 50 do
      line = display.newLine(self.foregroundGroup, 0, y, 12000, y)
      line:setStrokeColor(0.5, 0.5, 0.5, 0.5)
    end

    for x = 0, 12000, 200 do
      for y = -400, 800, 200 do
        text = display.newText(
          self.foregroundGroup,
          x .. "," .. y,
          x, y,
          "Georgia-Bold", 8)
        text.anchorX = 0
        text.anchorY = 0
        text:setTextColor(0.5, 0.5, 0.5)
        text.alpha = 0.5
      end
    end
  end

  -- function scene:checkEnding()

  --   other_fighters_awake = false
  --   for i = 1, #self.other_fighters do
  --     if self.other_fighters[i].health > 0 then
  --       other_fighters_awake = true
  --     end
  --   end

  --   player_awake = (self.player.health > 0)

  --   if player_awake == false or other_fighters_awake == false then
  --     self.state = "ending"
  --     for i = 1, #self.fighters do
  --       self.fighters[i]:disableAutomatic()
  --     end

  --     -- Runtime:removeEventListener("touch", self.swipe)
  --     if self.mobile_controls == true then
  --       Runtime:removeEventListener("key", self.debugKeyboard)
  --     else
  --       Runtime:removeEventListener("key", self.properKeyboard)
  --     end

  --     player_wins = composer.getVariable("player_wins")
  --     opponent_wins = composer.getVariable("opponent_wins")
  --     round = composer.getVariable("round")

  --     round = round + 1

  --     if player_awake == true and other_fighters_awake == false then -- a win
  --       timer.performWithDelay(1000, function() self.player:celebratingAction() end)
  --       player_wins = player_wins + 1
  --       if player_wins > 1 then
  --         player_wins = 0
  --         opponent_wins = 0
  --         round = 1
  --         composer.setVariable("winning_fighter", player.short_name)
  --         composer.setVariable("ko_fighter", player.target.short_name)
  --         composer.setVariable("gameover", false)
  --         timer.performWithDelay(4000, function()
  --           ko_x, ko_y = self.player.target:localToContent(0,0)
  --           composer.setVariable("ko_location", {x=ko_x,y=ko_y, xScale=self.player.target.xScale})
  --           gotoPostfight()
  --         end)
  --       else
  --         timer.performWithDelay(4000, gotoGame)
  --       end
  --     elseif other_fighters_awake == true and player_awake == false then -- a loss
  --       for i = 1, #self.other_fighters do
  --         if self.other_fighters[i].health > 0 then
  --           timer.performWithDelay(1000, function() self.other_fighters[i]:celebratingAction() end)
  --         end
  --       end
  --       opponent_wins = opponent_wins + 1
  --       if opponent_wins > 1 then
  --         player_wins = 0
  --         opponent_wins = 0
  --         round = 1
  --         composer.setVariable("winning_fighter", self.player.target.short_name)
  --         composer.setVariable("ko_fighter", self.player.short_name)
  --         composer.setVariable("gameover", true)
  --         timer.performWithDelay(4000, function() 
  --           ko_x, ko_y = self.player:localToContent(0,0)
  --           composer.setVariable("ko_location", {x=ko_x,y=ko_y, xScale=self.player.xScale})
  --           gotoPostfight()
  --         end)
  --       else
  --         timer.performWithDelay(4000, gotoGame)
  --       end
  --     elseif player_awake == false and other_fighters_awake == false then -- a draw
  --       -- do something
  --       timer.performWithDelay(4000, gotoGame)
  --     end

  --     composer.setVariable("player_wins", player_wins)
  --     composer.setVariable("opponent_wins", opponent_wins)
  --     composer.setVariable("round", round)
  --   end
  -- end

  self.key_history = {}
  function scene:checkInput()

    if self.state == "active" and self.keydown.up and self.player.x > 2948 - 60 and self.player.x < 2948 + 60 and self.player.z < self.player.min_z + 5 then
      self.shoppingGroup.isVisible = true
      self.state = "shopping"

    elseif self.state == "shopping" then

      -- blah
      if self.keydown.up then
        self.shop_selection = self.shop_selection - 1
        if self.shop_selection < 0 then
          self.shop_selection = 2
        end
      elseif self.keydown.down then
        self.shop_selection = self.shop_selection + 1
        if self.shop_selection > 2 then
          self.shop_selection = 0
        end
      end

      self.temporary_shop_selector.y = display.contentCenterY + 30 * self.shop_selection

      if self.keydown.enter and self.shop_selection == 2 then
        self.shoppingGroup.isVisible = false
        self.shop_selection = 0
        self.state = "active"
      end
    elseif self.state == "active" then

      if self.keydown.left and self.keydown.up then
        table.insert(self.key_history, "left-up")
        self.player:moveAction(-1 * self.player.max_x_velocity * 0.7, -1 * self.player.max_y_velocity)
      elseif self.keydown.right and self.keydown.up then
        table.insert(self.key_history, "right-up")
        self.player:moveAction(self.player.max_x_velocity * 0.7, -1 * self.player.max_y_velocity)
      elseif self.keydown.up and (self.player.move_direction ~= "up" or self.player.move_decay == 0 or self.player.move_decay > 5) then
        table.insert(self.key_history, "up")
        self.player:zMoveAction(-1 * self.player.max_z_velocity * 0.7)
      elseif self.keydown.down and (self.player.move_direction ~= "down" or self.player.move_decay == 0 or self.player.move_decay > 5) then
        table.insert(self.key_history, "down")
        self.player:zMoveAction(self.player.max_z_velocity * 0.7)
      elseif self.keydown.left and (self.player.move_direction ~= "left" or self.player.move_decay == 0 or self.player.move_decay > 5) then
        print(self.player.x)
        if self.player.x < 5 then
          dice = math.random(1,100)
          if dice > 30 then
            bubble = textBubble:create(self.player, self.effects.foreground_group, 14, "Hey, I won't go negative.", "left", self.player.script_offset_x, self.player.script_offset_y, 1500)
            self.effects:add(bubble)
          end
        elseif self.player.x < self.player.min_x + 5 then
          dice = math.random(1,100)
          if dice > 30 then
            bubble = textBubble:create(self.player, self.effects.foreground_group, 14, "We're taking America forward, not backward.", "left", self.player.script_offset_x, self.player.script_offset_y, 1500)
            self.effects:add(bubble)
          end
        end

        table.insert(self.key_history, "left")
        self.player:moveAction(-1 * self.player.max_x_velocity * 0.7, 0)
      elseif self.keydown.right and (self.player.move_direction ~= "right" or self.player.move_decay == 0 or self.player.move_decay > 5) then
        table.insert(self.key_history, "right")
        self.player:moveAction(self.player.max_x_velocity * 0.7, 0)
      end

      if self.keydown.a == true and (self.player.action == "resting") then
        table.insert(self.key_history, "a")
        self.player:blockingAction()
      elseif self.keydown.a == false and self.player.action == "blocking" then
        self.player:restingAction()
      end

      if self.keydown.s == true then
        table.insert(self.key_history, "s")
        if self.player.action == "resting" then
          self.player:punchingAction()

        elseif self.player.action == "jumping" then
          self.player:jumpAttackAction()
        end
      end

      if self.keydown.d == true then
        table.insert(self.key_history, "d")
        if self.player.action == "resting" then
          self.player:kickingAction()

        elseif self.player.action == "jumping" then
          self.player:jumpAttackAction()
        end
      end

      if #self.key_history > 3 then
        if self.key_history[#self.key_history - 2] == "a" and self.key_history[#self.key_history - 1] == "d" and self.key_history[#self.key_history] == "up" then
          self.player:specialAction()
          self.key_history = {}
        end
      end

      if #self.key_history > 3 then
        if self.key_history[#self.key_history - 2] == "a" and self.key_history[#self.key_history - 1] == "a" 
          and ((self.key_history[#self.key_history] == "right" and self.player.xScale == 1)  or (self.key_history[#self.key_history] == "left" and self.player.xScale == -1)) then
          self.player:specialThrow()
          self.key_history = {}
        end
      end

      if #self.key_history > 5 then
        new_key_history = {}
        for i = 2,#self.key_history do
          table.insert(new_key_history, self.key_history[i])
        end
        self.key_history = new_key_history
      end
    end
  end

  function scene:resetInput()
    self.keydown = {
      left=false,
      right=false,
      up=false,
      down=false,
      s=false,
      d=false,
      enter=false,
    }

    self.keyup = {
      left=false,
      right=false,
      up=false,
      down=false,
    }
  end

  function scene:gamepadCheck()
    self.old_gamepad = self.gamepad
    self.gamepad = false
    self.device = nil
    self.player.rumble_device = nil
    local inputDevices = system.getInputDevices()
 
    for i = 1,#inputDevices do
      local device = inputDevices[i]
      if string.find(string.lower(device.descriptor), "gamepad") or string.find(string.lower(device.descriptor), "controller") then
        self.gamepad = true
        if self.device == nil then
          self.device = device
          self.player.rumble_device = device
        end
      end
    end

    if self.gamepad == true then
      print("Have a gamepad!")
    else
      print("Have no gamepad!")
    end

    if self.old_gamepad == true and self.gamepad == false then
      -- we lost gamepad. put a blinker on screen
      self.effects:addControllerMessage(self.uiGroup, display.contentWidth - 280, display.contentHeight - 30, 3000, "Controller unplugged. Switch to keyboard!")
    elseif self.old_gamepad == false and self.gamepad == true then
      -- we gained a gamepad. put a blinker on screen
      self.effects:addControllerMessage(self.uiGroup, display.contentWidth - 180, display.contentHeight - 30, 3000, "Controller present. Use it!")
    elseif self.old_gamepad == nil and self.gamepad == true then
      self.effects:addControllerMessage(self.uiGroup, display.contentWidth - 260, display.contentHeight - 30, 3000, "Using controller! Pause to see controls.")
    elseif self.old_gamepad == nil and self.gamepad == false then
      self.effects:addControllerMessage(self.uiGroup, display.contentWidth - 330, display.contentHeight - 30, 3000, "Using keyboard! Hit esc to pause and see controls.")

    end
  end

  function scene:gamepadChanged(event)
    if (event.connectionStateChanged) then
      if (event.device.isConnected) then
        print("Device connected")
      else
        print("Device disconnected")
      end
      self:gamepadCheck()
    end
  end

  function scene:gameLoop()

    if self.state == "active" or self.state == "shopping" then
      -- checkEnding()
      self:checkInput()
    end

    self.level:checkLevel()
    
    -- if self.state ~= "waiting" and self.state ~= "shopping" and self.state ~= "ending" then
      -- self.level:checkLevel()
    -- end

    if self.camera.move then
      if self.state ~= "pre_fight_3" then
        self.camera:setToTarget(true, self.player.x, self.player.y + self.player.z, self.contentGroup, {self.parallaxBackgroundGroup, self.mainGroup, self.bgGroup, self.foregroundGroup}, {0.2, 1,1,1})
      else
        self.camera:setToTarget(true, self.player.x + 50, self.player.y + self.player.z, self.contentGroup, {self.parallaxBackgroundGroup, self.mainGroup, self.bgGroup, self.foregroundGroup}, {0.2, 1,1,1})
      end
    end

    self.effects.fighters = fighters
    self.effects:update()

    -- sort draw order for fighters
    -- todo: fix everything else in this list, effects, etc
    local display_objects = {}
    for i = 1, #self.fighters do
      table.insert(display_objects, self.fighters[i])
    end
    for i = 1, #self.effects.effect_list do
      item = self.effects.effect_list[i]
      if item.type == "projectile" then
        table.insert(display_objects, item.sprite)
      end
    end
    table.sort(display_objects,  
      function(a, b)
        return a.z < b.z
      end
    )
    for i = 1, #display_objects do
      self.mainGroup:insert(display_objects[i])
    end

    -- update health bars
    for i = 1, #self.fighters do
      if self.fighters[i].healthbar ~= nil then
        if (self.fighters[i].health < self.fighters[i].visible_health - 5) then
          self.fighters[i].visible_health = 0.2 * self.fighters[i].health + 0.8 * self.fighters[i].visible_health
          self.fighters[i].healthbar:setHealth(self.fighters[i].visible_health / self.fighters[i].max_health * 100)
        elseif (self.fighters[i].health < self.fighters[i].visible_health) then
          self.fighters[i].visible_health = self.fighters[i].visible_health - 1
          self.fighters[i].healthbar:setHealth(self.fighters[i].visible_health / self.fighters[i].max_health * 100)
        end
      end
    end

    if self.mobile_controls == true then
      self:checkMobileButtonUI()
    end

    if self.show_hitboxes == true then
      self:showHitBoxes()
    end

    self:resetInput()
  end

  function scene:player_blue_button(event)
    if self.state == "active" then
      self.player:kickingAction()
    end
    return true
  end

  function scene:player_green_button(event)
    if self.state == "active" then
      self.player:punchingAction()
    end
    return true
  end

  function scene:player_s_button(event)
    if event.phase == "began" and self.state == "active" then
      self.player:specialAction()
    end
    return true
  end

  function scene:player_red_button(event)
    if self.state == "active" then
      if (event.phase == "began") and self.player.action == "resting" then
        self.player:blockingAction()
      elseif (event.phase == "ended" or event.phase == "cancelled") then
        if self.player.action == "blocking" then
          self.player:restingAction()
        end
      end
    end

    return true  -- Prevents touch propagation to underlying objects
  end

  function scene:properKeyboard(event)
    if self.state ~= "active" and self.state ~= "shopping" then
      return
    end

    if event.keyName == "left" then
      if event.phase == "down" then
        self.keydown.left = true
      elseif event.phase == "up" then
        self.keydown.left = false
        self.keyup.left = true
      end
    end

    if event.keyName == "right" then
      if event.phase == "down" then
        self.keydown.right = true
      elseif event.phase == "up" then
        self.keydown.right = false
        self.keyup.right = true
      end
    end

    if event.keyName == "up" then
      if event.phase == "down" then
        self.keydown.up = true
      elseif event.phase == "up" then
        self.keydown.up = false
        self.keyup.up = true
      end
    end

    if event.keyName == "down" then
      if event.phase == "down" then
        self.keydown.down = true
      elseif event.phase == "up" then
        self.keydown.down = false
        self.keyup.down = true
      end
    end

    if event.keyName == "a" then
      if event.phase == "down" then
        self.keydown.a = true
      elseif event.phase == "up" then
        self.keydown.a = false
      end
    end

    if event.keyName == "s" then
      if event.phase == "down" then
        self.keydown.s = true
      elseif event.phase == "up" then
        self.keydown.s = false
      end
    end

    if event.keyName == "d" then
      if event.phase == "down" then
        self.keydown.d = true
      elseif event.phase == "up" then
        self.keydown.d = false
      end
    end

    if event.keyName == "enter" then
      if event.phase == "down" then
        self.keydown.enter = true
      elseif event.phase == "up" then
        self.keydown.enter = false
      end
    end

    if event.keyName == "escape" and event.phase == "up" then
      pause()
    end

    if self.gamepad == true and self.device ~= nil then
      if event.keyName == "button1" or event.keyName == "buttonA" then
        if event.phase == "down" then
          self.keydown.s = true
        elseif event.phase == "up" then
          self.keydown.s = false
        end
      end

      if event.keyName == "button2" or event.keyName == "buttonB" then
        if event.phase == "down" then
          self.keydown.d = true
        elseif event.phase == "up" then
          self.keydown.d = false
        end
      end

      if event.keyName == "button3" or event.keyName == "buttonX" then
        if event.phase == "down" then
          self.keydown.a = true
        elseif event.phase == "up" then
          self.keydown.a = false
        end
      end

      if event.keyName == "buttonStart" then
        if event.phase == "up" then
          pause()
        end
      end
    end

    -- if event.keyName == "x" and event.phase == "up" then
    --   if self.show_hitboxes == true then
    --     self.show_hitboxes = false
    --     self.hitBoxGroup.isVisible = false
    --   else
    --     self.show_hitboxes = true
    --     self.hitBoxGroup.isVisible = true
    --   end
    -- end

    return true
  end

  function scene:debugKeyboard(event)
    if self.state ~= "active" then
      return
    end

    if event.keyName == "h" then
      if self.player.action == "resting" then
        self.player:blockingAction()
      end
    end
    if event.keyName == "j" then
      self:player_green_button(event)
    end
    if event.keyName == "k" then
      self:player_blue_button(event)
    end

    if event.keyName == "p" then
      composer.setVariable("player_wins", 1)
      self.player.target.health = 0
    end


    if event.keyName == "x" and event.phase == "up" then
      if self.show_hitboxes == true then
        self.show_hitboxes = false
        self.hitBoxGroup.isVisible = false
      else
        self.show_hitboxes = true
        self.hitBoxGroup.isVisible = true
      end
    end

    return true
  end

  -- self.swipe_event = {}
  -- function self:swipe(event)

  --   if self.state ~= "active" then
  --     return
  --   end

  --   if (event.phase == "began") then
  --     -- Set touch focus on the fighter
  --     -- display.currentStage:setFocus( fighter )
      
  --     -- Store initial offset position
  --     self.swipe_event.initialX = event.x
  --     self.swipe_event.initialY = event.y
  --   elseif (event.phase == "moved") then
  --     -- nothing
  --   elseif (event.phase == "ended" or event.phase == "cancelled") then
  --     -- -- if the block touch ended outside the blocking event, it still needs to be canceled
  --     -- if player.action == "blocking" then
  --     --   player:restingAction()
  --     -- end

  --     if (self.swipe_event.initialX == nil) then
  --       self.swipe_event.initialX = event.x
  --     end
  --     if (self.swipe_event.initialY == nil) then
  --       self.swipe_event.initialY = event.y
  --     end
  --     local touchOffsetX = (event.x - self.swipe_event.initialX) / 5
  --     local touchOffsetY = (event.y - self.swipe_event.initialY) / 1.5

  --     self.player:moveAction(touchOffsetX, touchOffsetY)

  --     -- Release touch focus on the fighter
  --     -- display.currentStage:setFocus( nil )
  --   end

  --   return true  -- Prevents touch propagation to underlying objects
  -- end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  -- local candidate = composer.getVariable("candidate")
  -- local opponent = composer.getVariable("opponent")
  -- local location = composer.getVariable("location")

  self:initializeAllKindsOfStuff()

  scene_group = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  self.contentGroup = display.newGroup()
  scene_group:insert(self.contentGroup)

  self.contentGroup.xScale = self.game_scale
  self.contentGroup.yScale = self.game_scale

  -- skyGroup = display.newGroup()
  -- contentGroup:insert(skyGroup)

  self.parallaxBackgroundGroup = display.newGroup()
  self.contentGroup:insert(self.parallaxBackgroundGroup)

  self.bgGroup = display.newGroup()
  self.contentGroup:insert(self.bgGroup)
  -- self.bgGroup.anchorY = 0

  self.mainGroup = display.newGroup()
  self.contentGroup:insert(self.mainGroup)

  self.foregroundGroup = display.newGroup()
  self.contentGroup:insert(self.foregroundGroup)

  self.hitBoxGroup = display.newGroup()
  scene_group:insert(self.hitBoxGroup)

  self.shoppingGroup = display.newGroup()
  scene_group:insert(self.shoppingGroup)
  self.shoppingGroup.isVisible = false

  self.uiGroup = display.newGroup()
  scene_group:insert(self.uiGroup)

  self.speedlineGroup = display.newGroup()
  scene_group:insert(self.speedlineGroup)

  self.supertextGroup = display.newGroup()
  scene_group:insert(self.supertextGroup)

  game_scene = composer.getVariable("game_scene")
  level_template = require("Source.Levels." .. game_scene)
  self.level = level_template:create(self)
  self.level:buildLevel()

  temporary_shop = display.newImageRect(self.shoppingGroup, "Art/temporary_shop.png", 568, 320)
  temporary_shop.x = display.contentCenterX
  temporary_shop.y = display.contentCenterY

  self.temporary_shop_selector = display.newImageRect(self.shoppingGroup, "Art/temporary_shop_selector.png", 568, 320)
  self.temporary_shop_selector.x = display.contentCenterX
  self.temporary_shop_selector.y = display.contentCenterY

  self.effects = effects_system:create(scene_group, self.foregroundGroup)
  self.effects.fighters = self.fighters

  self.player = self.candidates["sanders"]:create(self.level.player_starting_x, candidate.default_ground_target, self.mainGroup, self.min_x, self.max_x, self.min_z, self.max_z, self.effects)
  self.player.healthbar = healthBar:create(60, 10, 0.8, self.uiGroup)
  self.player.shake_screen_on_contact = true
  self.player.fighters = self.fighters
  self.player.flexible_target = true
  self.player.side = "good"
  self.fighters[1] = self.player
  self.player.can_blink = false

  self.level.player = self.player

  self.other_fighters = {}

  player_headshot = display.newImageRect(self.uiGroup, "Art/sanders_face.png", 50, 50)
  player_headshot.x = 27
  player_headshot.y = 27
  player_headshot.xScale = -1

  if self.mobile_controls == true then
    self.right_panel = display.newImageRect(self.uiGroup, "Art/right_panel.png", 116, 58)
    self.right_panel.x = display.contentWidth - 58
    self.right_panel.y = display.contentHeight - 29

    self.green_button = display.newImageRect(self.uiGroup, "Art/green_button.png", 54, 54)
    self.green_button.x = display.contentWidth - 86
    self.green_button.y = display.contentHeight - 28

    self.blue_button = display.newImageRect(self.uiGroup, "Art/blue_button.png", 54, 54)
    self.blue_button.x = display.contentWidth - 30
    self.blue_button.y = display.contentHeight - 28

    self.red_button = display.newImageRect(self.uiGroup, "Art/red_button.png", 54, 54)
    self.red_button.x = 32
    self.red_button.y = display.contentHeight - 32

    self.pause_button = display.newImageRect(self.uiGroup, "Art/pause_button.png", 48, 48)
    self.pause_button.x = display.contentCenterX
    self.pause_button.y = 24

    self.blue_button:addEventListener("touch", function(event) self:player_blue_button(event) end)
    self.green_button:addEventListener("touch", function(event) self:player_green_button(event) end)
    self.red_button:addEventListener("touch", function(event) self:player_red_button(event) end)
    self.pause_button:addEventListener("tap", pause)
    Runtime:addEventListener("touch", function(event) self:swipe(event) end)

    Runtime:addEventListener("key", function() self:debugKeyboard() end)
  else
    Runtime:addEventListener("key", function(event) self:properKeyboard(event) end)
  end

  local inputDevices = system.getInputDevices()
 
  for i = 1,#inputDevices do
      local device = inputDevices[i]
      print( device.descriptor )
  end

  self:gamepadCheck()
  Runtime:addEventListener("inputDeviceStatus", function(event) self:gamepadChanged(event) end)

  

  self.camera:setToTarget(false, self.player.x, self.player.y + self.player.z, self.contentGroup, {self.parallaxBackgroundGroup, self.mainGroup, self.bgGroup, self.foregroundGroup}, {0.2, 1, 1, 1})

  -- self:debugGrid()

  self.state = "waiting"
end


-- show()
function scene:show( event )

  local scene_group = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    self.gameLoopTimer = timer.performWithDelay(33, function() self:gameLoop() end, 0)
    self.level:prepareToActivate()
    if paused then
      paused = false
      for i = 1, #self.fighters do
        self.fighters[i]:enable()
        if self.fighters[i] ~= self.player then
          self.fighters[i]:enableAutomatic()
        end
      end
    end

  elseif ( phase == "did" ) then
    composer.removeScene("Source.Scenes.prefight")
    composer.removeScene("Source.Scenes.pause")
    -- Code here runs when the scene is entirely on screen

  end
end


-- hide()
function scene:hide( event )

  local scene_group = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen
    timer.cancel(self.gameLoopTimer)
    for i = 1, #self.fighters do
      self.fighters[i]:disable()
    end
  end
end


-- destroy()
function scene:destroy( event )

  local scene_group = self.view
  -- Code here runs prior to the removal of scene's view
  if self.gameLoopTimer ~= nil then
    timer.cancel(self.gameLoopTimer)
  end
  for i = 1, #self.fighters do
    self.fighters[i]:disable()
  end
  audio.dispose(self.level.stage_music)
end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
