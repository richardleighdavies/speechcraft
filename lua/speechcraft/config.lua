local M = {}

M.defaults = {
    activation_key = "<C-s>",
    speech_recognition_backend = "default",
    custom_commands = {},
    panel_width = 0.25,  -- 25% of the screen width
    markdown_renderer = "native"  -- Default to Treesitter (native) rendering
}

M.options = {}

function M.setup(opts)
    M.options = vim.tbl_deep_extend("force", M.defaults, opts or {})
end

return M
