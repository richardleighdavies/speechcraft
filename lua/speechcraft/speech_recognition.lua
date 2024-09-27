local M = {}

local config = require("plugins.speechcraft.lua.speechcraft.config")

function M.init(commands)
    -- Placeholder for speech recognition initialization
    print("Initializing speech recognition backend: " .. config.options.speech_recognition_backend)
    -- TODO: Implement actual speech recognition initialization
    M.commands = commands
end

function M.start_listening()
    -- Placeholder for starting speech recognition
    print("Starting speech recognition")
    -- TODO: Implement actual speech recognition start
end

function M.stop_listening()
    -- Placeholder for stopping speech recognition
    print("Stopping speech recognition")
    -- TODO: Implement actual speech recognition stop
end

function M.on_speech_recognized(text)
    if M.commands then
        M.commands.process_command(text, vim.fn.expand("<cword>"))
    else
        print("Error: commands module not initialized")
    end
end

return M
