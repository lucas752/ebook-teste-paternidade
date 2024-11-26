local composer = require("composer")
local audioManager = require("audioManager")
local scene = composer.newScene()

local background, nextPageButton, previousPageButton, contentText, instructionText, textBackground, titleText, sampleDna, dnaDetergent, animationStartButton, alcoholPipette, nextAnimationButton, dnaReagent, extractedDna, pageNumber
local contentAudio, instructions1Audio, instructions2Audio, instructions3Audio, instructions4Audio
local audioButton
local isAnimationActive = false

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

local animationStage = 0

local function onNextPageButtonTouch(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("pages.page4", "slideLeft", 800)
        return true
    end
end

local function onPreviousPageButtonTouch(self, event)
    if event.phase == "ended" or event.phase == "cancelled" then
        composer.gotoScene("pages.page2", "slideRight", 800)
        return true
    end
end

local function pauseAllAudios()
    audio.stop(1)
    audio.stop(2)
    audio.stop(3)
    audio.stop(4)
    audio.stop(5)
end

local function onAnimationStartButtonTouch(event)
    if event.phase == "ended" then
        isAnimationActive = true
        transition.to(animationStartButton, {
            alpha = 0,
            time = 500
        })

        transition.to(dnaDetergent, {
            x = sampleDna.x,
            y = sampleDna.y,
            time = 1000,
            onComplete = function()
                transition.to(dnaDetergent, {
                    alpha = 0,
                    time = 500,
                    onComplete = function()
                        instructionText.text = "O álcool é adicionado na amostra com a pipeta para separar o DNA das outras substâncias"
                        instructionText.size = 20
                        nextAnimationButton.isVisible = true
                        alcoholPipette.isVisible = true
                        animationStage = 1
                        pauseAllAudios()
                        audio.play(instructions2Audio, {loops = 0, channel = 3, fadein = 500})
                    end
                })
            end
        })
    end
    return true
end

local function onNextAnimationButtonTouch(event)
    if event.phase == "ended" then
        transition.to(nextAnimationButton, {
            alpha = 0,
            time = 500,
            onComplete = function()
                nextAnimationButton.isVisible = false
            end
        })

        if animationStage == 1 then
            transition.to(alcoholPipette, {
                x = sampleDna.x,
                y = sampleDna.y,
                time = 1000,
                onComplete = function()
                    transition.to(alcoholPipette, {
                        alpha = 0,
                        time = 500,
                        onComplete = function()
                            alcoholPipette.isVisible = false
                            alcoholPipette.alpha = 1

                            instructionText.text = "É adicionado uma solução ao DNA para que ele seja dissolvido e utilizado no teste"
                            nextAnimationButton.isVisible = true
                            nextAnimationButton.alpha = 1
                            dnaReagent.isVisible = true
                            animationStage = 2
                            pauseAllAudios()
                            audio.play(instructions3Audio, {loops = 0, channel = 4, fadein = 500})
                        end
                    })
                end
            })
        elseif animationStage == 2 then
            transition.to(dnaReagent, {
                x = sampleDna.x,
                y = sampleDna.y,
                time = 1000,
                onComplete = function()
                    transition.to(dnaReagent, {
                        alpha = 0,
                        time = 500,
                        onComplete = function()
                            dnaReagent.isVisible = false
                            dnaReagent.alpha = 1

                            transition.to(sampleDna, {
                                x = display.contentCenterX,
                                y = 770,
                                time = 1000,
                                onComplete = function()
                                    animationStage = 3
                                end
                            })

                            instructionText.text = "Agite o dispositivo para misturar a solução e liberar o DNA purificado"
                            instructionText.size = 25
                            
                            pauseAllAudios()
                            audio.play(instructions4Audio, {loops = 0, channel = 5, fadein = 500})
                        end
                    })
                end
            })
        end
    end
    return true
end

local function onShake(event)
    if animationStage == 3 then
        transition.to(sampleDna, {
            alpha = 0,
            time = 500,
            onComplete = function()
                sampleDna.isVisible = false

                extractedDna.alpha = 0
                extractedDna.isVisible = true
                transition.to(extractedDna, {
                    alpha = 1,
                    time = 500
                })
            end
        })

        animationStage = 4
    end
end

function scene:create(event)
    local sceneGroup = self.view
    
    contentAudio = audio.loadStream("assets/sounds/pg3/content.mp3")
    instructions1Audio = audio.loadStream("assets/sounds/pg3/instructions1.mp3")
    instructions2Audio = audio.loadStream("assets/sounds/pg3/instructions2.mp3")
    instructions3Audio = audio.loadStream("assets/sounds/pg3/instructions3.mp3")
    instructions4Audio = audio.loadStream("assets/sounds/pg3/instructions4.mp3")

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
        text = "O detergente é adicionado à amostra para quebrar as paredes das células",
        x = display.contentCenterX,
        y = 58,
        width = 300,
        font = "assets/fonts/ComicNeue-Bold.ttf",
        fontSize = 25,
        align = "center"
    })
    instructionText:setFillColor(1, 1, 1)

    titleText = display.newText(sceneGroup, "Extração do DNA", display.contentCenterX, 210, "assets/fonts/ComicNeue-Bold.ttf", 48)
    titleText:setFillColor(0.165, 0.267, 0.365)

    textBackground = display.newImageRect(sceneGroup, "assets/imgs/textBackground.png", display.contentWidth, 580)
    textBackground.anchorX = 0.5
    textBackground.anchorY = 0.5
    textBackground.x = display.contentCenterX
    textBackground.y = 590

    contentText = display.newText({
        parent = sceneGroup,
        text = "Depois da coleta, as amostras são enviadas ao laboratório, onde o DNA é extraído das células. Esse processo envolve a quebra das células para liberar o material genético que será utilizado na análise. A qualidade do DNA extraído é essencial para garantir a precisão do teste.",
        x = display.contentCenterX,
        y = 480,
        width = 689,
        font = "assets/fonts/ComicNeue-Bold.ttf",
        fontSize = 32,
        align = "left"
    })
    contentText:setFillColor(0.165, 0.267, 0.365)

    pageNumber = display.newText({
        parent = sceneGroup,
        text = "Página 3",
        x = 80,
        y = 58,
        font = "assets/fonts/ComicNeue-Bold.ttf",
        fontSize = 25,
    })
    pageNumber:setFillColor(0.165, 0.267, 0.365)

    audioButton = display.newImageRect(sceneGroup, "assets/imgs/audioOn.png", 87, 108)
    audioButton.x = 670
    audioButton.y = 80
    audioButton:addEventListener("touch", onAudioButtonTouch)

    updateAudioButton()

    sampleDna = display.newImageRect(sceneGroup, "assets/imgs/pg3/sampleDna.png", 116.9, 213.5)
    sampleDna.x = 180
    sampleDna.y = 770

    dnaDetergent = display.newImageRect(sceneGroup, "assets/imgs/pg3/dnaDetergent.png", 152.6, 170.1)
    dnaDetergent.x = 575
    dnaDetergent.y = 770

    animationStartButton = display.newImageRect(sceneGroup, "assets/imgs/pg3/animationStartButton.png", 195.3, 38.5)
    animationStartButton.x = display.contentCenterX
    animationStartButton.y = 660

    nextAnimationButton = display.newImageRect(sceneGroup, "assets/imgs/pg3/nextAnimationButton.png", 195.3, 38.5)
    nextAnimationButton.x = display.contentCenterX
    nextAnimationButton.y = 660
    nextAnimationButton.isVisible = false

    alcoholPipette = display.newImageRect(sceneGroup, "assets/imgs/pg3/alcoholPipette.png", 184.1, 242.9)
    alcoholPipette.x = 575
    alcoholPipette.y = 750
    alcoholPipette.isVisible = false

    dnaReagent = display.newImageRect(sceneGroup, "assets/imgs/pg3/dnaReagent.png", 239.4, 249.2)
    dnaReagent.x = 575
    dnaReagent.y = 750
    dnaReagent.isVisible = false

    extractedDna = display.newImageRect(sceneGroup, "assets/imgs/pg3/extractedDna.png", 199.5, 216.3)
    extractedDna.x = display.contentCenterX
    extractedDna.y = 770
    extractedDna.isVisible = false

    animationStartButton:addEventListener("touch", onAnimationStartButtonTouch)
    nextAnimationButton:addEventListener("touch", onNextAnimationButtonTouch)

    sceneGroup:insert(nextPageButton)
    sceneGroup:insert(previousPageButton)
    sceneGroup:insert( audioButton )
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
    elseif phase == "did" then
        local function playInstructionsAudio()
            if composer.getSceneName("current") == "pages.page3" and not isAnimationActive then
                audio.play(instructions1Audio, {loops = 0, channel = 2, fadein = 500})
            end
        end

        audio.play(contentAudio, {
            loops = 0,
            channel = 1,
            fadein = 500,
            onComplete = playInstructionsAudio
        })

        updateAudioButton()

        nextPageButton.touch = onNextPageButtonTouch
        nextPageButton:addEventListener("touch", nextPageButton)

        previousPageButton.touch = onPreviousPageButtonTouch
        previousPageButton:addEventListener("touch", previousPageButton)

        Runtime:addEventListener("accelerometer", onShake)
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
        nextPageButton:removeEventListener("touch", nextPageButton)
        previousPageButton:removeEventListener("touch", previousPageButton)
        animationStartButton:removeEventListener("touch", onAnimationStartButtonTouch)
        nextAnimationButton:removeEventListener("touch", onNextAnimationButtonTouch)

        Runtime:removeEventListener("accelerometer", onShake)

        for i = 1, 32 do
            if audio.isChannelActive(i) then
                audio.stop(i)
            end
        end

        if contentAudio then
            audio.dispose(contentAudio)
            contentAudio = nil
        end

        if instructions1Audio then
            audio.dispose(instructions1Audio)
            instructions1Audio = nil
        end

        if instructions2Audio then
            audio.dispose(instructions2Audio)
            instructions2Audio = nil
        end

        if instructions3Audio then
            audio.dispose(instructions3Audio)
            instructions3Audio = nil
        end

        if instructions4Audio then
            audio.dispose(instructions4Audio)
            instructions4Audio = nil
        end
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
