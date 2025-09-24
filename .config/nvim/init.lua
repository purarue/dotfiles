require("user.lazy_bootstrap")

-- lazy.nvim/which-key wants a leader to be set before setting up mappings
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("user.on_machine")
require("user.lazy_setup")
require("user")
