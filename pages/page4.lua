-----------------------------------------------------------------------------------------
-- 
-- page4.lua
-- 
-----------------------------------------------------------------------------------------

local composer = require("composer")
local audioManager = require("audioManager")
local scene = composer.newScene()

local background, nextPageButton, previousPageButton, contentText, instructionText, titleText, textBackground, extractionDevice, deviceScreen, selectedOptionDenaturation, selectedOptionExtension, selectedOptionGirdling, mockupOption1, mockupOption2, mockupOption3, denaturationContent, girdlingContent, extensionContent, pageNumber
local contentAudio, instructions1Audio, denaturationAudio, extensionAudio, girdlingAudio
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

system.activate("multitouch")

local finger1, finger2
local initialDistance
local isZooming = false

local function calculateDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

local function updateElementsVisibility()
    local shouldShow = deviceScreen.isVisible

    selectedOptionDenaturation.isVisible = shouldShow
    selectedOptionExtension.isVisible = false
    selectedOptionGirdling.isVisible = false

    denaturationContent.isVisible = shouldShow
    girdlingContent.isVisible = false
    extensionContent.isVisible = false
end

local function pauseAllAudios()
    for i = 1, 32 do
        audio.stop(i)
        audio.setVolume(1.0, {channel = i})
    end
end

local function onTouch(event)
    if event.phase == "began" then
        if not finger1 then
            finger1 = event
        elseif not finger2 then
            finger2 = event
            isZooming = true
            initialDistance = calculateDistance(finger1.x, finger1.y, finger2.x, finger2.y)
        end
    elseif event.phase == "moved" and isZooming then
        if finger1 and finger2 then
            if event.id == finger1.id then
                finger1 = event
            elseif event.id == finger2.id then
                finger2 = event
            end

            if finger1 and finger2 then
                local currentDistance = calculateDistance(finger1.x, finger1.y, finger2.x, finger2.y)
                local scale = currentDistance / initialDistance

                extractionDevice.width = extractionDevice.width * scale
                extractionDevice.height = extractionDevice.height * scale

                initialDistance = currentDistance
            end
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        if finger1 and event.id == finger1.id then
            finger1 = nil
        elseif finger2 and event.id == finger2.id then
            finger2 = nil
        end

        if not finger1 or not finger2 then
            isZooming = false
        end

        if extractionDevice.width > 500 then
            extractionDevice.isVisible = false
            deviceScreen.isVisible = true

            pauseAllAudios()
            audio.setVolume(1.0, {channel = 3})
            audio.play(denaturationAudio, {loops = 0, channel = 3})
            updateElementsVisibility()
        end
    end
    return true
end

local function onNextPageButtonTouch(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        pauseAllAudios()
        composer.gotoScene("pages.page5", {effect = "slideLeft", time = 800})
        return true
    end
end

local function onPreviousPageButtonTouch(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        pauseAllAudios()
        composer.gotoScene("pages.page3", {effect = "slideRight", time = 800})
        return true
    end
end

local function updateSelectedOption(selectedOption)
    selectedOptionDenaturation.isVisible = false
    selectedOptionExtension.isVisible = false
    selectedOptionGirdling.isVisible = false

    selectedOption.isVisible = true
end

local function updateContent(selectedContent)
    denaturationContent.isVisible = false
    girdlingContent.isVisible = false
    extensionContent.isVisible = false

    selectedContent.isVisible = true
end

local function onMockupOption1Touch(event)
    if event.phase == "ended" then
        updateSelectedOption(selectedOptionDenaturation)
        updateContent(denaturationContent)
        pauseAllAudios()
        audio.setVolume(1.0, {channel = 3})
        audio.play(denaturationAudio, {loops = 0, channel = 3})
    end
    return true
end

local function onMockupOption2Touch(event)
    if event.phase == "ended" then
        updateSelectedOption(selectedOptionGirdling)
        updateContent(girdlingContent)
        pauseAllAudios()
        audio.setVolume(1.0, {channel = 4})
        audio.play(girdlingAudio, {loops = 0, channel = 4})
    end
    return true
end

local function onMockupOption3Touch(event)
    if event.phase == "ended" then
        updateSelectedOption(selectedOptionExtension)
        updateContent(extensionContent)
        pauseAllAudios()
        audio.setVolume(1.0, {channel = 4})
        audio.play(extensionAudio, {loops = 0, channel = 4})
    end
    return true
end

function scene:create(event)
    local sceneGroup = self.view

    contentAudio = audio.loadStream("assets/sounds/pg4/content.mp3")
    instructions1Audio = audio.loadStream("assets/sounds/pg4/instructions1.mp3")
    denaturationAudio = audio.loadStream("assets/sounds/pg4/denaturation.mp3")
    extensionAudio = audio.loadStream("assets/sounds/pg4/extension.mp3")
    girdlingAudio = audio.loadStream("assets/sounds/pg4/girdling.mp3")

    background = display.newImageRect(sceneGroup, "assets/imgs/pageContentBg.png", display.contentWidth, display.contentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0

    nextPageButton = display.newImageRect(sceneGroup, "assets/imgs/nextpagebutton.png", 87, 107)
    nextPageButton.x = 670
    nextPageButton.y = 950

    previousPageButton = display.newImageRect(sceneGroup, "assets/imgs/previousPageButton.png", 87, 100)
    previousPageButton.x = 90
    previousPageButton.y = 944

    instructionText = display.newText({
        parent = sceneGroup,
        text = "Faça o movimento de pinça com 2 dedos na máquina para ver o DNA sendo ampliado",
        x = display.contentCenterX,
        y = 58,
        width = 300,
        font = "assets/fonts/ComicNeue-Bold.ttf",
        fontSize = 22,
        align = "center"
    })
    instructionText:setFillColor(1, 1, 1)

    titleText = display.newText(sceneGroup, "Amplificação do DNA", display.contentCenterX, 210, "ComicNeue-Regular", 50)
    titleText:setFillColor(0.165, 0.267, 0.365)

    textBackground = display.newImageRect(sceneGroup, "assets/imgs/textBackground.png", display.contentWidth, 580)
    textBackground.anchorX = 0.5
    textBackground.anchorY = 0.5
    textBackground.x = display.contentCenterX
    textBackground.y = 590

    contentText = display.newText({
        parent = sceneGroup,
        text = "No laboratório, o DNA coletado é amplificado através da Reação em Cadeia da Polimerase (PCR), para que haja quantidade suficiente de material genético para análise. A amplificação é essencial para a precisão do teste de paternidade. O DNA é colocado em uma máquina para realizar este processo.",
        x = display.contentCenterX,
        y = 490,
        width = 689,
        font = "assets/fonts/ComicNeue-Bold.ttf",
        fontSize = 32,
        align = "left"
    })
    contentText:setFillColor(0.165, 0.267, 0.365)

    pageNumber = display.newText({
        parent = sceneGroup,
        text = "Página 4",
        x = 80,
        y = 58,
        font = "assets/fonts/ComicNeue-Bold.ttf",
        fontSize = 25,
    })
    pageNumber:setFillColor(0.165, 0.267, 0.365)

    extractionDevice = display.newImageRect(sceneGroup, "assets/imgs/pg4/extractionDevice.png", 361.9, 324.1)
    extractionDevice.x = display.contentCenterX
    extractionDevice.y = 770

    deviceScreen = display.newImageRect(sceneGroup, "assets/imgs/pg4/deviceScreen.png", 554.47, 437.92)
    deviceScreen.x = display.contentCenterX
    deviceScreen.y = 600
    deviceScreen.isVisible = false

    selectedOptionDenaturation = display.newImageRect(sceneGroup, "assets/imgs/pg4/selectedOptionDenaturation.png", 362.02, 57.28)
    selectedOptionDenaturation.x = display.contentCenterX
    selectedOptionDenaturation.y = 460
    selectedOptionDenaturation.isVisible = false

    selectedOptionExtension = display.newImageRect(sceneGroup, "assets/imgs/pg4/selectedOptionExtension.png", 362.02, 57.28)
    selectedOptionExtension.x = display.contentCenterX
    selectedOptionExtension.y = 460
    selectedOptionExtension.isVisible = false

    selectedOptionGirdling = display.newImageRect(sceneGroup, "assets/imgs/pg4/selectedOptiongGirdling.png", 362.02, 57.28)
    selectedOptionGirdling.x = display.contentCenterX
    selectedOptionGirdling.y = 460
    selectedOptionGirdling.isVisible = false
    
    mockupOption1 = display.newImageRect(sceneGroup, "assets/imgs/pg4/mockupOption.png", 121.1, 49.7)
    mockupOption1.x = 265
    mockupOption1.y = 456
    mockupOption1.isVisible = false
    mockupOption1.isHitTestable = true

    mockupOption2 = display.newImageRect(sceneGroup, "assets/imgs/pg4/mockupOption.png", 121.1, 49.7)
    mockupOption2.x = display.contentCenterX
    mockupOption2.y = 456
    mockupOption2.isVisible = false
    mockupOption2.isHitTestable = true

    mockupOption3 = display.newImageRect(sceneGroup, "assets/imgs/pg4/mockupOption.png", 121.1, 49.7)
    mockupOption3.x = 504
    mockupOption3.y = 456
    mockupOption3.isVisible = false
    mockupOption3.isHitTestable = true

    denaturationContent = display.newImageRect(sceneGroup, "assets/imgs/pg4/denaturationContent.png", 439.6, 231)
    denaturationContent.x = display.contentCenterX
    denaturationContent.y = 620
    denaturationContent.isVisible = false
    
    girdlingContent = display.newImageRect(sceneGroup, "assets/imgs/pg4/girdlingContent.png", 361.6, 227.1)
    girdlingContent.x = display.contentCenterX
    girdlingContent.y = 620
    girdlingContent.isVisible = false

    audioButton = display.newImageRect(sceneGroup, "assets/imgs/audioOn.png", 87, 108)
    audioButton.x = 670
    audioButton.y = 80
    audioButton:addEventListener("touch", onAudioButtonTouch)

    updateAudioButton()

    extensionContent = display.newImageRect(sceneGroup, "assets/imgs/pg4/extensionContent.png", 360.3, 267.6)
    extensionContent.x = display.contentCenterX
    extensionContent.y = 620
    extensionContent.isVisible = false
    
    sceneGroup:insert( audioButton )

    nextPageButton:addEventListener("touch", onNextPageButtonTouch)
    previousPageButton:addEventListener("touch", onPreviousPageButtonTouch)
    mockupOption1:addEventListener("touch", onMockupOption1Touch)
    mockupOption2:addEventListener("touch", onMockupOption2Touch)
    mockupOption3:addEventListener("touch", onMockupOption3Touch)

end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "did" then
        for i = 1, 32 do
            audio.setVolume(1.0, {channel = i})
        end

        local function playInstructionsAudio()
            if composer.getSceneName("current") == "pages.page2" then
                audio.setVolume(1.0, {channel = 2})
                audio.play(instructions1Audio, {loops = 0, channel = 2})
            end
        end

        audio.setVolume(1.0, {channel = 1})
        audio.play(contentAudio, {
            loops = 0,
            channel = 1,
            onComplete = playInstructionsAudio
        })

        updateAudioButton()

        Runtime:addEventListener("touch", onTouch)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        Runtime:removeEventListener("touch", onTouch)
    end
end

function scene:destroy(event)
    local sceneGroup = self.view

    audio.dispose(contentAudio)
    audio.dispose(instructions1Audio)
    audio.dispose(denaturationAudio)
    audio.dispose(extensionAudio)
    audio.dispose(girdlingAudio)

    pauseAllAudios()
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
