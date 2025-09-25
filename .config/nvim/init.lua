local lazy = require("lazy_setup")
lazy.bootstrap()

-- lazy.nvim/which-key wants a leader to be set before setting up mappings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("user.custom.on_machine")
lazy.setup()
require("user.options")

-- the rest of my mappings are in ./after/plugin/*.lua
