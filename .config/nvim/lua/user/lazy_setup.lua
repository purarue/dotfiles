---@module 'lazy.config'
---@type LazyConfig
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    browser = "openurl",
    change_detection = { enabled = false, notify = false },
    rocks = { enabled = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "netrwPlugin",
                "tarPlugin",
                "tutor",
                "zipPlugin",
            },
        },
    },
})
