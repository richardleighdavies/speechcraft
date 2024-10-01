local api = vim.api
local M = {}

M.width = 40
M.buffer_name = "SpeechCraft-Content"

local function create_buffer()
    local buf = api.nvim_create_buf(false, true)
    api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    api.nvim_buf_set_option(buf, 'swapfile', false)
    api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
    api.nvim_buf_set_option(buf, 'filetype', 'markdown')
    api.nvim_buf_set_option(buf, 'modifiable', false)
    api.nvim_buf_set_name(buf, M.buffer_name)
    return buf
end

function M.open()
    local win_id = M.get_window()
    if win_id then
        api.nvim_set_current_win(win_id)
        return
    end

    -- Create a new buffer if it doesn't exist
    local buf = M.get_buffer()
    if not buf then
        buf = create_buffer()
    end

    -- Open a new window on the right side
    vim.cmd('botright vertical ' .. M.width .. 'split')
    win_id = api.nvim_get_current_win()
    api.nvim_win_set_buf(win_id, buf)

    -- Set window options
    api.nvim_win_set_option(win_id, 'number', false)
    api.nvim_win_set_option(win_id, 'relativenumber', false)
    api.nvim_win_set_option(win_id, 'wrap', false)
    api.nvim_win_set_option(win_id, 'signcolumn', 'no')

    -- Return to the previous window
    vim.cmd('wincmd p')
end

function M.close()
    local win_id = M.get_window()
    if win_id then
        api.nvim_win_close(win_id, true)
    end
end

function M.toggle()
    local win_id = M.get_window()
    if win_id then
        M.close()
    else
        M.open()
    end
end

function M.get_window()
    for _, win in ipairs(api.nvim_list_wins()) do
        local buf = api.nvim_win_get_buf(win)
        if api.nvim_buf_get_name(buf):match(M.buffer_name .. "$") then
            return win
        end
    end
    return nil
end

function M.get_buffer()
    for _, buf in ipairs(api.nvim_list_bufs()) do
        if api.nvim_buf_get_name(buf):match(M.buffer_name .. "$") then
            return buf
        end
    end
    return nil
end

function M.set_content(content)
    local buf = M.get_buffer()
    if not buf then
        M.open()
        buf = M.get_buffer()
    end

    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))
    api.nvim_buf_set_option(buf, 'modifiable', false)
end

function M.add_content(content)
    local buf = M.get_buffer()
    if not buf then
        M.open()
        buf = M.get_buffer()
    end

    local line_count = api.nvim_buf_line_count(buf)
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_buf_set_lines(buf, line_count, -1, false, vim.split(content, "\n"))
    api.nvim_buf_set_option(buf, 'modifiable', false)
end

function M.clear_content()
    local buf = M.get_buffer()
    if buf then
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
end

return M
