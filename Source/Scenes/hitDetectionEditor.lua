
local composer = require("composer")
local json = require("json")

local scene = composer.newScene()


local sceneGroup 
local mainGroup
local hitboxGroup
local uiGroup

local save_button

local scale = 1.5

local sprite

local frames
local current_frame

local frameText

local character = "sanders"

local spriteInfo = require("Source.Sprites." .. character .. "Sprite")
local sprite = graphics.newImageSheet("Art/" .. character .. "_sprite.png", spriteInfo:getSheet())

local hitBoxes = {}

local function pageSetup()
  for i = hitboxGroup.numChildren, 1, -1 do
    hitboxGroup[i]:removeSelf()
    hitboxGroup[1] = nil
  end
  if hitBoxes[current_frame] == nil or #hitBoxes[current_frame] == 0 then
    return
  end
  for i = 1, #hitBoxes[current_frame] do
    if hitBoxes[current_frame][i].type == "circle" then
      -- print(i)
      -- print(hitBoxes[current_frame][i].x .. " " .. hitBoxes[current_frame][i].y)
      local circle = display.newCircle(hitboxGroup, hitBoxes[current_frame][i].x, hitBoxes[current_frame][i].y, hitBoxes[current_frame][i].radius)
      circle.alpha = 0.5
      if i == #hitBoxes[current_frame] then
        circle.alpha = 0.9
      end
      purpose = hitBoxes[current_frame][i].purpose
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

local function printHitBoxes()
  for k = 1, 10 do
    print("")
  end
  for f = 1, #frames do
    frame = frames[f]
    print("{")
    if hitBoxes[frame] ~= nil then
      for i = 1, #hitBoxes[frame] do
        h = hitBoxes[frame][i]
        print("  {x=" .. h.x .. ",y=".. h.y .. ",type=\"" .. h.type .. "\",purpose=\"" .. h.purpose .. "\",radius=" .. h.radius .. "},")
      end
    end
    print("},")
  end
  for k = 1, 10 do
    print("")
  end
end

