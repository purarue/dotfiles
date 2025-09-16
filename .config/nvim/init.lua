-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.runtimepath:prepend(lazypath)

-- lazy.nvim/which-key wants a leader to be set before setting up mappings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- https://github.com/purarue/on_machine
-- what operating system I'm on controls how some plugins load
vim.g.on_os = os.getenv("ON_OS") or "unknown" ---@type string
vim.g.on_android = vim.split(vim.g.on_os, "_")[1] == "android" ---@type boolean

-- load plugins from the 'lua/plugins' directory
require("lazy").setup({
    spec = {
        { import = "plugins" },
    },
    checker = { enabled = true, notify = false },
    browser = "openurl",
    change_detection = { enabled = false, notify = false },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
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
