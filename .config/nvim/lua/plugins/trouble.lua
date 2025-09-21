local wk = require("which-key")
wk.add({
    { "<leader>x", group = "trouble" },
})

---@module 'lazy'
---@type LazyPluginSpec
return {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
        { "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "diagnostics" },
        { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "buffer diagnostics" },
        { "<leader>xl", "<cmd>Trouble loclist toggle<CR>", desc = "location" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<CR>", desc = "quickfix" },
        { "<leader>xt", "<cmd>Trouble todo<CR>", desc = "todos" },
    },
}
