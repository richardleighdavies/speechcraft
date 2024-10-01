local api = vim.api
local M = {}

M.width = 40
M.buffer_name = "SpeechCraft-Content"
M.header_name = "SpeechCraft-Header"

local function create_buffer(name)
    local buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    api.nvim_buf_set_option(buf, 'swapfile', false)
    api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    api.nvim_buf_set_option(buf, 'modifiable', false)
    api.nvim_buf_set_option(buf, 'buflisted', false)
    api.nvim_buf_set_name(buf, name)
    return buf
end

local function create_header_window()
    local header_buf = create_buffer(M.header_name)
    
    -- Create header window
    local header_width = M.width - 2  -- Account for borders
    local header_height = 1
    local header_win = api.nvim_open_win(header_buf, false, {
        relative = 'editor',
        width = header_width,
        height = header_height,
        col = vim.o.columns - header_width,
        row = 0,
        anchor = 'NE',
        style = 'minimal',
        border = 'single',
        noautocmd = true
    })

    -- Set header content
    api.nvim_buf_set_option(header_buf, 'modifiable', true)
    api.nvim_buf_set_lines(header_buf, 0, -1, false, {"Speech Craft"})
    api.nvim_buf_set_option(header_buf, 'modifiable', false)

    -- Set header highlighting
    local ns_id = api.nvim_create_namespace("SpeechCraftHeader")
    api.nvim_buf_add_highlight(header_buf, ns_id, "Title", 0, 0, -1)

    -- Set window options
    api.nvim_win_set_option(header_win, 'winhighlight', 'Normal:SpeechCraftHeader')

    return header_win
end

function M.open()
    if M.content_win and api.nvim_win_is_valid(M.content_win) then
        api.nvim_set_current_win(M.content_win)
        return
    end

    -- Create header window
    M.header_win = create_header_window()

    -- Create content buffer if it doesn't exist
    local content_buf = create_buffer(M.buffer_name)
    api.nvim_buf_set_option(content_buf, 'filetype', 'markdown')

    -- Create content window
    local win_height = vim.o.lines - vim.o.cmdheight - 3  -- Account for header and statusline
    M.content_win = api.nvim_open_win(content_buf, true, {
        relative = 'editor',
        width = M.width - 2,  -- Account for borders
        height = win_height - 1,  -- Account for header
        col = vim.o.columns - M.width + 2,
        row = 1,  -- Position just below the header
        anchor = 'NE',
        style = 'minimal',
        border = 'single',
        noautocmd = true
    })

    -- Set window options
    api.nvim_win_set_option(M.content_win, 'number', false)
    api.nvim_win_set_option(M.content_win, 'relativenumber', false)
    api.nvim_win_set_option(M.content_win, 'wrap', false)
    api.nvim_win_set_option(M.content_win, 'signcolumn', 'no')
    api.nvim_win_set_option(M.content_win, 'winfixwidth', true)
    api.nvim_win_set_option(M.content_win, 'winfixheight', true)

    -- Return to the previous window
    vim.cmd('noautocmd wincmd p')
end

function M.close()
    if M.header_win and api.nvim_win_is_valid(M.header_win) then
        api.nvim_win_close(M.header_win, true)
    end
    if M.content_win and api.nvim_win_is_valid(M.content_win) then
        api.nvim_win_close(M.content_win, true)
    end
    M.header_win = nil
    M.content_win = nil
end

function M.toggle()
    if M.content_win and api.nvim_win_is_valid(M.content_win) then
        M.close()
    else
        M.open()
    end
end

function M.set_content(content)
    if not M.content_win or not api.nvim_win_is_valid(M.content_win) then
        M.open()
    end

    local buf = api.nvim_win_get_buf(M.content_win)
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))
    api.nvim_buf_set_option(buf, 'modifiable', false)
end

function M.add_content(content)
    if not M.content_win or not api.nvim_win_is_valid(M.content_win) then
        M.open()
    end

    local buf = api.nvim_win_get_buf(M.content_win)
    local line_count = api.nvim_buf_line_count(buf)
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_buf_set_lines(buf, line_count, -1, false, vim.split(content, "\n"))
    api.nvim_buf_set_option(buf, 'modifiable', false)
end

function M.clear_content()
    if M.content_win and api.nvim_win_is_valid(M.content_win) then
        local buf = api.nvim_win_get_buf(M.content_win)
        api.nvim_buf_set_option(buf, 'modifiable', true)
        api.nvim_buf_set_lines(buf, 0, -1, false, {})
        api.nvim_buf_set_option(buf, 'modifiable', false)
    end
end

function M.setup(opts)
    opts = opts or {}
    M.width = opts.width or M.width

    -- Set up keymaps
    vim.api.nvim_set_keymap('n', '<leader>st', ':lua require("speechcraft.content_window").toggle()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>so', ':lua require("speechcraft.content_window").open()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>sc', ':lua require("speechcraft.content_window").close()<CR>', {noremap = true, silent = true})

    -- Create highlight groups
    vim.cmd([[
        highlight SpeechCraftHeader guibg=#1e1e2e guifg=#89b4fa gui=bold
    ]])

    -- Set up autocommands to prevent normal buffers from opening in the SpeechCraft window
    vim.cmd([[
        augroup SpeechCraftWindowProtection
            autocmd!
            autocmd BufEnter * lua require('speechcraft.content_window').protect_window()
        augroup END
    ]])
end

function M.protect_window()
    if M.content_win and api.nvim_get_current_win() == M.content_win then
        local current_buf = api.nvim_get_current_buf()
        local buf_name = api.nvim_buf_get_name(current_buf)
        if not buf_name:match(M.buffer_name .. "$") then
            -- If a different buffer is trying to open in our window, switch back to our buffer
            local our_buf = api.nvim_create_buf(false, true)
            api.nvim_buf_set_name(our_buf, M.buffer_name)
            api.nvim_win_set_buf(M.content_win, our_buf)
            -- Move the intruding buffer to a new window
            vim.cmd('noautocmd wincmd v')
            vim.cmd('noautocmd wincmd L')
            local new_win = api.nvim_get_current_win()
            api.nvim_win_set_buf(new_win, current_buf)
            -- Return focus to the previous window
            vim.cmd('noautocmd wincmd p')
        end
    end
end

return M
