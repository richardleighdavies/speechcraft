local M = {}
local config = require("plugins.speechcraft.lua.speechcraft.config")

local function activate_speech(start_listening)
    -- Placeholder for speech recognition activation logic
    print("Speech recognition activated")
    start_listening()
end

function M.setup(speech_recognition)
    vim.keymap.set("n", config.options.activation_key, function()
        activate_speech(speech_recognition.start_listening)
    end, { desc = "Activate SpeechCraft" })
end

function M.process_command(command, text)
    if command == "delete" then
        -- TODO: Implement delete logic
    elseif command:match("^replace with") then
        -- TODO: Implement replace logic
    elseif command == "copy" then
        -- TODO: Implement copy logic
    elseif command == "comment out" then
        -- TODO: Implement comment out logic
    else
        print("Unknown command: " .. command)
    end
end

return M
