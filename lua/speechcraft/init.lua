-- Inside lua/speechcraft/init.lua
local M = {}

print("SpeechCraft module loading...")

local function safe_require(module)
    local ok, result = pcall(require, module)
    if not ok then
        print("Error loading module: " .. module)
        print(result)
        return nil
    end
    return result
end

local config = safe_require("plugins.speechcraft.lua.speechcraft.config")
local commands = safe_require("plugins.speechcraft.lua.speechcraft.commands")
local speech_recognition = safe_require("plugins.speechcraft.lua.speechcraft.speech_recognition")
local panel = safe_require("plugins.speechcraft.lua.speechcraft.panel")

function M.setup(opts)
    print("SpeechCraft setup function called")

    if config and config.setup then
        config.setup(opts)
    else
        print("Warning: config module or setup function not available")
    end

    if speech_recognition and speech_recognition.init and commands then
        speech_recognition.init(commands)
    else
        print("Warning: speech_recognition module or init function not available")
    end

    if commands and commands.setup and speech_recognition then
        commands.setup(speech_recognition)
    else
        print("Warning: commands module or setup function not available")
    end

    -- Initialize panel (but do not show it immediately)
    if panel and panel.initialize_panel then
        panel.initialize_panel()
    else
        print("Warning: panel module or initialize_panel function not available")
    end
end

-- Expose panel functions
M.show_panel = panel.show_panel
M.hide_panel = panel.hide_panel
M.toggle_panel = panel.toggle_panel
M.focus_content = panel.focus_content
M.update_panel_content = panel.update_panel_content
M.load_markdown_from_file = panel.load_markdown_from_file

function M.clear_panel()
    if panel and panel.clear_panel then
        panel.clear_panel()
    else
        print("Warning: panel module or clear_panel function not available")
    end
end

function M.is_active()
    print("SpeechCraft is_active function called")
    return true
end

print("SpeechCraft module loaded, returning module table")

return M
