
local composer = require("composer")

local scene = composer.newScene()

local function gotoPostfight()
  composer.gotoScene("Source.Scenes.postfight", {effect = "fade", time = 1000})
end

local function gotoGameover()
  composer.gotoScene("Source.Scenes.gameover", {effect = "fade", time = 1000})
end

local ButtigiegSpriteInfo = require("Source.Sprites.buttigiegSprite")
local ButtigiegSheet = graphics.newImageSheet("Art/buttigieg.png", ButtigiegSpriteInfo:getSheet())

local TrumpSpriteInfo = require("Source.Sprites.trumpSprite")
local TrumpSheet = graphics.newImageSheet("Art/trump.png", TrumpSpriteInfo:getSheet())

local WarrenSpriteInfo = require("Source.Sprites.warrenSprite")
local WarrenSheet = graphics.newImageSheet("Art/warren_sprite.png", WarrenSpriteInfo:getSheet())

local WhipSpriteInfo = require("Source.Sprites.whipSprite")
local WhipSheet = graphics.newImageSheet("Art/whip_sprite.png", WhipSpriteInfo:getSheet())


local HealthBar = require("Source.Utilities.healthBar")

local fighters = {}

local after_images = {}

local state

local button_s
local button_1
local button_2

local camera = {x = 0, y = 0}

local parallax_background
local background_1
local background_2
local foreground

local sceneGroup
local bgGroup
local mainGroup
local uiGroup

local gravity = 4
local max_x_velocity = 20
local max_y_velocity = 35

local punch_sound
local china_sound
-- local stage_music

local punch_timer = 0

local physics = require( "physics" )
physics.start()

local animation_timers = {}

-- local tilt = {}
-- function tilt:gyro(event)
--     fighters[1].x = fighters[1].x + event.xRotation * event.deltaTime
-- end

-- local function player_punch(event)
--   if punch_timer <= 0 then
--     punch_timer = 4
--     fighters[1].sprite:setFrame(fighters[1].frameIndex["punch"])
--     audio.play(punch_sound)

--     if (math.abs(fighters[1].x - fighters[2].x) < 115) then
--       fighters[2].sprite:setFrame(2)
--       fighters[2].x_vel = 10
--       fighters[2].y_vel = -5
--       fighters[2].rotation = 15
--     end
--   end
-- end

-- function definitions
local suspendActions

local function punch(actor, victim)
  if actor.punch_timer <= 0 and actor.damage_timer <= 0 then
    if actor == fighters[2] then
      actor.punch_timer = 4
    end

    -- actor.sprite:setFrame(actor.frameIndex["punch"])
    -- audio.play(punch_sound)
    
    if (actor.xScale == 1) then
      if (actor.x -10 < victim.x and actor.x + 105 > victim.x) then
        fighters[1].after_image.isVisible = false
        audio.play(punch_sound)
        actor.damage_in_a_row = 0
        victim.sprite:setFrame(victim.frameIndex["damage"])
        victim.x_vel = 10
        victim.y_vel = -5
        victim.rotation = 15
        victim.damage_timer = 4
        victim.health = victim.health - actor.power
        victim.damage_in_a_row = victim.damage_in_a_row + 1
        victim.action = "damaged"
        if victim == fighters[1] and victim.damage_in_a_row > 3 then
          victim.action = "ko"
          victim.damage_timer = 55
          victim.y_vel = -20
          victim.x_vel = 20
          suspendActions()
        end
      end
    elseif (actor.xScale == -1) then
      if (actor.x + 10 > victim.x and actor.x - 105 < victim.x) then
        fighters[1].after_image.isVisible = false
        audio.play(punch_sound)
        actor.damage_in_a_row = 0
        victim.sprite:setFrame(victim.frameIndex["damage"])
        victim.x_vel = -10
        victim.y_vel = -5
        victim.rotation = -15
        victim.damage_timer = 4
        victim.health = victim.health - actor.power
        victim.damage_in_a_row = victim.damage_in_a_row + 1
        victim.action = "damaged"
        if victim == fighters[1] and victim.damage_in_a_row > 3 then
          victim.action = "ko"
          victim.damage_timer = 55
          victim.y_vel = -20
          victim.x_vel = -20
          suspendActions()
        end
      end
    end
  end
end

local function player_punch(event)
  punch(fighters[1], fighters[2])
