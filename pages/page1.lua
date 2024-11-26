-----------------------------------------------------------------------------------------
-- 
-- page1.lua
-- 
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()

local background, nextPageButton, previousPageButton, contentText, instructionText, textBackground, titleText, pageNumber
local moreDnaButton, dnaPrecisionButton, dnaPrecisionBox, moreDnaBox, dnaPrecisionClose, moreDnaClose
local contentAudio, instructionsAudio, dnaDefinitionAudio, testAccuracyAudio

local function pauseAllAudios()
    for i = 1, 32 do
        audio.stop(i)
        audio.setVolume(1.0, {channel = i})
    end
end

local function onNextPageButtonTouch(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("pages.page2", "slideLeft", 800)
        return true
    end
end

local function onPreviousPageButtonTouch(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("pages.cover", "slideRight", 800)
        return true
    end
end

local function onMoreDnaButtonTouch(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        dnaPrecisionBox.isVisible = false
        dnaPrecisionClose.isVisible = false
        moreDnaBox.isVisible = true
        moreDnaClose.isVisible = true

        pauseAllAudios()
        audio.play(dnaDefinitionAudio, {loops = 0, channel = 3, fadein = 500})
    end
    return true
end

local function onMoreDnaCloseTouch(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        moreDnaBox.isVisible = false
        moreDnaClose.isVisible = false

        pauseAllAudios()
    end
    return true
end

local function onDnaPrecisionButtonTouch(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        moreDnaBox.isVisible = false
        moreDnaClose.isVisible = false
        dnaPrecisionBox.isVisible = true
        dnaPrecisionClose.isVisible = true

        pauseAllAudios()
        audio.play(testAccuracyAudio, {loops = 0, channel = 4, fadein = 500})
    end
    return true
end

local function onDnaPrecisionCloseTouch(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        dnaPrecisionBox.isVisible = false
        dnaPrecisionClose.isVisible = false

        audio.stop(4)
    end
    return true
end

local function playInstructionsAudio()
    if not audio.isChannelActive(3) and not audio.isChannelActive(4) and composer.getSceneName("current") == "pages.page1" then
        audio.play(instructionsAudio, {loops = 0, channel = 2, fadein = 500})
    end
end

function scene:create(event)
    local sceneGroup = self.view

    contentAudio = audio.loadStream("assets/sounds/pg1/content.mp3")
    instructionsAudio = audio.loadStream("assets/sounds/pg1/instructions.mp3")
    dnaDefinitionAudio = audio.loadStream("assets/sounds/pg1/dnaDefinition.mp3")
    testAccuracyAudio = audio.loadStream("assets/sounds/pg1/testAccuracy.mp3")

    background = display.newImageRect(sceneGroup, "assets/imgs/pageContentBg.png", display.contentWidth, display.contentHeight)
    background.anchorX = 0
    background.anchorY = 0
    background.x = 0
    background.y = 0

    nextPageButton = display.newImageRect(sceneGroup, "assets/imgs/nextpagebutton.png", 87, 107)
    nextPageButton.x = 670
    nextPageButton.y = 950

    previousPageButton = display.newImageRect(sceneGroup, "assets/imgs/previousPageButton.png", 87, 100)
    previousPageButton.x = 90
    previousPageButton.y = 944

    textBackground = display.newImageRect(sceneGroup, "assets/imgs/textBackground.png", display.contentWidth, 580)
    textBackground.anchorX = 0.5
    textBackground.anchorY = 0.5
    textBackground.x = display.contentCenterX
    textBackground.y = 590

    titleText = display.newText(sceneGroup, "O que é teste de paternidade?", display.contentCenterX, 210, "assets/fonts/ComicNeue-Bold.ttf", 48)
    titleText:setFillColor(0.165, 0.267, 0.365)

    instructionText = display.newText({
        parent = sceneGroup,
        text = "Clique nos botões para saber mais",
        x = display.contentCenterX,
        y = 58,
        width = 257,
        font = "assets/fonts/ComicNeue-Bold.ttf",
        fontSize = 25,
        align = "center"
    })
    instructionText:setFillColor(1, 1, 1)

    pageNumber = display.newText({
        parent = sceneGroup,
        text = "Página 1",
        x = 80,
        y = 58,
        font = "assets/fonts/ComicNeue-Bold.ttf",
        fontSize = 25,
    })
    pageNumber:setFillColor(0.165, 0.267, 0.365)

    contentText = display.newText({
        parent = sceneGroup,
        text = "O teste de paternidade é uma análise laboratorial que verifica a relação biológica entre um suposto pai e uma criança. Através da comparação de amostras de DNA, é possível determinar com alta precisão se um homem é ou não o pai biológico da criança. Este exame é amplamente utilizado em disputas judiciais, questões familiares e até mesmo em contextos médicos.",
        x = display.contentCenterX,
        y = 530,
        width = 689,
        font = "assets/fonts/ComicNeue-Bold.ttf",
        fontSize = 32,
        align = "left"
    })
    contentText:setFillColor(0.165, 0.267, 0.365)

    moreDnaButton = display.newImageRect(sceneGroup, "assets/imgs/pg1/moreDnaButton.png", 205, 41)
    moreDnaButton.x = display.contentCenterX
    moreDnaButton.y = 750

    dnaPrecisionButton = display.newImageRect(sceneGroup, "assets/imgs/pg1/dnaPrecisionButton.png", 205, 41)
    dnaPrecisionButton.x = display.contentCenterX
    dnaPrecisionButton.y = 807

    moreDnaBox = display.newImageRect(sceneGroup, "assets/imgs/pg1/moreDnaBox.png", 385.84, 229.6)
    moreDnaBox.x = display.contentCenterX
    moreDnaBox.y = 890
    moreDnaBox.isVisible = false

    dnaPrecisionBox = display.newImageRect(sceneGroup, "assets/imgs/pg1/dnaPrecisionBox.png", 385.84, 159.6)
    dnaPrecisionBox.x = display.contentCenterX
    dnaPrecisionBox.y = 910
    dnaPrecisionBox.isVisible = false

    moreDnaClose = display.newImageRect(sceneGroup, "assets/imgs/pg1/closeRedButton.png", 26.36, 23.33)
    moreDnaClose.x = 538
    moreDnaClose.y = 800
    moreDnaClose.isVisible = false

    dnaPrecisionClose = display.newImageRect(sceneGroup, "assets/imgs/pg1/closeRedButton.png", 26.36, 23.33)
    dnaPrecisionClose.x = 538
    dnaPrecisionClose.y = 850
    dnaPrecisionClose.isVisible = false

    sceneGroup:insert(nextPageButton)
    sceneGroup:insert(previousPageButton)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        moreDnaButton:addEventListener("touch", onMoreDnaButtonTouch)
        moreDnaClose:addEventListener("touch", onMoreDnaCloseTouch)
        dnaPrecisionButton:addEventListener("touch", onDnaPrecisionButtonTouch)
        dnaPrecisionClose:addEventListener("touch", onDnaPrecisionCloseTouch)

        pauseAllAudios()

    elseif phase == "did" then
        audio.play(contentAudio, {
            loops = 0,
            channel = 1,
            fadein = 500,
            onComplete = playInstructionsAudio
        })

        nextPageButton.touch = onNextPageButtonTouch
        nextPageButton:addEventListener("touch", nextPageButton)

        previousPageButton.touch = onPreviousPageButtonTouch
        previousPageButton:addEventListener("touch", previousPageButton)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        moreDnaButton:removeEventListener("touch", onMoreDnaButtonTouch)
        moreDnaClose:removeEventListener("touch", onMoreDnaCloseTouch)
        dnaPrecisionButton:removeEventListener("touch", onDnaPrecisionButtonTouch)
        dnaPrecisionClose:removeEventListener("touch", onDnaPrecisionCloseTouch)

        nextPageButton:removeEventListener("touch", nextPageButton)
        previousPageButton:removeEventListener("touch", previousPageButton)

        pauseAllAudios()
    end
end

function scene:destroy(event)
    local sceneGroup = self.view

    audio.dispose(contentAudio)
    audio.dispose(instructionsAudio)
    audio.dispose(dnaDefinitionAudio)
    audio.dispose(testAccuracyAudio)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
