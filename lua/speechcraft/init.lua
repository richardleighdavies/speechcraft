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

local config = safe_require("speechcraft.config")
local commands = safe_require("speechcraft.commands")
local speech_recognition = safe_require("speechcraft.speech_recognition")
local content_window = safe_require("speechcraft.content_window")

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

    -- Initialize content window (but do not show it immediately)
    if content_window and content_window.setup then
        content_window.setup()
    else
        print("Warning: content_window module or setup function not available")
    end
end

-- Expose content window functions
M.show_content_window = function()
    if content_window and content_window.create_content_window then
        content_window.create_content_window()
    else
        print("Warning: create_content_window function not available")
    end
end

M.hide_content_window = function()
    if content_window and content_window.hide_content_window then
        content_window.hide_content_window()
    else
        print("Warning: hide_content_window function not available")
    end
end

M.toggle_content_window = function()
    if content_window and content_window.toggle_content_window then
        content_window.toggle_content_window()
    else
        print("Warning: toggle_content_window function not available")
    end
end

M.focus_content_window = function()
    if content_window and content_window.focus_content_window then
        content_window.focus_content_window()
    else
        print("Warning: focus_content_window function not available")
    end
end

M.update_content_window = function(content)
    if content_window and content_window.add_content then
        content_window.add_content(content)
    else
        print("Warning: add_content function not available")
    end
end

M.load_markdown_from_file = function(filepath)
    if content_window and content_window.load_markdown_from_file then
        content_window.load_markdown_from_file(filepath)
    else
        print("Warning: load_markdown_from_file function not available")
    end
end

M.clear_content_window = function()
    if content_window and content_window.clear_content then
        content_window.clear_content()
    else
        print("Warning: clear_content function not available")
    end
end

function M.is_active()
    print("SpeechCraft is_active function called")
    return true
end

print("SpeechCraft module loaded, returning module table")

return M
