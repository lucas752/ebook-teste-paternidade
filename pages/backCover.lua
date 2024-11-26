-----------------------------------------------------------------------------------------
-- 
-- backCover.lua
-- 
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()
local audioManager = require("audioManager")

local background, reloadPageButton, previousPageButton, informationBox, referencesButton, referencesBox, closeReferencesButton
local contentAudio
local referencesAudio
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

local function onReloadButtonTouch(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        pauseAllAudios()
        composer.removeHidden()
        composer.gotoScene("pages.cover", {
            effect = "fade",
            time = 800,
            params = {reset = true}
        })
        return true
    end
end


local function onPreviousPageButtonTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		pauseAllAudios()
		composer.gotoScene( "pages.page5", "slideRight", 800 )
		return true
	end
end

local function onReferencesButtonTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		if referencesBox.isVisible then
			pauseAllAudios()
			referencesBox.isVisible = false
            closeReferencesButton.isVisible = false
            referencesButton.isVisible = true;
		else
			pauseAllAudios()
			referencesBox.isVisible = true
            closeReferencesButton.isVisible = true;
            referencesButton.isVisible = false;
			audio.play(referencesAudio, {loops = 0, channel = 1})
		end
		return true
	end
end

local function onCloseReferencesButtonTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
		pauseAllAudios()
		referencesBox.isVisible = false
		closeReferencesButton.isVisible = false
        referencesButton.isVisible = true;

		return true
	end
end

function scene:create( event )
	local sceneGroup = self.view

	contentAudio = audio.loadStream("assets/sounds/backcover/content.mp3")
	referencesAudio = audio.loadStream("assets/sounds/backcover/references.mp3")

	background = display.newImageRect( sceneGroup, "assets/imgs/lastPageBg.png", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0

	reloadPageButton = display.newImageRect( sceneGroup, "assets/imgs/reloadButton.png", 87, 107 )
	reloadPageButton.x = 670
	reloadPageButton.y = 950

	previousPageButton = display.newImageRect( sceneGroup, "assets/imgs/previousPageButton.png", 87, 100 )
	previousPageButton.x = 90
	previousPageButton.y = 944
	
	informationBox = display.newImageRect( sceneGroup, "assets/imgs/lastPageInformation.png", 516, 238 )
	informationBox.x = display.contentCenterX
	informationBox.y = display.contentCenterY

	referencesButton = display.newImageRect( sceneGroup, "assets/imgs/referencesButton.png", 205, 41 )
	referencesButton.x = display.contentCenterX
	referencesButton.y = 575

	referencesBox = display.newImageRect( sceneGroup, "assets/imgs/referencesBox.png", 546, 438 )
	referencesBox.x = display.contentCenterX
	referencesBox.y = 575
	referencesBox.isVisible = false

    closeReferencesButton = display.newImageRect( sceneGroup, "assets/imgs/closeButton.png", 35, 34 )
	closeReferencesButton.x = 600
	closeReferencesButton.y = 400
	closeReferencesButton.isVisible = false

	audioButton = display.newImageRect(sceneGroup, "assets/imgs/audioOn.png", 87, 108)
    audioButton.x = 670
    audioButton.y = 80
    audioButton:addEventListener("touch", onAudioButtonTouch)

    updateAudioButton()

	sceneGroup:insert( reloadPageButton )
	sceneGroup:insert( previousPageButton )
	sceneGroup:insert( referencesButton )
	sceneGroup:insert( referencesBox )
	sceneGroup:insert( closeReferencesButton )
	sceneGroup:insert( audioButton )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
	elseif phase == "did" then
		audio.play(contentAudio, {loops = 0, channel = 1})

		updateAudioButton()

		reloadPageButton.touch = onReloadButtonTouch
		reloadPageButton:addEventListener( "touch", reloadPageButton )

		previousPageButton.touch = onPreviousPageButtonTouch
		previousPageButton:addEventListener( "touch", previousPageButton )

		referencesButton.touch = onReferencesButtonTouch
		referencesButton:addEventListener( "touch", referencesButton )

        closeReferencesButton.touch = onCloseReferencesButtonTouch
        closeReferencesButton:addEventListener( "touch", closeReferencesButton )
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		reloadPageButton:removeEventListener( "touch", reloadPageButton )
		previousPageButton:removeEventListener( "touch", previousPageButton )
		referencesButton:removeEventListener( "touch", referencesButton )

		pauseAllAudios()
	end
end

function scene:destroy( event )
	local sceneGroup = self.view

	audio.dispose(contentAudio)
	audio.dispose(referencesAudio)
	
end

---------------------------------------------------------------------------------

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene