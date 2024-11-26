-----------------------------------------------------------------------------------------
-- 
-- page5.lua
-- 
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

local background, nextPageButton, previousPageButton, contentText, instructionText, titleText, textBackground, legendColors, childParenMatching, father1, father2, father3, father4, childMother, father1Result, father2Result, father3Result, father4Result, backButton
local contentAudio, instructionAudio, isNotFatherAudio, isTheFatherAudio

local initialPositions = {}

local function saveInitialPositions()
    initialPositions = {
        father1 = { x = father1.x, y = father1.y },
        father2 = { x = father2.x, y = father2.y },
        father3 = { x = father3.x, y = father3.y },
        father4 = { x = father4.x, y = father4.y }
    }
end

local function pauseAllAudios()
    for i = 1, 32 do
        audio.stop(i)
        audio.setVolume(1.0, {channel = i})
    end
end

local function resetState()
    father1.isVisible = true
    father2.isVisible = true
    father3.isVisible = true
    father4.isVisible = true
    childMother.isVisible = true
    childParenMatching.isVisible = true

    father1Result.isVisible = false
    father2Result.isVisible = false
    father3Result.isVisible = false
    father4Result.isVisible = false

    father1.x, father1.y = initialPositions.father1.x, initialPositions.father1.y
    father2.x, father2.y = initialPositions.father2.x, initialPositions.father2.y
    father3.x, father3.y = initialPositions.father3.x, initialPositions.father3.y
    father4.x, father4.y = initialPositions.father4.x, initialPositions.father4.y

    backButton.isVisible = false
end

local function handleFatherDrop(father, result)
    father1.isVisible = false
    father2.isVisible = false
    father3.isVisible = false
    father4.isVisible = false
    childMother.isVisible = false
    childParenMatching.isVisible = false

    father1Result.isVisible = false
    father2Result.isVisible = false
    father3Result.isVisible = false
    father4Result.isVisible = false

    result.isVisible = true
    backButton.isVisible = true

    pauseAllAudios()

    if result == father2Result then
        audio.play(isTheFatherAudio, {loops = 0, channel = 3})
    elseif result == father1Result or result == father3Result or result == father4Result then
        audio.play(isNotFatherAudio, {loops = 0, channel = 3})
    end
end

local function addDragListeners(father, result)
    father.touch = function(self, event)
        if event.phase == "began" then
            display.getCurrentStage():setFocus(self)
            self.isFocus = true
            self.markX = self.x
            self.markY = self.y
        elseif self.isFocus then
            if event.phase == "moved" then
                self.x = event.x - event.xStart + self.markX
                self.y = event.y - event.yStart + self.markY
            elseif event.phase == "ended" or event.phase == "cancelled" then
                display.getCurrentStage():setFocus(nil)
                self.isFocus = false

                local boundsFather = self.contentBounds
                local boundsChildMother = childMother.contentBounds
                if boundsFather.xMin < boundsChildMother.xMax and
                   boundsFather.xMax > boundsChildMother.xMin and
                   boundsFather.yMin < boundsChildMother.yMax and
                   boundsFather.yMax > boundsChildMother.yMin then
                    handleFatherDrop(father, result)
                else
                    self.x = self.markX
                    self.y = self.markY
                end
            end
        end
        return true
    end
    father:addEventListener("touch", father)
end

local function onNextPageButtonTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
        pauseAllAudios()
		composer.gotoScene( "pages.backCover", "slideLeft", 800 )
		return true
	end
end

local function onPreviousPageButtonTouch( self, event )
	if event.phase == "ended" or event.phase == "cancelled" then
        pauseAllAudios()
		composer.gotoScene( "pages.page4", "slideRight", 800 )
		return true
	end
end

local function playInstructionsAudio()
    if not audio.isChannelActive(3) and composer.getSceneName("current") == "pages.page5" then
        audio.setVolume(1.0, {channel = 2})
        audio.play(instructionAudio, {loops = 0, channel = 2})
    end
end

function scene:create( event )
	local sceneGroup = self.view

    contentAudio = audio.loadStream("assets/sounds/pg5/content.mp3")
    instructionAudio = audio.loadStream("assets/sounds/pg5/instructions.mp3")
    isNotFatherAudio = audio.loadStream("assets/sounds/pg5/isNotFather.mp3")
    isTheFatherAudio = audio.loadStream("assets/sounds/pg5/isTheFather.mp3")

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

	instructionText = display.newText({
        parent = sceneGroup,
        text = "Arraste um dos possíveis pais até a criança e descubra se ele é o pai biológico",
        x = display.contentCenterX,
        y = 58,
        width = 300,
        font = "assets/fonts/ComicNeue-Bold.ttf",
        fontSize = 22,
        align = "center"
    })
    instructionText:setFillColor(1, 1, 1)

    titleText = display.newText(sceneGroup, "Resultado do teste", display.contentCenterX, 210, "ComicNeue-Regular", 50)
    titleText:setFillColor(0.165, 0.267, 0.365)

    textBackground = display.newImageRect(sceneGroup, "assets/imgs/textBackground.png", display.contentWidth, 580)
    textBackground.anchorX = 0.5
    textBackground.anchorY = 0.5
    textBackground.x = display.contentCenterX
    textBackground.y = 590
    
	legendColors = display.newImageRect(sceneGroup, "assets/imgs/pg5/legendColors.png", 228.2, 120.4)
    legendColors.x = display.contentCenterX
    legendColors.y = 950
	
    contentText = display.newText({
		parent = sceneGroup,
        text = "Durante o teste de paternidade, os locos genéticos da criança e do suposto pai são comparados. Cada criança herda metade de seus locos da mãe e a outra metade do pai. Se os locos do suposto pai coincidirem com os da criança, ele será confirmado como pai biológico.",
			x = display.contentCenterX,
			y = 460,
			width = 689,
			font = "assets/fonts/ComicNeue-Bold.ttf",
			fontSize = 29,
			align = "left"
		})
	contentText:setFillColor(0.165, 0.267, 0.365)
		
	childParenMatching = display.newImageRect(sceneGroup, "assets/imgs/pg5/childParentMatching.png", 455, 310.8)
	childParenMatching.x = display.contentCenterX
	childParenMatching.y = 720

	childMother = display.newImageRect(sceneGroup, "assets/imgs/pg5/childMother.png", 140, 310.8)
	childMother.x = 225
	childMother.y = 720

	father1 = display.newImageRect(sceneGroup, "assets/imgs/pg5/father1.png", 61.6, 310.8)
	father1.x = 360
	father1.y = 720

	father2 = display.newImageRect(sceneGroup, "assets/imgs/pg5/father2.png", 61.6, 310.8)
	father2.x = 435
	father2.y = 720

	father3 = display.newImageRect(sceneGroup, "assets/imgs/pg5/father3.png", 61.6, 310.8)
	father3.x = 510
	father3.y = 720

	father4 = display.newImageRect(sceneGroup, "assets/imgs/pg5/father4.png", 61.6, 310.8)
	father4.x = 582
	father4.y = 720

	father1Result = display.newImageRect(sceneGroup, "assets/imgs/pg5/father1Result.png", 422.8, 310.8)
	father1Result.x = 365
	father1Result.y = 720
	father1Result.isVisible = false

	father2Result = display.newImageRect(sceneGroup, "assets/imgs/pg5/father2Result.png", 422.8, 310.8)
	father2Result.x = 365
	father2Result.y = 720
	father2Result.isVisible = false

	father3Result = display.newImageRect(sceneGroup, "assets/imgs/pg5/father3Result.png", 422.8, 310.8)
	father3Result.x = 365
	father3Result.y = 720
	father3Result.isVisible = false

	father4Result = display.newImageRect(sceneGroup, "assets/imgs/pg5/father4Result.png", 422.8, 310.8)
	father4Result.x = 365
	father4Result.y = 720
	father4Result.isVisible = false

	backButton = display.newImageRect(sceneGroup, "assets/imgs/pg5/backButton.png", 93.1, 34.3)
	backButton.x = 600
	backButton.y = 730
	backButton.isVisible = false

    saveInitialPositions()

    addDragListeners(father1, father1Result)
    addDragListeners(father2, father2Result)
    addDragListeners(father3, father3Result)
    addDragListeners(father4, father4Result)

    backButton:addEventListener("tap", resetState)

	sceneGroup:insert( nextPageButton )
	sceneGroup:insert( previousPageButton )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

    pauseAllAudios()
	
	if phase == "will" then
	elseif phase == "did" then
        for i = 1, 32 do
            audio.setVolume(1.0, {channel = i})
        end

        audio.setVolume(1.0, {channel = 1})
        audio.play(contentAudio, {
            loops = 0,
            channel = 1,
            onComplete = playInstructionsAudio
        })

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
	
    audio.dispose(contentAudio)
    audio.dispose(instructionAudio)
    audio.dispose(isNotFatherAudio)
    audio.dispose(isTheFatherAudio)

    pauseAllAudios()
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
