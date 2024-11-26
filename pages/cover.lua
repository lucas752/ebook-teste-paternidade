-----------------------------------------------------------------------------------------
--
-- cover.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local audioManager = require("audioManager")

--------------------------------------------

local background
local nextPageButton
local contentAudio
local audioButton

local function updateAudioButton()
	print(audioManager.getAudioState())
    if audioManager.getAudioState() then
        audioButton.fill = { type = "image", filename = "assets/imgs/audioOff.png" }
		audioButton.width = 87
        audioButton.height = 108
    else
        audioButton.fill = { type = "image", filename = "assets/imgs/audioOn.png" }
		audioButton.width = 119
        audioButton.height = 108
    end
end

local function onAudioButtonTouch(event)
    if event.phase == "ended" then
        audioManager.toggleAudio()
        updateAudioButton()
    end
    return true
end

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

    audioButton = display.newImageRect(sceneGroup, "assets/imgs/audioOn.png", 87, 108)
    audioButton.x = 670
    audioButton.y = 80
    audioButton:addEventListener("touch", onAudioButtonTouch)

    updateAudioButton()

	sceneGroup:insert( background )
	sceneGroup:insert( nextPageButton )
	sceneGroup:insert( audioButton )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if phase == "will" then
	elseif phase == "did" then
		audio.play(contentAudio, {loops = 0, channel = 1})

		updateAudioButton()

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