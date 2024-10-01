-- Inside plugin/speechcraft.lua

if vim.fn.has("nvim-0.7.0") == 0 then
    vim.api.nvim_err_writeln("SpeechCraft requires at least Neovim v0.7.0")
    return
end

vim.api.nvim_create_augroup("SpeechCraft", { clear = true })

vim.api.nvim_create_autocmd("VimEnter", {
    group = "SpeechCraft",
    callback = function()
        require("speechcraft").setup({})  -- Pass an empty table if no options are needed
    end,
})

vim.api.nvim_create_autocmd("VimResized", {
    group = "SpeechCraft",
    callback = function()
        -- Reopen the content window to adjust its size
        require("speechcraft").close_content_window()
        require("speechcraft").open_content_window()
    end,
})

-- Add command to load and display markdown from a file
vim.api.nvim_create_user_command("SpeechCraftLoadMarkdown", function()
    local filepath = vim.fn.stdpath("config") .. "/data/markdown/example.md"
    local content = vim.fn.readfile(filepath)
    require("speechcraft").set_content_window(table.concat(content, "\n"))
end, { desc = "Load and display markdown content from example.md" })

-- Commands for enabling, disabling, and toggling the display of the content window
vim.api.nvim_create_user_command("SpeechCraftDisplayEnable", function()
    require("speechcraft").open_content_window()
end, { desc = "Enable SpeechCraft content window" })

vim.api.nvim_create_user_command("SpeechCraftDisplayDisable", function()
    require("speechcraft").close_content_window()
end, { desc = "Disable SpeechCraft content window" })

vim.api.nvim_create_user_command("SpeechCraftDisplayToggle", function()
    require("speechcraft").toggle_content_window()
end, { desc = "Toggle SpeechCraft content window" })

-- Key mappings for managing content window visibility and focus
vim.api.nvim_set_keymap("n", "<leader>sd", ":SpeechCraftDisplayToggle<CR>", { noremap = true, silent = true, desc = "Toggle SpeechCraft content window visibility" })
vim.api.nvim_set_keymap("n", "<leader>se", ":SpeechCraftDisplayEnable<CR>", { noremap = true, silent = true, desc = "Enable SpeechCraft content window" })
vim.api.nvim_set_keymap("n", "<leader>sx", ":SpeechCraftDisplayDisable<CR>", { noremap = true, silent = true, desc = "Disable SpeechCraft content window" })

-- Key mapping for loading markdown
vim.api.nvim_set_keymap("n", "<leader>sm", ":SpeechCraftLoadMarkdown<CR>", { noremap = true, silent = true, desc = "Load markdown into SpeechCraft content window" })
