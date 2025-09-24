local lazy = require("user.lazy")
lazy.bootstrap()

-- lazy.nvim/which-key wants a leader to be set before setting up mappings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("user.custom.on_machine")
lazy.setup()

-- the rest of my config/options is in after/plugin/