end

suspendActions = function()
  button_s.alpha = 0.5
  button_1.alpha = 0.5
  if fighters[1].action ~= "jumping" then
    button_2.alpha = 0.5
  end
end

local function restoreActions()
  animationFrame = 1
  fighters[1].after_image.isVisible = false
  animation_timers["player"]._delay = 50
  button_s.alpha = 1.0
  button_1.alpha = 1.0
  button_2.alpha = 1.0
  fighters[1].action = nil
end

local function swipe(event)
  -- local fighter = event.target
  local fighter = fighters[1]
  local phase = event.phase

  if fighters[1].action == "dizzy" or fighters[1].action == "damaged" or fighters[1].action == "ko" then
    return
  end

  if ( "began" == phase ) then
      -- Set touch focus on the fighter
      display.currentStage:setFocus( fighter )
      -- Store initial offset position
      fighter.initialX = event.x
      fighter.initialY = event.y

  elseif ( "moved" == phase ) then
      -- Track the touch position
      -- fighter.touchOffsetX = event.x - fighter.touchOffsetX
      -- fighter.touchOffsetY = event.y - fighter.touchOffsetY

  elseif ( "ended" == phase or "cancelled" == phase ) then
      if (fighter.initialX == nil) then
        fighter.initialX = event.x
      end
      if (fighter.initialY == nil) then
        fighter.initialY = event.y
      end
      fighter.touchOffsetX = (event.x - fighter.initialX) / 5
      fighter.touchOffsetY = (event.y - fighter.initialY) / 1.5

      -- Set the fighter velocity in the direction of the touch
      fighter.x_vel = math.max(-1 * max_x_velocity, math.min(max_x_velocity, fighter.touchOffsetX))
      fighter.y_vel = -1 * math.max(0, math.min(max_y_velocity, -1 * fighter.touchOffsetY))
      
      -- disable actions
      if math.abs(fighter.y_vel) > max_y_velocity / 2 then
        fighter.action = "jumping"
        -- print(fighter.y_vel)
        if fighter == fighters[1] then
          suspendActions()
        end
        -- calculate time to impact, and assess whether this is a flipping jump
        fighters[1].time_to_impact = -2 * fighter.y_vel / gravity 
        -- print(fighters[1].time_to_impact * (33.0/1000)) -- print with framerate
        if math.abs(fighter.y_vel) > max_y_velocity / 1.2 then
          local alternator = 1
          if fighters[1].x_vel < 0 or (fighters[1].xScale == -1 and fighters[1].x_vel < 0) then
            alternator = -1
          end
          fighters[1].rotation_vel = 360.0 / fighters[1].time_to_impact * alternator
        end
      end
      


      -- if fighter.y_vel == -1 * max_y_velocity then
      --   audio.play(china_sound)
      -- end

      -- Release touch focus on the fighter
      display.currentStage:setFocus( nil )
  end

  return true  -- Prevents touch propagation to underlying objects
end

