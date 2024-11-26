-----------------------------------------------------------------------------------------
--
-- cover.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

--------------------------------------------

local background
local nextPageButton
local contentAudio

local function pauseAllAudios()
    for i = 1, 32 do
        audio.stop(i)
        audio.setVolume(1.0, {channel = i})
    end
end

local function onNextPageButtonTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		pauseAllAudios()
		composer.gotoScene( "pages.page1", "slideLeft", 800 )
		return true
	end
end

function scene:create( event )
	local sceneGroup = self.view

	contentAudio = audio.loadStream("assets/sounds/cover/content.mp3")

	background = display.newImageRect( sceneGroup, "assets/imgs/coverpg1.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	nextPageButton = display.newImageRect( sceneGroup, "assets/imgs/nextpagebutton.png", 87, 107 )
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
		audio.play(contentAudio, {loops = 0, channel = 1})

		nextPageButton.touch = onNextPageButtonTouch
		nextPageButton:addEventListener( "touch", nextPageButton )
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		nextPageButton:removeEventListener( "touch", nextPageButton )

		pauseAllAudios()
		
	elseif phase == "did" then
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view

	audio.dispose(contentAudio)
end

---------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene