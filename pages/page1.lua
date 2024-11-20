-----------------------------------------------------------------------------------------
-- 
-- page1.lua
-- 
-----------------------------------------------------------------------------------------

local composer = require("composer")
local scene = composer.newScene()

local background, nextPageButton, previousPageButton, contentText, instructionText, textBackground, titleText
local moreDnaButton, dnaPrecisionButton, dnaPrecisionBox, moreDnaBox, dnaPrecisionClose, moreDnaClose

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
    end
    return true
end

local function onMoreDnaCloseTouch(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        moreDnaBox.isVisible = false
        moreDnaClose.isVisible = false
    end
    return true
end

local function onDnaPrecisionButtonTouch(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        moreDnaBox.isVisible = false
        moreDnaClose.isVisible = false

        dnaPrecisionBox.isVisible = true
        dnaPrecisionClose.isVisible = true
    end
    return true
end

local function onDnaPrecisionCloseTouch(event)
    if event.phase == "ended" or event.phase == "cancelled" then
        dnaPrecisionBox.isVisible = false
        dnaPrecisionClose.isVisible = false
    end
    return true
end

function scene:create(event)
    local sceneGroup = self.view

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

    elseif phase == "did" then
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
    end
end

function scene:destroy(event)
    local sceneGroup = self.view
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene
