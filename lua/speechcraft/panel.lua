local api = vim.api
local M = {}

local header_bufnr = nil
local content_bufnr = nil
local panel_winnr = nil
M.content_winnr = nil  -- Store the content window number here

-- Initialize the panel with separate buffers for header and contents
function M.initialize_panel()
    if not header_bufnr then
        -- Create the header buffer (unmodifiable)
        header_bufnr = api.nvim_create_buf(false, true)
        api.nvim_buf_set_option(header_bufnr, 'buftype', 'nofile')
        api.nvim_buf_set_option(header_bufnr, 'bufhidden', 'hide')
        api.nvim_buf_set_option(header_bufnr, 'swapfile', false)
        api.nvim_buf_set_option(header_bufnr, 'modifiable', false)

        -- Set the static heading content (centered title and separator)
        local width = api.nvim_get_option("columns")
        local panel_width = math.floor(width * 0.35)

        -- Centered title "Speech Craft"
        local title = "Speech Craft"
        local padding = string.rep(" ", math.floor((panel_width - #title) / 2))
        local centered_title = padding .. title

        -- Yellow line under the title
        local separator_line = string.rep("─", panel_width)

        -- Set the title and separator lines in the header buffer
        api.nvim_buf_set_option(header_bufnr, 'modifiable', true)
        api.nvim_buf_set_lines(header_bufnr, 0, -1, false, {centered_title, separator_line})
        api.nvim_buf_set_option(header_bufnr, 'modifiable', false)

        -- Apply highlights (for the title and the line)
        local ns_id = api.nvim_create_namespace("SpeechCraftTitle")
        api.nvim_buf_add_highlight(header_bufnr, ns_id, "SpeechCraftTitleBg", 0, 0, -1)
        api.nvim_buf_add_highlight(header_bufnr, ns_id, "SpeechCraftTitleLine", 1, 0, -1)

        -- Define highlight groups for title and line
        vim.cmd([[
            highlight SpeechCraftTitleBg guibg=Normal guifg=white
            highlight SpeechCraftTitleLine guifg=yellow
        ]])
    end

    if not content_bufnr then
        -- Create the content buffer (modifiable)
        content_bufnr = api.nvim_create_buf(false, true)
        api.nvim_buf_set_option(content_bufnr, 'buftype', 'nofile')
        api.nvim_buf_set_option(content_bufnr, 'bufhidden', 'hide')
        api.nvim_buf_set_option(content_bufnr, 'swapfile', false)
        api.nvim_buf_set_option(content_bufnr, 'filetype', 'markdown')
        api.nvim_buf_set_option(content_bufnr, 'modifiable', true)
    end
end

-- Show the panel with the header and contents sections
function M.show_panel()
    -- Initialize the panel if it doesn't exist
    M.initialize_panel()

    -- If the panel is already visible, do nothing
    if panel_winnr and api.nvim_win_is_valid(panel_winnr) then
        return
    end

    -- Get the current editor dimensions
    local width = api.nvim_get_option("columns")
    local height = api.nvim_get_option("lines")

    -- Calculate the width of the panel window (35% of the total width)
    local panel_width = math.floor(width * 0.35)

    -- Open a window for the header (top portion)
    local header_opts = {
        relative = 'editor',
        width = panel_width,
        height = 3,  -- Fixed height for header (title + separator)
        col = width - panel_width,  -- Position it at the far right
        row = 0,
        anchor = 'NW',
        style = 'minimal',
        border = {'', '', '', '│', '', '', '', '│'}
    }

    panel_winnr = api.nvim_open_win(header_bufnr, false, header_opts)
    api.nvim_win_set_option(panel_winnr, 'winfixheight', true)

    -- Open a window for the contents (below the header)
    local content_opts = {
        relative = 'editor',
        width = panel_width,
        height = height - 4,  -- Remaining space for content (subtracting header height)
        col = width - panel_width,  -- Position it below the header
        row = 3,
        anchor = 'NW',
        style = 'minimal',
        border = {'', '', '', '│', '', '', '', '│'}
    }

    -- Open the content window and store the window number in content_winnr
    M.content_winnr = api.nvim_open_win(content_bufnr, false, content_opts)

    api.nvim_win_set_option(M.content_winnr, 'wrap', true)
    api.nvim_win_set_option(M.content_winnr, 'cursorline', true)
    api.nvim_win_set_option(M.content_winnr, 'number', false)
    api.nvim_win_set_option(M.content_winnr, 'relativenumber', false)
    api.nvim_win_set_option(M.content_winnr, 'signcolumn', 'no')

    -- Ensure the content section stays fixed in size
    api.nvim_win_set_option(M.content_winnr, 'winfixwidth', true)
end

-- Hide both the header and contents sections
function M.hide_panel()
    if panel_winnr and api.nvim_win_is_valid(panel_winnr) then
        api.nvim_win_close(panel_winnr, true)
        panel_winnr = nil
    end
    if M.content_winnr and api.nvim_win_is_valid(M.content_winnr) then
        api.nvim_win_close(M.content_winnr, true)
        M.content_winnr = nil  -- Reset the content window handle
    end
end

-- Toggle the visibility of the panel
function M.toggle_panel()
    if panel_winnr and api.nvim_win_is_valid(panel_winnr) then
        M.hide_panel()
    else
        M.show_panel()
    end
end

-- Focus on the SpeechCraft content window
function M.focus_content()
    if M.content_winnr and vim.api.nvim_win_is_valid(M.content_winnr) then
        api.nvim_set_current_win(M.content_winnr)
    else
        print("SpeechCraft content window is not open.")
    end
end

-- Update the content in the content section
function M.update_panel_content(content)
    if content_bufnr and api.nvim_buf_is_valid(content_bufnr) then
        api.nvim_buf_set_option(content_bufnr, 'modifiable', true)
        api.nvim_buf_set_lines(content_bufnr, 0, -1, false, vim.split(content, "\n"))

        -- Check the markdown renderer configuration
        if require("plugins.speechcraft.lua.speechcraft.config").options.markdown_renderer == "native" then
            -- Use Treesitter for markdown highlighting
            vim.cmd("set ft=markdown")
            vim.cmd("TSBufEnable highlight")  -- Enable Treesitter highlighting
        end

        api.nvim_buf_set_option(content_bufnr, 'modifiable', false)
    end
end

-- Load content from a markdown file
function M.load_markdown_from_file(filepath)
    local content = vim.fn.readfile(filepath)
    M.update_panel_content(table.concat(content, "\n"))
end

-- Clear the content section
function M.clear_panel()
    M.update_panel_content("")
end

return M
