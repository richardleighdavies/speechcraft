local api = vim.api
local M = {}

-- Buffer and window numbers for our content window
local content_window_bufnr = nil
local content_window_winnr = nil

-- Function to create or get the content window buffer
local function get_or_create_buffer()
    if content_window_bufnr and api.nvim_buf_is_valid(content_window_bufnr) then
        return content_window_bufnr
    end
    
    content_window_bufnr = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(content_window_bufnr, 'buftype', 'nofile')
    api.nvim_buf_set_option(content_window_bufnr, 'bufhidden', 'hide')
    api.nvim_buf_set_option(content_window_bufnr, 'swapfile', false)
    api.nvim_buf_set_option(content_window_bufnr, 'modifiable', false)
    api.nvim_buf_set_option(content_window_bufnr, 'filetype', 'markdown')
    
    return content_window_bufnr
end

-- Function to create the content window
function M.create_content_window()
    local buf = get_or_create_buffer()
    
    -- Create a new window on the right side
    content_window_winnr = api.nvim_open_win(buf, false, {
        relative = 'editor',
        width = math.floor(vim.o.columns * 0.3),
        height = vim.o.lines - 4,
        col = vim.o.columns,
        row = 0,
        anchor = 'NE',
        style = 'minimal',
        border = 'single'
    })
    
    -- Set window options
    api.nvim_win_set_option(content_window_winnr, 'wrap', true)
    api.nvim_win_set_option(content_window_winnr, 'cursorline', true)
    api.nvim_win_set_option(content_window_winnr, 'winfixwidth', true)
    
    -- Add header
    M.set_header("SpeechCraft Content Window")
end

-- Function to hide the content window
function M.hide_content_window()
    if content_window_winnr and api.nvim_win_is_valid(content_window_winnr) then
        api.nvim_win_hide(content_window_winnr)
        content_window_winnr = nil
    end
end

-- Function to toggle the content window
function M.toggle_content_window()
    if content_window_winnr and api.nvim_win_is_valid(content_window_winnr) then
        M.hide_content_window()
    else
        M.create_content_window()
    end
end

-- Function to set or update the header
function M.set_header(header_text)
    if not content_window_bufnr or not api.nvim_buf_is_valid(content_window_bufnr) then return end
    
    api.nvim_buf_set_option(content_window_bufnr, 'modifiable', true)
    api.nvim_buf_set_lines(content_window_bufnr, 0, 1, false, {header_text, string.rep('-', #header_text)})
    api.nvim_buf_set_option(content_window_bufnr, 'modifiable', false)
end

-- Function to add content to the content window
function M.add_content(content)
    if not content_window_bufnr or not api.nvim_buf_is_valid(content_window_bufnr) then return end
    
    local lines = vim.split(content, '\n')
    local start_line = api.nvim_buf_line_count(content_window_bufnr)
    
    api.nvim_buf_set_option(content_window_bufnr, 'modifiable', true)
    api.nvim_buf_set_lines(content_window_bufnr, start_line, -1, false, lines)
    api.nvim_buf_set_option(content_window_bufnr, 'modifiable', false)
end

-- Function to clear the content window content (except the header)
function M.clear_content()
    if not content_window_bufnr or not api.nvim_buf_is_valid(content_window_bufnr) then return end
    
    api.nvim_buf_set_option(content_window_bufnr, 'modifiable', true)
    api.nvim_buf_set_lines(content_window_bufnr, 2, -1, false, {})
    api.nvim_buf_set_option(content_window_bufnr, 'modifiable', false)
end

-- Function to focus the content window
function M.focus_content_window()
    if content_window_winnr and api.nvim_win_is_valid(content_window_winnr) then
        api.nvim_set_current_win(content_window_winnr)
    end
end

-- Function to unfocus the content window (return to previous window)
function M.unfocus_content_window()
    if content_window_winnr and api.nvim_win_is_valid(content_window_winnr) then
        vim.cmd('wincmd p')
    end
end

-- Function to toggle focus on the content window
function M.toggle_focus()
    if content_window_winnr and api.nvim_win_is_valid(content_window_winnr) then
        if api.nvim_get_current_win() == content_window_winnr then
            M.unfocus_content_window()
        else
            M.focus_content_window()
        end
    end
end

-- Function to load markdown from a file
function M.load_markdown_from_file(filepath)
    local content = vim.fn.readfile(filepath)
    M.clear_content()
    M.add_content(table.concat(content, "\n"))
end

-- Setup function to create keymaps
function M.setup()
    vim.api.nvim_set_keymap('n', '<leader>sf', ':lua require("speechcraft.content_window").focus_content_window()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>su', ':lua require("speechcraft.content_window").unfocus_content_window()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>st', ':lua require("speechcraft.content_window").toggle_focus()<CR>', {noremap = true, silent = true})
end

return M
