local api = vim.api
local M = {}

M.position = "left"
M.width = 40
M.buffer_name = "SpeechCraft-Content"

function M.open()
    -- Check if the window is already open
    local win_id = M.get_window()
    if win_id then
        api.nvim_set_current_win(win_id)
        return
    end

    -- Determine split command based on position
    local split_command = M.position == "left" and "topleft " or "botright "
    split_command = split_command .. M.width .. "vsplit"

    -- Open a new window
    vim.cmd(split_command .. " " .. M.buffer_name)

    -- Get the window and buffer numbers
    local win = api.nvim_get_current_win()
    local buf = api.nvim_get_current_buf()

    -- Set buffer options
    api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    api.nvim_buf_set_option(buf, 'swapfile', false)
    api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
    api.nvim_buf_set_option(buf, 'filetype', 'markdown')

    -- Set window options
    api.nvim_win_set_option(win, 'number', false)
    api.nvim_win_set_option(win, 'relativenumber', false)
    api.nvim_win_set_option(win, 'wrap', false)
    api.nvim_win_set_option(win, 'signcolumn', 'no')

    -- Disable certain mappings in this window
    local mappings = {
        '<CR>', '<C-]>', '<C-v>', '<C-x>', '<C-t>'
    }
    for _, mapping in ipairs(mappings) do
        vim.api.nvim_buf_set_keymap(buf, 'n', mapping, '', { noremap = true, silent = true })
    end

    -- Set a buffer name
    api.nvim_buf_set_name(buf, M.buffer_name)

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

function M.set_content(content)
    local win_id = M.get_window()
    if not win_id then
        M.open()
        win_id = M.get_window()
    end

    local buf = api.nvim_win_get_buf(win_id)
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))
    api.nvim_buf_set_option(buf, 'modifiable', false)
end

function M.add_content(content)
    local win_id = M.get_window()
    if not win_id then
        M.open()
        win_id = M.get_window()
    end

    local buf = api.nvim_win_get_buf(win_id)
    local line_count = api.nvim_buf_line_count(buf)
    api.nvim_buf_set_option(buf, 'modifiable', true)
    api.nvim_buf_set_lines(buf, line_count, -1, false, vim.split(content, "\n"))
    api.nvim_buf_set_option(buf, 'modifiable', false)
end

function M.clear_content()
    local win_id = M.get_window()
    if win_id then
        local buf = api.nvim_win_get_buf(win_id)
        api.nvim_buf_set_option(buf, 'modifiable', true)
        api.nvim_buf_set_lines(buf, 0, -1, false, {})
        api.nvim_buf_set_option(buf, 'modifiable', false)
    end
end

function M.setup(opts)
    opts = opts or {}
    M.position = opts.position or M.position
    M.width = opts.width or M.width

    -- Set up keymaps
    vim.api.nvim_set_keymap('n', '<leader>st', ':lua require("speechcraft.content_window").toggle()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>so', ':lua require("speechcraft.content_window").open()<CR>', {noremap = true, silent = true})
    vim.api.nvim_set_keymap('n', '<leader>sc', ':lua require("speechcraft.content_window").close()<CR>', {noremap = true, silent = true})
end

return M