local function gameLoop()
  -- print(animation_timers["player"]._delay)
  if state == "active" then
    fighters[1].x = fighters[1].x + fighters[1].x_vel
    fighters[1].y = fighters[1].y + fighters[1].y_vel

    fighters[2].x = fighters[2].x + fighters[2].x_vel
    fighters[2].y = fighters[2].y + fighters[2].y_vel

    fighters[1].x_vel = fighters[1].x_vel * 0.8
    fighters[2].x_vel = fighters[2].x_vel * 0.8

    local ground_target = display.contentCenterY + fighters[1].y_offset
    if fighters[1].action == "ko" then
      ground_target = ground_target + 60
    end
    if (fighters[1].y < ground_target) then
      fighters[1].y_vel = fighters[1].y_vel + gravity
    else
      if fighters[1].action ~= "ko" then
        fighters[1].y = ground_target
        fighters[1].y_vel = 0
        if fighters[1].action ~= "dizzy" then
          fighters[1].rotation_vel = 0
          fighters[1].rotation = 0
        end
        if fighters[1].action == "jumping" or fighters[1].action == "jump_kicking" then
          restoreActions()
        end
      else
        fighters[1].y = ground_target
        fighters[1].y_vel = 0
        fighters[1].rotation = 0
        fighters[1].sprite:setFrame(23)
      end
    end



    if (fighters[2].y < display.contentCenterY + fighters[2].y_offset) then
      fighters[2].y_vel = fighters[2].y_vel + gravity
    else
      fighters[2].y = display.contentCenterY + fighters[2].y_offset
      fighters[2].y_vel = 0
    end

    if (fighters[1].action == "jumping" or fighters[1].action == "jump_kicking") and math.abs(fighters[1].rotation_vel) > 0 then
      fighters[1].rotation = fighters[1].rotation + fighters[1].rotation_vel
    end

    if fighters[1].x > fighters[2].x + 10 and fighters[1].xScale == 1 and fighters[1].action == nil then
      fighters[1].xScale = -1
      fighters[2].xScale = 1
    end

    if fighters[1].x < fighters[2].x - 10 and fighters[1].xScale == -1 and fighters[1].action == nil then
      fighters[1].xScale = 1
      fighters[2].xScale = -1
    end

    if fighters[1].health <= 0 or fighters[2].health <= 0 then
      state = "ending"
      timer.cancel(trumpActionsTimer)
      if (fighters[1].health > 0) then
        timer.performWithDelay(1000, gotoPostfight)
      else
        timer.performWithDelay(1000, gotoGameover)
      end
      -- button_s:removeEventListener("tap", player_s_button)
      -- button_1:removeEventListener("tap", player_1_button)
      -- button_2:removeEventListener("tap", player_2_button)
      Runtime:removeEventListener("touch", swipe)
      Runtime:removeEventListener("key", debugKeyboard)
    end
  end

  -- always do these things
  move_camera = true
  camera_speed = 0.4
  if move_camera then
    -- Calculate new camera position
    x = -1 * ((fighters[1].x + fighters[2].x) / 2.0 - display.contentCenterX)
    y = -1 * ((fighters[1].y - fighters[1].y_offset + fighters[2].y - fighters[2].y_offset) / 2.0 - display.contentCenterY)

    -- blend with old camera position
    camera.x = camera_speed * x + (1 - camera_speed) * camera.x
    camera.y = camera_speed * y + (1 - camera_speed) * camera.y

    -- assign to groups
    parallaxBackgroundGroup.x = 0.8 * display.contentCenterX + 0.2 * camera.x
    parallaxBackgroundGroup.y = camera.y
    mainGroup.x = camera.x
    mainGroup.y = camera.y
    bgGroup.x = camera.x
    bgGroup.y = camera.y
    foregroundGroup.x = camera.x
    foregroundGroup.y = camera.y
  end

  for i = 1,2,1 do
    if (fighters[i].punch_timer > 0) then
      fighters[i].punch_timer = fighters[i].punch_timer - 1
      if fighters[i].punch_timer <= 0 then
        fighters[i].sprite:setFrame(fighters[i].frameIndex["normal"])
        fighters[i].action = nil
      end
    end
    if (fighters[i].damage_timer > 0) then
      fighters[i].damage_timer = fighters[i].damage_timer - 1  
      if fighters[i].damage_timer <= 0 then
        if fighters[i].damage_in_a_row < 4 then
          fighters[i].sprite:setFrame(fighters[i].frameIndex["normal"])
          fighters[i].rotation = 0
          fighters[i].action = nil
          if i == 1 then
            restoreActions()
          end
        else
          fighters[i].action = "dizzy"
          fighters[i].damage_timer = 45
          fighters[i].damage_in_a_row = 0
          fighters[i].rotation_vel = -1 * math.random(50, 100) / 30 * fighters[i].xScale
          print(fighters[i].rotation_vel)
          if i == 1 then
            suspendActions()
          end
        end
      end
    end

    if (fighters[i].health < fighters[i].visibleHealth) then
      fighters[i].visibleHealth = fighters[i].visibleHealth - 1
      fighters[i].healthbar:setHealth(fighters[i].visibleHealth)
    end
  end
end

local function trumpActions()
  -- do return end
  if fighters[2].action == "whipped" then
    return
  end
  if fighters[1].action ~= "dizzy" and fighters[1].action ~= "ko" then
    if math.abs(fighters[2].x - fighters[1].x) > 80 then
      if math.random(1, 100) > 20 then
        fighters[2].x_vel = 10 * fighters[2].xScale
      else
        fighters[2].sprite:setFrame(fighters[2].frameIndex["punch"])
        punch(fighters[2], fighters[1])
      end
    else
      if math.random(1, 100) > 80 then
        fighters[2].x_vel = 10 * fighters[2].xScale
      else
        fighters[2].sprite:setFrame(fighters[2].frameIndex["punch"])
        punch(fighters[2], fighters[1])
      end
    end
  else
    local dice = math.random(1, 100)
    if dice > 85 then
      fighters[2].x_vel = 10 * fighters[2].xScale
    elseif dice > 50 then
      fighters[2].x_vel = -10 * fighters[2].xScale
    end
  end
end

local animationFrame = 1
local resting_frames = {
  5, 5, 5,
  6, 6, 6,
  5, 5, 5,
  1, 1, 1,
  5, 5, 5,
  6, 6, 6,
  5, 5,
  1, 1,
  2, 2,
  3, 3,
  4, 4
}
local kicking_frames = {
  7, 7,
  8, 8,
  9, 9,
  10, 10,
  11, 11,
  12, 12,
  9, 9,
}
local punching_frames = {
  13, 13,
  14, 14,
  15, 15,
  14, 14,
  15, 15,
  16, 16,
  17, 17, 17, 17,
  16, 16,
}
local whipping_frames = {
  3, 3,
  16, 16,
  17, 17, 17, 17, 17, 17, 17, 17,
  18, 18, 18,
}
local actual_whip_frames = {
  1, 1,
  2, 2,
  3, 3, 4, 4, 4, 4, 4, 4,
  5, 5, 5,
}
local function testAnimation()
  if fighters[1].action == nil then
    fighters[1].sprite:setFrame(resting_frames[animationFrame])
    animationFrame = animationFrame + 1
    if (animationFrame > #resting_frames) then
      animationFrame = 1
    end
  elseif fighters[1].action == "kicking" then
    fighters[1].sprite:setFrame(kicking_frames[animationFrame])
    if (animationFrame >= 7) then
      fighters[1].after_image.isVisible = true
      -- after_images[1].x = fighters[1].x
      -- after_images[1].y = fighters[1].y
      fighters[1].after_image:setFrame(kicking_frames[animationFrame - 1])
    end
    if animationFrame == 9 or animationFrame == 11 then
    -- if animationFrame == 11 or animationFrame == 13 or animationFrame == 15 then
      if fighters[1].xScale == 1 then
        fighters[1].x = fighters[1].x + 20
      else
        fighters[1].x = fighters[1].x - 20
      end
    end
    if animationFrame == 13 then
    -- if animationFrame == 11 or animationFrame == 13 or animationFrame == 15 then
      if fighters[1].xScale == 1 then
        fighters[1].x = fighters[1].x + 40
      else
        fighters[1].x = fighters[1].x - 40
      end
    end
    if animationFrame == 3 or animationFrame == 9 then
      punch(fighters[1], fighters[2])
    end
    animationFrame = animationFrame + 1
    if (animationFrame > #kicking_frames) then
      restoreActions()
    end
  elseif fighters[1].action == "punching" then
    fighters[1].sprite:setFrame(punching_frames[animationFrame])
    animationFrame = animationFrame + 1
    if (animationFrame > #punching_frames) then
      restoreActions()
    end
    if animationFrame == 3 or animationFrame == 7 or animationFrame == 13 then
      punch(fighters[1], fighters[2])
    end
  elseif fighters[1].action == "whipping" then
    fighters[1].sprite:setFrame(whipping_frames[animationFrame])
    fighters[1].whip_image:setFrame(actual_whip_frames[animationFrame])
    animationFrame = animationFrame + 1
    if (animationFrame > #whipping_frames) then
      fighters[1].whip_image.isVisible = false
      restoreActions()
    end
    if (animationFrame == 6) then
      if math.abs(fighters[1].x - fighters[2].x) < 200 then
        punch(fighters[1], fighters[2])
        fighters[2].action = "whipped"
        fighters[2].sprite:setFrame(fighters[2].frameIndex["damage"])
        fighters[2].damage_timer = 50
      end
      audio.play(punch_sound)
    end
  elseif fighters[1].action == "jumping" then
    if display.contentCenterY + fighters[1].y_offset - fighters[1].y > 60 then
      fighters[1].sprite:setFrame(20) -- flip
    elseif fighters[1].y_vel < 0 then
      fighters[1].sprite:setFrame(19) -- go up
    elseif fighters[1].y_vel > 0 then
      fighters[1].sprite:setFrame(21) -- go down
    end
  elseif fighters[1].action == "jump_kicking" then
    if display.contentCenterY + fighters[1].y_offset - fighters[1].y > 60 or fighters[1].y_vel < 0 then
      fighters[1].sprite:setFrame(11) -- kick
    else
      fighters[1].sprite:setFrame(20) -- go down
    end
  elseif fighters[1].action == "dizzy" then
    fighters[1].sprite:setFrame(24)
    -- if fighters[1].damage_timer % 2 == 0 then
    -- fighters[1].rotation = math.random(1, 20) - 10
    -- fighters[1].xScale = fighters[1].xScale * -1
    -- end
    if fighters[1].damage_timer % 9 == 0 then
      fighters[1].xScale = fighters[1].xScale * -1
    end
  elseif fighters[1].action == "ko" then
    if fighters[1].xScale == 1 and fighters[1].rotation > -90 and fighters[1].y_vel ~= 0 then
      fighters[1].rotation = fighters[1].rotation - 7
    elseif fighters[1].xScale == -1 and fighters[1].rotation < 90 and fighters[1].y_vel ~= 0 then
      fighters[1].rotation = fighters[1].rotation + 7
    end
  end
end

-- sweep test
local function player_2_button(event)
  if fighters[1].action == nil then
    animationFrame = 1
    -- timer.cancel(animation_timers["player"])
    animation_timers["player"]._delay = 40
    fighters[1].action = "kicking"
    suspendActions()
  end

  if fighters[1].action == "jumping" then
    fighters[1].action = "jump_kicking"
    suspendActions()
  end
end

local function player_1_button(event)
  if fighters[1].action == nil then
    animationFrame = 1
    animation_timers["player"]._delay = 40
    suspendActions()
    fighters[1].action = "punching"
  end
end

local function player_s_button(event)
  if fighters[1].action == nil then
    animationFrame = 1
    animation_timers["player"]._delay = 40
    suspendActions()
    fighters[1].action = "whipping"
    fighters[1].whip_image.isVisible = true
  end
end

local function debugKeyboard(event)
  if event.keyName == "j" then
    player_s_button(event)
  end
  if event.keyName == "k" then
    player_1_button(event)
  end
  if event.keyName == "l" then
    player_2_button(event)
  end
end

local function backgroundAnimation()
  if (background_1.isVisible == true) then
    background_1.isVisible = false
    background_2.isVisible = true
  else
    background_1.isVisible = true
    background_2.isVisible = false
  end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )
  sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

    -- Set up display groups

  parallaxBackgroundGroup = display.newGroup()
  sceneGroup:insert(parallaxBackgroundGroup)

  bgGroup = display.newGroup()
  sceneGroup:insert(bgGroup)

  mainGroup = display.newGroup()
  sceneGroup:insert(mainGroup)

  foregroundGroup = display.newGroup()
  sceneGroup:insert(foregroundGroup)

  uiGroup = display.newGroup()
  sceneGroup:insert(uiGroup)

  parallax_background = display.newImageRect(parallaxBackgroundGroup, "Art/snow_parallax_background_pixelated.png", 1704, 753)
  parallax_background.x = display.contentCenterX
  parallax_background.y = display.contentHeight + 60
  parallax_background.anchorY = 1

  background_1 = display.newImageRect(mainGroup, "Art/snow_bg_1_pixelated.png", 1704, 753)
  background_1.x = display.contentCenterX
  background_1.y = display.contentHeight + 60
  background_1.anchorY = 1

  background_2 = display.newImageRect(mainGroup, "Art/snow_bg_2_pixelated.png", 1704, 753)
  background_2.x = display.contentCenterX
  background_2.y = display.contentHeight + 60
  background_2.anchorY = 1
  background_2.isVisible = false

  -- local foreground = display.newImageRect(foregroundGroup, "Art/snow_foreground_pixelated.png", 1704, 753)
  -- foreground.x = display.contentCenterX
  -- foreground.y = display.contentHeight + 40
  -- foreground.anchorY = 1


  fighters[1] = display.newGroup()
  mainGroup:insert(fighters[1])
  fighters[1].sprite = display.newSprite(fighters[1], WarrenSheet, {frames={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24}})
  fighters[1].frameIndex = WarrenSpriteInfo.frameIndex
  fighters[1].x = 184
  fighters[1].y_offset = 60
  fighters[1].x_vel = 0
  fighters[1].y_vel = 0
  fighters[1].y = display.contentCenterY + fighters[1].y_offset
  fighters[1].punch_timer = 0
  fighters[1].damage_timer = 0
  fighters[1].health = 100
  fighters[1].visibleHealth = 100
  fighters[1].healthbar = HealthBar:create(10, 10, uiGroup)
  fighters[1].action = nil
  fighters[1].damage_in_a_row = 0
  fighters[1].power = 5

  fighters[2] = display.newGroup()
  mainGroup:insert(fighters[2])
  fighters[2].sprite = display.newSprite(fighters[2], TrumpSheet, {frames={1,2,3}})
  fighters[2].frameIndex = TrumpSpriteInfo.frameIndex
  fighters[2].x = 384
  fighters[2].y_offset = 65
  fighters[2].y = display.contentCenterY + fighters[2].y_offset
  fighters[2].xScale = -1
  fighters[2].x_vel = 0
  fighters[2].y_vel = 0
  fighters[2].punch_timer = 0
  fighters[2].damage_timer = 0
  fighters[2].health = 100
  fighters[2].visibleHealth = 100
  fighters[2].healthbar = HealthBar:create(display.contentWidth - 240 - 10, 10, uiGroup)
  fighters[2].damage_in_a_row = 0
  fighters[2].power = 15

  fighters[1].after_image = display.newSprite(fighters[1], WarrenSheet, {frames={1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24}})
  fighters[1].after_image.frameIndex = WarrenSpriteInfo.frameIndex
  -- fighters[1].after_image.x = 184
  -- fighters[1].after_image.y_offset = 60
  -- fighters[1].after_image.x_vel = 0
  -- fighters[1].after_image.y_vel = 0
  -- fighters[1].after_image.y = display.contentCenterY + fighters[1].after_image.y_offset
  fighters[1].after_image.alpha = 0.5
  fighters[1].after_image.isVisible = false

  fighters[1].whip_image = display.newSprite(fighters[1], WhipSheet, {frames={1,2,3,4,5}})
  fighters[1].whip_image.isVisible = false

  button_2 = display.newImageRect(uiGroup, "Art/button_2.png", 48, 48)
  button_2.x = display.contentWidth - 30
  button_2.y = display.contentHeight - 30

  button_1 = display.newImageRect(uiGroup, "Art/button_1.png", 48, 48)
  button_1.x = display.contentWidth - (30 + 50)
  button_1.y = display.contentHeight - 30

  button_s = display.newImageRect(uiGroup, "Art/button_s.png", 48, 48)
  button_s.x = display.contentWidth - (30 + 100)
  button_s.y = display.contentHeight - 30

  punch_sound = audio.loadSound("Sound/punch.wav")
  china_sound = audio.loadSound("Sound/china.wav")
  -- stage_music = audio.loadStream("Sound/test_music.mp3")

  -- fighters[1]:addEventListener("touch", swipe)
  button_2:addEventListener("tap", player_2_button)
  button_1:addEventListener("tap", player_1_button)
  button_s:addEventListener("tap", player_s_button)
  Runtime:addEventListener("touch", swipe)
  Runtime:addEventListener("key", debugKeyboard)

  state = "active"
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    gameLoopTimer = timer.performWithDelay( 33, gameLoop, 0 )
    trumpActionsTimer = timer.performWithDelay(600, trumpActions, 0)
    backgroundAnimationTimer = timer.performWithDelay(500, backgroundAnimation, 0)
    animation_timers["player"] = timer.performWithDelay(50, testAnimation, 0)
    -- audio.play( stage_music, { channel=1, loops=-1 } )

    -- audio.play(china_sound)

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen

  end
end


-- hide()
function scene:hide( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is on screen (but is about to go off screen)

  elseif ( phase == "did" ) then
    -- Code here runs immediately after the scene goes entirely off screen
    composer.removeScene("game")
    timer.cancel(gameLoopTimer)
    timer.cancel(trumpActionsTimer)
    timer.cancel(backgroundAnimationTimer)
    timer.cancel(animation_timers["player"])
  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
  audio.dispose(punch_sound)
  audio.dispose(china_sound)
  -- audio.dispose(stage_music)
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
