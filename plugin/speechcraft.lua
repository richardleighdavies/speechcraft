-- Inside plugin/speechcraft.lua

if vim.fn.has("nvim-0.7.0") == 0 then
    vim.api.nvim_err_writeln("SpeechCraft requires at least Neovim v0.7.0")
    return
end

vim.api.nvim_create_augroup("SpeechCraft", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
    group = "SpeechCraft",
    callback = function()
        require("speechcraft").setup()
    end,
})

vim.api.nvim_create_autocmd("VimResized", {
    group = "SpeechCraft",
    callback = function()
        -- Resize the panel if needed (hide and show again to adjust size)
        require("speechcraft.panel").hide_panel()
        require("speechcraft.panel").show_panel()
    end,
})

-- Add command to load and display markdown from a file
vim.api.nvim_create_user_command("SpeechCraftLoadMarkdown", function()
    local filepath = vim.fn.stdpath("config") .. "/data/markdown/example.md"
    require("speechcraft").load_markdown_from_file(filepath)
end, { desc = "Load and display markdown content from example.md" })

-- Commands for enabling, disabling, and toggling the display of the panel
vim.api.nvim_create_user_command("SpeechCraftDisplayEnable", function()
    require("speechcraft").show_panel()
end, { desc = "Enable SpeechCraft panel window" })

vim.api.nvim_create_user_command("SpeechCraftDisplayDisable", function()
    require("speechcraft").hide_panel()
end, { desc = "Disable SpeechCraft panel window" })

vim.api.nvim_create_user_command("SpeechCraftDisplayToggle", function()
    require("speechcraft").toggle_panel()
end, { desc = "Toggle SpeechCraft panel window" })

-- Commands for focusing on the contents section and toggling focus
vim.api.nvim_create_user_command("SpeechCraftFocusEnable", function()
    require("speechcraft").focus_content()
end, { desc = "Focus on SpeechCraft panel content section" })

vim.api.nvim_create_user_command("SpeechCraftFocusDisable", function()
    vim.cmd([[wincmd p]])  -- Return focus to the previously active window
end, { desc = "Return focus to the previous window" })

vim.api.nvim_create_user_command("SpeechCraftFocusToggle", function()
    -- Get the current window and content window
    local current_win = vim.api.nvim_get_current_win()
    local panel = require("speechcraft.panel")

    -- Check if the content window exists, if not, show the panel first
    if not panel.content_winnr or not vim.api.nvim_win_is_valid(panel.content_winnr) then
        panel.show_panel()  -- Ensure the panel is enabled before toggling focus
    end

    -- Now we check the content window again
    local content_winnr = panel.content_winnr

    -- Check if the current window is the content window
    if content_winnr and current_win == content_winnr and vim.api.nvim_win_is_valid(content_winnr) then
        -- If already in the content window, switch back to the previous window
        vim.cmd([[wincmd p]])
    else
        -- If not in the content window, switch to the content window
        panel.focus_content()
    end
end, { desc = "Toggle focus between SpeechCraft panel content and previous window" })

-- Key mappings for managing panel window visibility and focus
vim.api.nvim_set_keymap("n", "<leader>sd", ":SpeechCraftDisplayToggle<CR>", { noremap = true, silent = true, desc = "Toggle SpeechCraft panel visibility" })
vim.api.nvim_set_keymap("n", "<leader>se", ":SpeechCraftDisplayEnable<CR>", { noremap = true, silent = true, desc = "Enable SpeechCraft panel window" })
vim.api.nvim_set_keymap("n", "<leader>sx", ":SpeechCraftDisplayDisable<CR>", { noremap = true, silent = true, desc = "Disable SpeechCraft panel window" })

vim.api.nvim_set_keymap("n", "<leader>sf", ":SpeechCraftFocusEnable<CR>", { noremap = true, silent = true, desc = "Focus on SpeechCraft panel content section" })
vim.api.nvim_set_keymap("n", "<leader>sp", ":SpeechCraftFocusDisable<CR>", { noremap = true, silent = true, desc = "Return focus to the previous window" })
vim.api.nvim_set_keymap("n", "<leader>st", ":SpeechCraftFocusToggle<CR>", { noremap = true, silent = true, desc = "Toggle focus on SpeechCraft panel content" })

-- Key mapping for loading markdown
vim.api.nvim_set_keymap("n", "<leader>sm", ":SpeechCraftLoadMarkdown<CR>", { noremap = true, silent = true, desc = "Load markdown into SpeechCraft panel" })
