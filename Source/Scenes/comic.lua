
local composer = require("composer")
local animation = require("plugin.animation")
local effects_system = require("Source.Utilities.effects")

local scene = composer.newScene()


-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

  -- display.setDefault("background", 1,1,1)
  local scene_group = self.view
 
  main_group = display.newGroup()
  scene_group:insert(main_group)

  effects = effects_system:create(scene_group, self.foregroundGroup)

  -- todo: read comic from composer
  self.comic = 1


  if self.comic == 1 then
    self:makeComicOne(main_group, effects)
  end


  -- for i = 1,3,1 do
  --   backing[i] = display.newImageRect(main_group, "Art/white_backing.png", frame_width, frame_height)
  --   backing[i].anchorX = 0
  --   backing[i].anchorY = 0
  --   backing[i].x = target_list[i].cx
  --   backing[i].y = target_list[i].cy
  --   backing[i].alpha = 0.5

  --   frames[i] = display.newImageRect(main_group, target_list[i].frame, inset_width, inset_height)
  --   frames[i].anchorX = 0
  --   frames[i].anchorY = 0
  --   frames[i].x = target_list[i].cx + 10
  --   frames[i].y = target_list[i].cy + 10
  --   frames[i].alpha = 0.5
  -- end

end

function scene:makeComicOne(group, effects)
  print(group)
  print(effects)
  timer.performWithDelay(500, function()
      year_2017 = display.newImageRect(main_group, "Art/Comics/2017.png", 624, 629)
      year_2017.xScale = 0.75
      year_2017.yScale = 0.75
      year_2017.y = display.contentCenterY
      year_2017.x = display.contentWidth + display.contentCenterX
      animation.to(year_2017, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      effects:playSound("swish")
  end)

  timer.performWithDelay(1500, function()
      animation.to(year_2017, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      effects:playSound("swish")
  end)

  timer.performWithDelay(2500, function()
      comic = display.newImageRect(main_group, "Art/Comics/comic_1_page_1.png", 624, 629)
      comic.xScale = 0.75
      comic.yScale = 0.75
      comic.y = display.contentCenterY
      comic.x = display.contentWidth + display.contentCenterX + 200
      header = display.newImageRect(main_group, "Art/Comics/comic_1_header.png", 624, 629)
      header.xScale = 0.75
      header.yScale = 0.75
      header.anchorY = 0
      header.y = 0
      header.x = display.contentWidth + display.contentCenterX + 200
      animation.to(comic, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      animation.to(header, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      effects:playSound("swish")
  end)
end

-- show()
function scene:show( event )

  local scene_group = self.view
  local phase = event.phase

  if ( phase == "will" ) then
    -- Code here runs when the scene is still off screen (but is about to come on screen)
    
    
  elseif ( phase == "did" ) then
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
  end
end


-- destroy()
function scene:destroy( event )

  local scene_group = self.view
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
