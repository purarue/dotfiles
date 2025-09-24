---@module 'lazy'
---@type LazyPluginSpec
return {
    "windwp/nvim-ts-autotag",
    ft = {
        "html",
        "xml",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "markdown",
        "astro",
    },

    -- NOTE: https://github.com/JoosepAlviste/nvim-ts-context-commentstring/pull/56
    -- in case I forget and think there's something wrong with my config
    --
    ---@module 'nvim-ts-autotag.config.plugin'
    ---@type nvim-ts-autotag.PluginSetup
    opts = {},
}
