return {
    "speechcraft",
    dir = vim.fn.stdpath("config") .. "/lua/plugins/speechcraft",
    config = function()
        local plugin_module = require("plugins.speechcraft.lua.speechcraft")
        -- Expose the plugin's functions globally
        package.loaded.speechcraft = plugin_module
        -- Immediately call setup with default options
        if plugin_module.setup then
            plugin_module.setup({})
        end
    end,
}