local function debugKeyboard(event)
  if event.phase == "up" then    
    if event.keyName == "," then
      current_frame = current_frame - 1
      if current_frame == 0 then
        current_frame = #frames
      end
    end
    if event.keyName == "." then
      current_frame = current_frame + 1
      if current_frame > #frames then
        current_frame = 1
      end
    end

    if hitBoxes[current_frame] == nil or #hitBoxes[current_frame] == 0 then
      sprite:setFrame(current_frame)
      frameText.text = "Frame " .. current_frame
      pageSetup()
      return
    end

    selected_circle = hitBoxes[current_frame][#hitBoxes[current_frame]]
    
    -- move the hitbox in space
    if event.keyName == "w" then
      selected_circle.y = selected_circle.y - 1
    elseif event.keyName == "s" then
      selected_circle.y = selected_circle.y + 1
    elseif event.keyName == "a" then
      selected_circle.x = selected_circle.x - 1
    elseif event.keyName == "d" then
      selected_circle.x = selected_circle.x + 1
    end

    -- change the radius of the hitbox
    if event.keyName == "up" then
      selected_circle.radius = selected_circle.radius + 1
    elseif event.keyName == "down" then
      selected_circle.radius = selected_circle.radius - 1
      if selected_circle.radius == 0 then
        selected_circle.radius = 1
      end
    elseif event.keyName == "1" then
      selected_circle.radius = 3
    elseif event.keyName == "2" then
      selected_circle.radius = 6
    elseif event.keyName == "3" then
      selected_circle.radius = 9
    elseif event.keyName == "4" then
      selected_circle.radius = 12
    elseif event.keyName == "5" then
      selected_circle.radius = 15
    elseif event.keyName == "6" then
      selected_circle.radius = 18
    elseif event.keyName == "7" then
      selected_circle.radius = 21
    elseif event.keyName == "8" then
      selected_circle.radius = 24
    elseif event.keyName == "9" then
      selected_circle.radius = 27
    elseif event.keyName == "0" then
      selected_circle.radius = 30
    end

    -- remove the current hitbox
    if event.keyName == "z" then
      table.remove(hitBoxes[current_frame])
    end

    -- change the purpose of the hitbox
    if event.keyName == "left" or event.keyName == "right" then
      if selected_circle.purpose == "attack" then
        selected_circle.purpose = "defense"
      elseif selected_circle.purpose == "defense" then
        selected_circle.purpose = "vulnerability"
      elseif selected_circle.purpose == "vulnerability" then
        selected_circle.purpose = "attack"
      end
    end

    -- cycle between hitboxes
    if event.keyName == "c" then
      last_circle = hitBoxes[current_frame][#hitBoxes[current_frame]]
      table.remove(hitBoxes[current_frame])
      table.insert(hitBoxes[current_frame], 1, last_circle)
      selected_circle = hitBoxes[current_frame][#hitBoxes[current_frame]]
    end

    -- print the information
    if event.keyName == "p" then
      print("Hello here")
      printHitBoxes()
    end

    sprite:setFrame(current_frame)
    frameText.text = "Frame " .. current_frame
    pageSetup()
  end
end

local function createHitbox(x, y)
  if hitBoxes[current_frame] == nil then
    hitBoxes[current_frame] = {}
  end
  table.insert(hitBoxes[current_frame], {x=x, y=y, radius=10, type="circle", purpose="vulnerability"})
  pageSetup()
end

local click_event = {}
local function clicky(event)

  if (event.phase == "ended") then
    x = (event.x - display.contentCenterX) / scale
    y = (event.y - display.contentCenterY) / scale
    createHitbox(x, y)
  end

  return true  -- Prevents touch propagation to underlying objects
end

local filepath = system.pathForFile(character .. "_hitdetection.json", system.DocumentsDirectory)

local function saveInfo(event)
  local file = io.open(filepath, "w")
 
  if file then
    file:write(json.encode(hitBoxes))
    io.close(file)
  end

  print(filepath)

  return true
end

local function loadInfo()
  local file = io.open(filepath, "r")
  print(filepath)
 
  if file then
      local contents = file:read("*a")
      io.close(file)
      hitBoxes = json.decode(contents)
  end

  if hitBoxes == nil or #hitBoxes == 0 then
    hitBoxes = {}
  end
end


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  local sceneGroup = self.view
  -- Code here runs when the scene is first created but has not yet appeared on screen
  display.setDefault("background", 0.8, 0.8, 0.8)

  mainGroup = display.newGroup()
  sceneGroup:insert(mainGroup)
  hitboxGroup = display.newGroup()
  sceneGroup:insert(hitboxGroup)
  uiGroup = display.newGroup()
  sceneGroup:insert(uiGroup)

  hitboxGroup.x = display.contentCenterX
  hitboxGroup.y = display.contentCenterY
  hitboxGroup.xScale = scale
  hitboxGroup.yScale = scale

  frames = {}
  for i = 1, #spriteInfo.sheet.frames do
    table.insert(frames, i)
  end

  sprite = display.newSprite(mainGroup, sprite, {frames=frames})
  sprite.x = display.contentCenterX
  sprite.y = display.contentCenterY
  sprite.xScale = scale
  sprite.yScale = scale

  current_frame = 1

  frameText = display.newText(uiGroup, "Frame 1", 20, 20, "Georgia-Bold", 20)
  frameText:setTextColor(0.18, 0.18, 0.18)
  frameText.anchorX = 0
  frameText.anchorY = 0

  save_button = display.newImageRect(uiGroup, "Art/save.png", 60, 60)
  save_button.x = display.contentWidth - 50
  save_button.y = display.contentHeight - 50

  save_button:addEventListener("tap", saveInfo)
  Runtime:addEventListener("key", debugKeyboard)
  sprite:addEventListener("touch", clicky)
end


-- show()
function scene:show( event )

  local sceneGroup = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    loadInfo()

  elseif ( phase == "did" ) then
    -- Code here runs when the scene is entirely on screen
    pageSetup()
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
  end
end


-- destroy()
function scene:destroy( event )

  local sceneGroup = self.view
  -- Code here runs prior to the removal of scene's view
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
