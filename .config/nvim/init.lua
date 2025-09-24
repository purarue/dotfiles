require("user.lazy_bootstrap")

-- lazy.nvim/which-key wants a leader to be set before setting up mappings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- https://github.com/purarue/on_machine
require("user.on_machine")

-- load plugins from the 'lua/plugins' directory
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

-- load my lua options/mappings
require("user")
