
local composer = require("composer")
local gameplan = require("Source.Utilities.gameplan")

local scene = composer.newScene()

candidates = {}
candidates["warren"] = require("Source.Candidates.Warren")
candidates["trump"] = require("Source.Candidates.Trump")
candidates["biden"] = require("Source.Candidates.Biden")
candidates["sanders"] = require("Source.Candidates.Sanders")

local effects_class = require("Source.Utilities.effects")

local function gotoFlight()
  audio.stop(1)
  audio.dispose(select_music)
  audio.play(punch_sound, {channel=4})
  composer.gotoScene("Source.Scenes.flight", {effect = "fade", time = 500})
end

local big_faces = {}
local small_faces = {}
local background
local checkmark
local selection_square

local finished = false

local nameText
local nicknameText

local select_music = audio.loadStream("Sound/SS_98_carry_on_drum_loop.wav")
local punch_sound = audio.loadSound("Sound/punch.wav")

local effects

local fighter

local animationTimer

local names = {"warren", "sanders", "biden", "buttigieg", "yang", "bloomberg"}
local nicknames = {
  warren = "the planner",
  sanders = "the populist",
  biden = "the smiler",
  buttigieg = "the polyglot",
  yang = "the founder",
  bloomberg = "the money"}
layout = {{164,159}, {244,159}, {324,159}, {164,239}, {244,239}, {324,239}}

local selectable_names = {"biden", "sanders", "warren",}

-- TODO playable trump and bonus clinton
-- TODO VP debate
-- local names = {"warren", "sanders", "biden", "buttigieg", "yang", "bloomberg", "clinton", "trump"}
-- local nicknames = {"the protector", "the populist", "chosen son", "the polyglot", "the founder", "the money", "determined", "unbelievable"}
-- layout = {{8, 8}, {116, 8}, {224, 8}, {8, 116}, {116, 116}, {224, 116}, {8, 224}, {116, 224}}

-- local locations = {"Iowa", "New Hampshire", "Super Tuesday", "DNC - Milwaukee", "Vice Presidential Debate - Salt Lake City", "First Debate - South Bend", "Second Debate - Nashville", "Final Battle"}

local selection_number = 1
local selection = ""

