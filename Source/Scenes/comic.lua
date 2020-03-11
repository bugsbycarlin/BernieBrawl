
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
 
  self.main_group = display.newGroup()
  scene_group:insert(self.main_group)

  self.overlay_group = display.newGroup()
  scene_group:insert(self.overlay_group)

  self.effects = effects_system:create(scene_group, self.foregroundGroup)

  -- todo: read comic from composer
  self.comic_scene = composer.getVariable("comic_scene")
  if self.comic_scene == nil then
    self.comic_scene = "comic_1"
  end

  if self.comic_scene == "comic_1" then
    self:makeComicOne()
  end

end

function scene:makeComicOne()

  overlay_1 = display.newImageRect(self.overlay_group, "Art/Comics/black_square.png", 54, display.contentHeight)
  overlay_1.anchorX = 0
  overlay_1.x = 0
  overlay_1.y = display.contentCenterY

  overlay_2 = display.newImageRect(self.overlay_group, "Art/Comics/black_square.png", 54, display.contentHeight)
  overlay_2.anchorX = 1
  overlay_2.x = display.contentWidth
  overlay_2.y = display.contentCenterY
  
  timer.performWithDelay(500, function()
      year_2017 = display.newImageRect(self.main_group, "Art/Comics/2017.png", 624, 629)
      year_2017.xScale = 0.75
      year_2017.yScale = 0.75
      year_2017.y = display.contentCenterY
      year_2017.x = display.contentWidth + display.contentCenterX
      animation.to(year_2017, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
  end)

  timer.performWithDelay(1500, function()
      animation.to(year_2017, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      page_1 = display.newImageRect(self.main_group, "Art/Comics/comic_1_page_1.png", 624, 629)
      page_1.xScale = 0.75
      page_1.yScale = 0.75
      page_1.y = display.contentCenterY
      page_1.x = display.contentWidth + display.contentCenterX + 200
      page_1_header = display.newImageRect(self.main_group, "Art/Comics/comic_1_page_1_header.png", 624, 629)
      page_1_header.xScale = 0.75
      page_1_header.yScale = 0.75
      page_1_header.anchorY = 0
      page_1_header.y = 0
      page_1_header.x = display.contentWidth + display.contentCenterX + 200
      animation.to(page_1, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      animation.to(page_1_header, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
  end)

  timer.performWithDelay(4500, function()
      animation.to(page_1, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      animation.to(page_1_header, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
  end)

  timer.performWithDelay(5500, function()
      year_2018 = display.newImageRect(self.main_group, "Art/Comics/2018.png", 624, 629)
      year_2018.xScale = 0.75
      year_2018.yScale = 0.75
      year_2018.y = display.contentCenterY
      year_2018.x = display.contentWidth + display.contentCenterX
      animation.to(year_2018, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
  end)

  -- timer.performWithDelay(8000, function()
      
  -- end)

  timer.performWithDelay(6500, function()
      animation.to(year_2018, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      page_2 = display.newImageRect(self.main_group, "Art/Comics/comic_1_page_2.png", 620, 620)
      page_2.xScale = 0.75
      page_2.yScale = 0.75
      page_2.y = display.contentCenterY
      page_2.x = display.contentWidth + display.contentCenterX + 200
      page_2_header_0 = display.newImageRect(self.main_group, "Art/Comics/comic_1_page_2_header_0.png", 620, 620)
      page_2_header_0.xScale = 0.75
      page_2_header_0.yScale = 0.75
      page_2_header_0.anchorY = 0
      page_2_header_0.y = 0
      page_2_header_0.x = display.contentWidth + display.contentCenterX + 200
      page_2_header_1 = display.newImageRect(self.main_group, "Art/Comics/comic_1_page_2_header_1.png", 620, 620)
      page_2_header_1.xScale = 0.75
      page_2_header_1.yScale = 0.75
      page_2_header_1.anchorY = 0
      page_2_header_1.y = 0
      page_2_header_1.x = display.contentWidth + display.contentCenterX + 200
      animation.to(page_2, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      animation.to(page_2_header_0, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      animation.to(page_2_header_1, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
  end)

  timer.performWithDelay(8500, function()
      page_2_header_2 = display.newImageRect(self.main_group, "Art/Comics/comic_1_page_2_header_2.png", 620, 620)
      page_2_header_2.xScale = 0.75
      page_2_header_2.yScale = 0.75
      page_2_header_2.anchorY = 0
      page_2_header_2.y = 0
      page_2_header_2.x = display.contentWidth + display.contentCenterX + 200
      animation.to(page_2_header_1, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      animation.to(page_2_header_2, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
  end)

  timer.performWithDelay(10500, function()
      page_2_header_3 = display.newImageRect(self.main_group, "Art/Comics/comic_1_page_2_header_3.png", 620, 620)
      page_2_header_3.xScale = 0.75
      page_2_header_3.yScale = 0.75
      page_2_header_3.anchorY = 0
      page_2_header_3.y = 0
      page_2_header_3.x = display.contentWidth + display.contentCenterX + 200
      animation.to(page_2_header_2, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      animation.to(page_2_header_3, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
  end)

  timer.performWithDelay(12500, function()
      page_2_response = display.newImageRect(self.main_group, "Art/Comics/comic_1_page_2_response.png", 620, 620)
      page_2_response.xScale = 0.75
      page_2_response.yScale = 0.75
      page_2_response.y = display.contentCenterY
      page_2_response.x = display.contentCenterX
      self.effects:playSound("feh")
  end)

  timer.performWithDelay(16500, function()
      page_2_header_0.isVisible = false
      animation.to(page_2, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      animation.to(page_2_header_3, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      animation.to(page_2_response, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
  end)

  timer.performWithDelay(17500, function()
      year_2019 = display.newImageRect(self.main_group, "Art/Comics/2019.png", 624, 629)
      year_2019.xScale = 0.75
      year_2019.yScale = 0.75
      year_2019.y = display.contentCenterY
      year_2019.x = display.contentWidth + display.contentCenterX
      animation.to(year_2019, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
  end)

  timer.performWithDelay(18500, function()
      animation.to(year_2019, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
      page_3 = display.newImageRect(self.main_group, "Art/Comics/comic_1_page_3.png", 620, 584)
      page_3.xScale = 0.65
      page_3.yScale = 0.65
      page_3.y = 0
      page_3.anchorY = 0
      page_3.x = display.contentWidth + display.contentCenterX + 200
      animation.to(page_3, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
  end)

  timer.performWithDelay(24000, function()
      animation.to(page_3, {x=-1 * display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
  end)

  timer.performWithDelay(25000, function()
      chapter_one = display.newImageRect(self.main_group, "Art/Comics/chapter_one.png", 624, 629)
      chapter_one.xScale = 0.75
      chapter_one.yScale = 0.75
      chapter_one.y = display.contentCenterY
      chapter_one.x = display.contentWidth + display.contentCenterX
      animation.to(chapter_one, {x=display.contentCenterX}, {time=200, easing=easing.inOutExpo})
      self.effects:playSound("swish")
  end)

  timer.performWithDelay(27000, function()
    animation.to(self.view, {alpha=0}, {time=2000, easing=easing.linear})
  end)

  timer.performWithDelay(29000, function()
    composer.gotoScene("Source.Scenes.game")
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
