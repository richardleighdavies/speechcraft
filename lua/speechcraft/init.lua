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
    opts = opts or {}  -- Ensure opts is a table

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

    -- Initialize content window
    if content_window and content_window.setup then
        content_window.setup(opts.content_window or {})
    else
        print("Warning: content_window module or setup function not available")
    end
end

-- Expose content window functions
M.open_content_window = function()
    if content_window and content_window.open then
        content_window.open()
    else
        print("Warning: open function not available in content_window module")
    end
end

M.close_content_window = function()
    if content_window and content_window.close then
        content_window.close()
    else
        print("Warning: close function not available in content_window module")
    end
end

M.toggle_content_window = function()
    if content_window and content_window.toggle then
        content_window.toggle()
    else
        print("Warning: toggle function not available in content_window module")
    end
end

M.set_content_window = function(content)
    if content_window and content_window.set_content then
        content_window.set_content(content)
    else
        print("Warning: set_content function not available in content_window module")
    end
end

M.add_content_window = function(content)
    if content_window and content_window.add_content then
        content_window.add_content(content)
    else
        print("Warning: add_content function not available in content_window module")
    end
end

M.clear_content_window = function()
    if content_window and content_window.clear_content then
        content_window.clear_content()
    else
        print("Warning: clear_content function not available in content_window module")
    end
end

function M.is_active()
    print("SpeechCraft is_active function called")
    return true
end

print("SpeechCraft module loaded, returning module table")

return M
