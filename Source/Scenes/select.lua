
local composer = require("composer")

local scene = composer.newScene()

-- local function gotoAnnounce()
--   composer.gotoScene("Source.Scenes.announce", {effect = "fade", time = 1000})
-- end

local function gotoPrefight()
  audio.stop(1)
  audio.dispose(select_music)
  audio.play(punch_sound, {channel=4})
  composer.gotoScene("Source.Scenes.prefight", {effect = "fade", time = 1000})
end

local big_faces = {}
local small_faces = {}
local background
local checkmark
local selection_square

local nameText
local nicknameText

local select_music = audio.loadStream("Sound/SS_98_carry_on_drum_loop.wav")
local punch_sound = audio.loadSound("Sound/punch.wav")

local names = {"warren", "sanders", "biden", "buttigieg", "yang", "bloomberg"}
local nicknames = {
  warren = "the protector",
  sanders = "the populist",
  biden = "chosen son",
  buttigieg = "the polyglot",
  yang = "the founder",
  bloomberg = "the money"}
layout = {{8, 8}, {116, 8}, {224, 8}, {8, 116}, {116, 116}, {224, 116}}

local selectable_names = {"warren", "sanders", "biden"}

-- TODO playable trump and bonus clinton
-- TODO VP debate
-- local names = {"warren", "sanders", "biden", "buttigieg", "yang", "bloomberg", "clinton", "trump"}
-- local nicknames = {"the protector", "the populist", "chosen son", "the polyglot", "the founder", "the money", "determined", "unbelievable"}
-- layout = {{8, 8}, {116, 8}, {224, 8}, {8, 116}, {116, 116}, {224, 116}, {8, 224}, {116, 224}}

local locations = {"iowa", "new hampshire", "super tuesday", "nomination fight", "first debate", "second debate", "final battle"}

local selection = ""

local function choose_player(event)
  composer.setVariable("candidate", selection)
  local remaining_candidates = {}
  for i = 1, #selectable_names do
    if selection ~= selectable_names[i] then
      table.insert(remaining_candidates, selectable_names[i])
    end
  end
  local opponent = table.remove(remaining_candidates, math.random(1, #remaining_candidates))
  composer.setVariable("opponent", opponent)
  composer.setVariable("remaining_candidates", remaining_candidates)
  location = table.remove(locations, 1)
  composer.setVariable("location", location)
  composer.setVariable("remaining_locations", locations)
  composer.setVariable("player_wins", 0)
  composer.setVariable("opponent_wins", 0)
  composer.setVariable("round", 1)
  audio.play(punch_sound)
  gotoPrefight()
end

local function select_fighter(event)
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
      selection_square.x = small_faces[name].x - 2
      selection_square.y = small_faces[name].y - 2
    end
  end
  nameText.text = string.upper(selection)
  checkmark.isVisible = true
end

local checkmark_pulse_counter
local function checkmarkPulse()
  checkmark_pulse_counter = checkmark_pulse_counter + 0.1
  checkmark.xScale = 0.96 + 0.08 * math.sin(checkmark_pulse_counter)
  checkmark.yScale = 0.96 + 0.08 * math.sin(checkmark_pulse_counter)
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

  background = display.newImageRect( bgGroup, "Art/select_background.png", 568, 320)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  selection_square = display.newImageRect( bgGroup, "Art/selection_square.png", 104, 104)
  selection_square.anchorX = 0
  selection_square.anchorY = 0
  selection_square.isVisible = false

  for i = 1,#names,1 do
    name = names[i]
    selectable = false
    for j = 1,#selectable_names,1 do
      if name ==selectable_names[j] then
        selectable = true
      end
    end
    
    big_faces[name] = display.newImageRect( mainGroup, "Art/" .. name .. "_face.png", 200, 200 )
    big_faces[name].x = 340
    big_faces[name].y = 12
    big_faces[name].anchorX = 0
    big_faces[name].anchorY = 0
    big_faces[name].xScale = 1
    big_faces[name].isVisible = false

    small_faces[name] = display.newImageRect( mainGroup, "Art/" .. name .. "_face.png", 100, 100 )
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

  nameText = display.newEmbossedText(uiGroup, "", 240, 232, "Georgia-Bold", 30)
  nameText.anchorX = 0
  nameText.anchorY = 0
  nameText:setTextColor(0.72, 0.18, 0.18)
  nickNameText = display.newEmbossedText(uiGroup, "", 240, 262, "Georgia-Bold", 20)
  nickNameText.anchorX = 0
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

  -- fist:addEventListener("tap", player_punch)
  -- Runtime:addEventListener("touch", swipe)
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    checkmarkPulseTimer = timer.performWithDelay(30, checkmarkPulse, 0)
    audio.play(select_music, { channel=1, loops=-1 })

    beatPulseTimer = timer.performWithDelay(306/2, beatPulse, 0)

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
    composer.removeScene("select")
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
