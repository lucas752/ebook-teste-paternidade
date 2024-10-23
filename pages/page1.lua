-----------------------------------------------------------------------------------------
-- 
-- page1.lua
-- 
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local background, nextPageButton, previousPageButton, contentText

local function onNextPageButtonTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		composer.gotoScene( "pages.page2", "slideLeft", 800 )
		return true
	end
end

local function onPreviousPageButtonTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		composer.gotoScene( "pages.cover", "slideRight", 800 )
		return true
	end
end

function scene:create( event )
	local sceneGroup = self.view

	background = display.newImageRect( sceneGroup, "assets/imgs/pageContentBg.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	nextPageButton = display.newImageRect( sceneGroup, "assets/imgs/nextpagebutton.png", 87, 107 )
	nextPageButton.x = 670
	nextPageButton.y = 950

	previousPageButton = display.newImageRect( sceneGroup, "assets/imgs/previousPageButton.png", 87, 100 )
	previousPageButton.x = 90
	previousPageButton.y = 944

	contentText = display.newText( sceneGroup, "Página 2", display.contentCenterX, 210, "ComicNeue-Regular", 50 )
	contentText:setFillColor( 0.165, 0.267, 0.365 )

	sceneGroup:insert( nextPageButton )
	sceneGroup:insert( previousPageButton )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
	elseif phase == "did" then
		nextPageButton.touch = onNextPageButtonTouch
		nextPageButton:addEventListener( "touch", nextPageButton )

		previousPageButton.touch = onPreviousPageButtonTouch
		previousPageButton:addEventListener( "touch", previousPageButton )
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		nextPageButton:removeEventListener( "touch", nextPageButton )
		previousPageButton:removeEventListener( "touch", previousPageButton )
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