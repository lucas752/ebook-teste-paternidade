local physics = require("physics")
physics.start()
physics.setGravity(0, 9.8)

local composer = require("composer")
local scene = composer.newScene()

local background, nextPageButton, previousPageButton, titleText, contentText, instructionText, textBackground, cottonSwab1, personMouthOpen, messageText
local contentAudio, instructionsAudio

local function pauseAllAudios()
    audio.stop(1)
    audio.stop(2)
end

local function onNextPageButtonTouch(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        if messageText then
            messageText.isVisible = false;
        end
        composer.gotoScene("pages.page3", "slideLeft", 800)
        return true
    end
end

local function onPreviousPageButtonTouch(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("pages.page1", "slideRight", 800)
        return true
    end
end

local function onCottonSwabTouch(event)
    local target = event.target

    local bottomLimit = display.contentHeight - 125

    if event.phase == "began" then
        target.bodyType = "kinematic"
        display.currentStage:setFocus(target)
        target.isFocus = true

        target.touchOffsetX = event.x - target.x
        target.touchOffsetY = event.y - target.y

    elseif event.phase == "moved" and target.isFocus then
        local newX = event.x - target.touchOffsetX
        local newY = event.y - target.touchOffsetY

        if newY <= bottomLimit then
            target.x = newX
            target.y = newY

            local dx = target.x - personMouthOpen.x
            local dy = target.y - personMouthOpen.y
            local distance = math.sqrt(dx * dx + dy * dy)

            local contactThreshold = 100
            if distance < contactThreshold then
                cottonSwab1.fill = { type = "image", filename = "assets/imgs/pg2/cottonSwab2.png" }
                if not messageText then
                    messageText = display.newText({
                        text = "Amostra coletada",
                        x = 570,
                        y = 860,
                        font = "assets/fonts/ComicNeue-Bold.ttf",
                        fontSize = 40,
                        align = "center"
                    })
                    messageText:setFillColor(0.165, 0.267, 0.365)
                end
            end
        end

    elseif event.phase == "ended" or event.phase == "cancelled" then
        if target.isFocus then
            display.currentStage:setFocus(nil)
            target.isFocus = false
            target.bodyType = "dynamic"
        end
    end
    return true
end

local function onCollision(event)
    if event.phase == "began" then
        if (event.object1 == cottonSwab1 and event.object2 == personMouthOpen) or 
           (event.object1 == personMouthOpen and event.object2 == cottonSwab1) then
            cottonSwab1.fill = { type = "image", filename = "assets/imgs/pg2/cottonSwab2.png" }
        end
    end
end

function scene:create(event)
    local sceneGroup = self.view

    contentAudio = audio.loadStream("assets/sounds/pg2/content.mp3")
    instructionsAudio = audio.loadStream("assets/sounds/pg2/instructions.mp3")

    local screenBounds = {
        top = display.newRect(sceneGroup, display.contentCenterX, -5, display.contentWidth, 10),
        bottom = display.newRect(sceneGroup, display.contentCenterX, display.contentHeight - 125, display.contentWidth, 10),
        left = display.newRect(sceneGroup, -5, display.contentCenterY, 10, display.contentHeight),
        right = display.newRect(sceneGroup, display.contentWidth + 5, display.contentCenterY, 10, display.contentHeight)
    }

    for _, bound in pairs(screenBounds) do
        bound.isVisible = false
        physics.addBody(bound, "static", { bounce = 0.1 })
    end

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

    textBackground = display.newImageRect(sceneGroup, "assets/imgs/textBackground.png", display.contentWidth, 580)
    textBackground.anchorX = 0.5
    textBackground.anchorY = 0.5
    textBackground.x = display.contentCenterX
    textBackground.y = 590

    titleText = display.newText(sceneGroup, "Coleta da amostra", display.contentCenterX, 210, "assets/fonts/ComicNeue-Bold.ttf", 48)
    titleText:setFillColor(0.165, 0.267, 0.365)

    instructionText = display.newText({
        parent = sceneGroup,
        text = "Arraste o cotonete para a boca do paciente e colete a amostra",
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
        text = "A primeira etapa do teste de paternidade é a coleta das amostras, essa amostra pode ser obtida através da saliva, sangue ou células da mucosa bucal (através de um cotonete).",
        x = display.contentCenterX,
        y = 440,
        width = 689,
        font = "assets/fonts/ComicNeue-Bold.ttf",
        fontSize = 32,
        align = "left"
    })
    contentText:setFillColor(0.165, 0.267, 0.365)

    personMouthOpen = display.newImageRect(sceneGroup, "assets/imgs/pg2/personMouthOpen.png", 225.4, 343)
    personMouthOpen.x = 150
    personMouthOpen.y = 710
    physics.addBody(personMouthOpen, "static", { isSensor = true })

    cottonSwab1 = display.newImageRect(sceneGroup, "assets/imgs/pg2/cottonSwab1.png", 246.4, 53.9)
    cottonSwab1.x = 600
    cottonSwab1.y = 865

    physics.addBody(cottonSwab1, "dynamic", { bounce = 0.3, density = 1.0 })
    cottonSwab1.bodyType = "kinematic"

    cottonSwab1:addEventListener("touch", onCottonSwabTouch)

    sceneGroup:insert(nextPageButton)
    sceneGroup:insert(previousPageButton)
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
    elseif phase == "did" then
        local function playInstructionsAudio()
            if composer.getSceneName("current") == "pages.page2" then
                audio.play(instructionsAudio, {loops = 0, channel = 2, fadein = 500})
            end
        end

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

        Runtime:addEventListener("collision", onCollision)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if event.phase == "will" then
        nextPageButton:removeEventListener("touch", nextPageButton)
        previousPageButton:removeEventListener("touch", previousPageButton)
        cottonSwab1:removeEventListener("touch", onCottonSwabTouch)
        Runtime:removeEventListener("collision", onCollision)

        pauseAllAudios()
    end
end

function scene:destroy(event)
    local sceneGroup = self.view

    audio.dispose(contentAudio)
    audio.dispose(instructionsAudio)
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)

return scene