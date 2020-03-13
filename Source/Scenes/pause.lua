
local composer = require("composer")

local scene = composer.newScene()

local function gotoGame()
  audio.resume(2)
  audio.resume(3)
  composer.gotoScene("Source.Scenes.game")
end

local pause_text

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

function scene:keyboard(event)
  if (event.keyName == "escape" or event.keyName == "enter" or event.keyName == "buttonStart") and event.phase == "up" then
    gotoGame()
  end
end

-- create()
function scene:create(event)

  local scene_group = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  soft_tan_background = display.newImageRect(scene_group, "Art/soft_tan_background.png", display.contentWidth, display.contentHeight)
  soft_tan_background.x = display.contentCenterX
  soft_tan_background.y = display.contentCenterY

  sanders = require("Source.Candidates.Sanders")
  effects_system = require("Source.Utilities.effects")

  self.characters = {}
  self.fighters = {}

  self.scale = 0.2
  self.y_margin = -15
  self.x_margin = 20

  self.effects = effects_system:create(scene_group, scene_group)
  self.effects.fighters = self.fighters

  self.buttons = {}
  self.buttons["1,1"] = {"left", "or", "right"}
  self.buttons["1,2"] = {"up", "or", "down"}
  self.buttons["1,3"] = {"up", "and", "right"}
  self.buttons["1,4"] = {"left", "and", "up"}
  self.buttons["2,1"] = {"a"}
  self.buttons["2,2"] = {"s"}
  self.buttons["2,3"] = {"d"}
  self.buttons["2,4"] = {"a", "plus", "a", "plus", "right"}
  self.buttons["2,5"] = {"a", "plus", "d", "plus", "up"}

  self.gamepad = false
  local inputDevices = system.getInputDevices()
 
  for i = 1,#inputDevices do
    local device = inputDevices[i]
    if string.find(string.lower(device.descriptor), "gamepad") or string.find(string.lower(device.descriptor), "controller") then
      self.gamepad = true
    end
  end

  for i = 1,2 do
    for j = 1,3+i do
      local x = display.contentWidth / 4 + (i-1) * display.contentWidth / 2 + self.x_margin
      local y = display.contentHeight / (6+2*i) + (j - 1) * display.contentHeight / (3+i) + self.y_margin
      local character_group = display.newGroup()
      scene_group:insert(character_group)

      character_group.x = x
      character_group.y = y
      character_group.xScale = self.scale
      character_group.yScale = self.scale

      local mini_player = sanders:create(0, 0, character_group, -500, 500, -100, 100, self.effects)
      mini_player.fighters = self.fighters
      mini_player.ground_target = mini_player.y_offset
      mini_player:enable()
      mini_player:restingAction()
      mini_player.silent = true
      mini_player.bros = 100

      self.characters[i .. "," .. j] = mini_player

      local info_group = display.newGroup()
      scene_group:insert(info_group)

      info_group.x = x
      info_group.y = y
      info_group.xScale = 0.6
      info_group.yScale = 0.6
      local buttons = self.buttons[i .. "," .. j]
      for m = 1,#buttons do
        if self.gamepad then
          if buttons[m] == "a" or buttons[m] == "s" or buttons[m] == "d" then
            local button = display.newImageRect(info_group, "Art/TutorialUI/button.png", 96, 96)
            button.x = -40 * #buttons + 40 * m - 80 + 1
            button.y = 10 + 2
          end
        end
        local glyph = display.newImageRect(info_group, "Art/TutorialUI/" .. buttons[m] .. ".png", 40, 40)
        glyph.x = -40 * #buttons + 40 * m - 80
        glyph.y = 10
      end
    end
  end

  self.characters["1,1"]:enableTutorial(function() self.characters["1,1"]:moveAction(self.characters["1,1"].max_x_velocity * 0.7, 0) end)
  self.characters["1,2"]:enableTutorial(function() self.characters["1,2"]:zMoveAction(self.characters["1,2"].max_z_velocity * 0.7) end)
  self.characters["1,3"]:enableTutorial(function()
    self.characters["1,3"]:moveAction(self.characters["1,3"].max_x_velocity * 0.7, -1 * self.characters["1,3"].max_y_velocity)
    dice = math.random(1,100)
    if dice > 50 then
      timer.performWithDelay(400, function() self.characters["1,3"]:kickingAction() end)
    end
  end)
  self.characters["1,4"]:enableTutorial(function()
    self.characters["1,4"]:moveAction(-1 * self.characters["1,4"].max_x_velocity * 0.7, -1 * self.characters["1,4"].max_y_velocity)
    dice = math.random(1,100)
    if dice > 50 then
      timer.performWithDelay(400, function() self.characters["1,3"]:kickingAction() end)
    end
  end)

  self.characters["2,1"]:enableTutorial(function() self.characters["2,1"]:blockingAction() end)
  self.characters["2,2"]:enableTutorial(function() self.characters["2,2"]:punchingAction() end)
  self.characters["2,3"]:enableTutorial(function() self.characters["2,3"]:kickingAction() end)
  self.characters["2,4"]:enableTutorial(function()
    dice = math.random(1,100)
    if dice > 60 then
      self.characters["2,4"]:specialThrow()
    end
  end)
  self.characters["2,5"]:enableTutorial(function()
    dice = math.random(1,100)
    if dice > 60 then
      self.characters["2,5"]:specialAction()
    end
  end)

  pause_text = display.newText(scene_group, "Paused", display.contentCenterX, display.contentCenterY, "Georgia-Bold", 30)
  pause_text.y = display.contentCenterY - 70
  pause_text:setTextColor(1, 1, 1)

  self.gameLoopTimer = timer.performWithDelay(33, function()
    self.effects:update() 
    new_fighters = {}
    for i = 1, #self.effects.fighters do
      if self.effects.fighters[i].y < 300 then
        table.insert(new_fighters, self.effects.fighters[i])
      else
        self.effects.fighters[i]:disableAutomatic()
        self.effects.fighters[i]:disable()
        -- display.remove(self.effects.fighters[i])

      end
    end
    self.effects.fighters = new_fighters
    for i = 1, #self.effects.fighters do
      self.effects.fighters[i].fighters = self.effects.fighters
    end
  end, 0)
  -- Runtime:addEventListener("tap", gotoGame)
  Runtime:addEventListener("key", function(event) self:keyboard(event) end)
end

-- show()
function scene:show(event)

  local scene_group = self.view
  local phase = event.phase

  if (phase == "will") then
    -- Code here runs when the scene is still off screen (but is about to come on screen)

  elseif (phase == "did") then
    -- Code here runs when the scene is entirely on screen
  end
end


-- hide()
function scene:hide(event)

  local scene_group = self.view
  local phase = event.phase

  if (phase == "will") then
    -- Code here runs when the scene is on screen (but is about to go off screen)
    timer.cancel(self.gameLoopTimer)
    self.characters["1,1"]:disable()
    self.characters["1,2"]:disable()
    self.characters["1,3"]:disable()
    self.characters["1,4"]:disable()
    self.characters["2,1"]:disable()
    self.characters["2,2"]:disable()
    self.characters["2,3"]:disable()
    self.characters["2,4"]:disable()
    self.characters["2,5"]:disable()
    for i = 1, #self.effects.fighters do
      self.effects.fighters[i]:disable()
    end

  elseif (phase == "did") then
    -- Code here runs immediately after the scene goes entirely off screen
  end
end


-- destroy()
function scene:destroy(event)

  local scene_group = self.view
  -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
