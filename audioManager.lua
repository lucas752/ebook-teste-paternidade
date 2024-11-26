local M = {}

M.isMuted = false

function M.toggleAudio()
    M.isMuted = not M.isMuted

    if M.isMuted then
        audio.setVolume(0)
    else
        audio.setVolume(1)
    end
end

function M.getAudioState()
    return M.isMuted
end

return M