local function choose_player(event)
  composer.setVariable("candidate", selection)
  gameplan:nextRound()

  -- local remaining_candidates = {}
  -- for i = 1, #selectable_names do
  --   if selection ~= selectable_names[i] then
  --     table.insert(remaining_candidates, selectable_names[i])
  --   end
  -- end
  -- composer.setVariable("remaining_candidates", remaining_candidates)


  -- local opponent = table.remove(remaining_candidates, math.random(1, #remaining_candidates))
  -- composer.setVariable("opponent", opponent)
  
  -- location = table.remove(locations, 1)
  -- composer.setVariable("location", location)
  -- composer.setVariable("remaining_locations", locations)
  -- composer.setVariable("player_wins", 0)
  -- composer.setVariable("opponent_wins", 0)
  -- composer.setVariable("round", 1)
  audio.play(punch_sound)
  Runtime:removeEventListener("key", keyboard)
  -- hack because removeEventListener doesn't appear to be working
  finished = true
  gotoFlight()
end

local function select_fighter(event)
  if finished then
    return
  end
  selection = event.target.name
  selectable = false
  for i = 1,#selectable_names,1 do
    if selection == selectable_names[i] then
      selectable = true
    end
  end
  if selectable == false then
    return
  end
  for i = 1,#names,1 do
    big_faces[names[i]].isVisible = false
  end
  for i = 1,#selectable_names,1 do
    name = small_faces[selectable_names[i]].name
    if name == selection then
      big_faces[name].isVisible = true
      nickNameText.text = string.upper(nicknames[name])
      selection_square.isVisible = true
      selection_square.x = small_faces[name].x - 1
      selection_square.y = small_faces[name].y - 1
    end
  end
  if fighter ~= nil then
    -- fighter.disable()
    fighter:disable()
    display.remove(fighter)
    -- fighter = nil
  end
  fighter = candidates[selection]:create(display.contentCenterX + 210, display.contentCenterY - 120, mainGroup, -500, 1500, effects)
  fighter.xScale = -0.75
  fighter.yScale = 0.75
  fighter.ground_target = fighter.y
  fighter:enable()

  nameText.text = string.upper(selection)
  checkmark.isVisible = true
end

local function keyboard(event)
  if finished then
    return
  end
  if event.keyName == "enter" and event.phase == "up" then
    choose_player()
  end

  if event.keyName == "left" and event.phase == "up" then
    selection_number = selection_number - 1
    if selection_number == 0 then
      selection_number = 3
    elseif selection_number == 3 then
      selection_number = 4
    end
  end
  if event.keyName == "right" and event.phase == "up" then
    selection_number = selection_number + 1
    if selection_number == 4 then
      selection_number = 1
    elseif selection_number == 7 then
      selection_number = 4
    end
  end
  -- if event.keyName == "up" and event.phase == "up" then
  --   selection_number = selection_number - 3
  --   if selection_number < 1 then
  --     selection_number = selection_number + 6
  --   elseif selection_number > 6 then
  --     selection_number = selection_number - 6
  --   end
  -- end
  -- if event.keyName == "down" and event.phase == "up" then
  --   selection_number = selection_number + 3
  --   if selection_number < 1 then
  --     selection_number = selection_number + 6
  --   elseif selection_number > 6 then
  --     selection_number = selection_number - 6
  --   end
  -- end

  select_fighter({target={name=names[selection_number]}})

  return true
end

target = {x=display.contentCenterX,y=display.contentCenterY}

local checkmark_pulse_counter
local function animation()
  checkmark_pulse_counter = checkmark_pulse_counter + 0.1
  checkmark.xScale = 0.96 + 0.08 * math.sin(checkmark_pulse_counter)
  checkmark.yScale = 0.96 + 0.08 * math.sin(checkmark_pulse_counter)

  speed = 0.2
  if math.abs(background.x - target.x) < 1 and math.abs(background.y - target.y) < 1 then
    target.x = display.contentCenterX + math.random(1,200) - 100
    target.y = display.contentCenterY + math.random(1,160) - 80
  else
    if background.x < target.x then
      background.x = background.x + speed
    elseif background.x > target.x then
      background.x = background.x - speed
    end
    if background.y < target.y then
      background.y = background.y + speed
    elseif background.y > target.y then
      background.y = background.y - speed
    end
  end
end

local function beatPulse()
  -- local current_face = small_faces[names[math.random(1, 6)]]
  -- if current_face.xScale == -1 then
  --   current_face.xScale = -1.01
  -- else
  --   current_face.xScale = -1
  -- end
  -- for i = 1,#names,1 do
  --   name = names[i]
  --   if small_faces[name].x == layout[i][1] then
  --     small_faces[name].x = small_faces[name].x + 1
  --   else
  --     small_faces[name].x = layout[i][1]
  --   end
  -- end
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen

  bgGroup = display.newGroup()
  sceneGroup:insert( bgGroup )
  mainGroup = display.newGroup()
  sceneGroup:insert( mainGroup )
  uiGroup = display.newGroup()
  sceneGroup:insert( uiGroup )

  background = display.newImageRect( bgGroup, "Art/selection_background.png", 800, 550)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  selection_square = display.newImageRect( bgGroup, "Art/selection_square.png", 80, 80)
  selection_square.anchorX = 0
  selection_square.anchorY = 0
  selection_square.isVisible = false

  effects = effects_class:create()

  for i = 1,#names,1 do
    name = names[i]
    selectable = false
    for j = 1,#selectable_names,1 do
      if name ==selectable_names[j] then
        selectable = true
      end
    end
    
    big_faces[name] = display.newImageRect( mainGroup, "Art/" .. name .. "_face.png", 150, 150 )
    big_faces[name].x = 152
    big_faces[name].y = 2
    big_faces[name].anchorX = 0
    big_faces[name].anchorY = 0
    big_faces[name].xScale = -1
    big_faces[name].isVisible = false

    small_faces[name] = display.newImageRect( mainGroup, "Art/" .. name .. "_face.png", 78, 78 )
    small_faces[name].name = name
    small_faces[name].x = layout[i][1]
    small_faces[name].y = layout[i][2]
    small_faces[name].anchorX = 1
    small_faces[name].anchorY = 0
    small_faces[name].xScale = -1
    if selectable then
      small_faces[name]:addEventListener("touch", select_fighter)
    else
      small_faces[name].fill.effect = "filter.duotone"
      small_faces[name].fill.effect.darkColor = { 0.5, 0.5, 0.5, 1 }
      small_faces[name].fill.effect.lightColor = { 0.8, 0.8, 0.8, 1 }
      small_faces[name]:setFillColor(1,1,1)
    end
  end

  nameText = display.newEmbossedText(uiGroup, "", display.contentCenterX, 52, "Georgia-Bold", 30)
  nameText.anchorX = 0.5
  nameText.anchorY = 0
  nameText:setTextColor(0.72, 0.18, 0.18)
  nickNameText = display.newEmbossedText(uiGroup, "", display.contentCenterX, 82, "Georgia-Bold", 20)
  nickNameText.anchorX = 0.5
  nickNameText.anchorY = 0
  nickNameText:setTextColor(0.72, 0.18, 0.18)

  checkmark = display.newImageRect( uiGroup, "Art/checkmark.png", 100, 100)
  -- checkmark.anchorX = 0
  -- checkmark.anchorY = 0
  checkmark.x = display.contentWidth - 108 + 50
  checkmark.y = display.contentHeight - 108 + 50
  checkmark.isVisible = false

  checkmark_pulse_counter = 0

  checkmark:addEventListener("touch", choose_player)

  Runtime:addEventListener("key", keyboard)

  -- fist:addEventListener("tap", player_punch)
  -- Runtime:addEventListener("touch", swipe)
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    animationTimer = timer.performWithDelay(33, animation, 0)
    audio.play(select_music, { channel=1, loops=-1 })

    beatPulseTimer = timer.performWithDelay(306/2, beatPulse, 0)

    select_fighter({target={name="warren"}})

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
    timer.cancel(animationTimer)
    composer.removeScene("Source.Scenes.selection")
    if fighter ~= nil then
      fighter:disable()
      display.remove(fighter)
    end
  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
  audio.dispose(punch_sound)
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
