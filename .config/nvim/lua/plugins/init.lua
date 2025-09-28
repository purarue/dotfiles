---@module 'lazy'
---@type LazyPluginSpec[]
return {
    {
        "folke/which-key.nvim",
        lazy = true,
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        ---@module 'which-key'
        ---@type wk.Opts
        ---@diagnostic disable-next-line: missing-fields
        opts = {
            spec = {
                -- TODO: could add more items here with icons, maybe I can programmatically find items without icons?
                { "<leader>x", group = "trouble", icon = "󱈸" },
                { "gr", group = "LSP Actions", mode = { "n" } },
                { "<leader>H", group = "hex colors", icon = "󰏘" },
                { "<leader>y", icon = "" },
            },
        },
    },
    -- while in visual mode
    -- []x to encode/decode HTML, []u to encode/decode URLs, []y to do C-style escaping
    {
        "purarue/vim-unimpaired-conversions",
        keys = { { "[", mode = "x" }, { "]", mode = { "x" } } },
    },
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },
}
