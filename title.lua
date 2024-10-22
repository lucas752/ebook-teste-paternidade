-----------------------------------------------------------------------------------------
--
-- title.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------

local background
local nextPageButton

local function onNextPageButtonTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		composer.gotoScene( "page1", "slideLeft", 800 )
		return true
	end
end

function scene:create( event )
	local sceneGroup = self.view
	background = display.newImageRect( sceneGroup, "coverpg1.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	nextPageButton = display.newImageRect( sceneGroup, "nextpagebutton.png", 87, 107 )
	nextPageButton.x = 670
	nextPageButton.y = 950

	sceneGroup:insert( background )
	sceneGroup:insert( nextPageButton )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
	elseif phase == "did" then
		nextPageButton.touch = onNextPageButtonTouch
		nextPageButton:addEventListener( "touch", nextPageButton )
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		nextPageButton:removeEventListener( "touch", nextPageButton )
		
	elseif phase == "did" then
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
end

---------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene