---@module 'lazy'
---@type LazyPluginSpec[]
return {
    {
        "nvim-mini/mini.nvim",
        version = false,
        event = "BufEnter", -- required for setup_auto_root
        config = function()
            -- :help mini.ai
            --  - va)  - [V]isually select [A]round [)]paren
            --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
            --  - ci'  - [C]hange [I]nside [']quote
            require("mini.ai").setup() -- repeatable text motions
            -- :help mini.surround
            -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
            -- - sd'   - [S]urround [D]elete [']quotes
            -- - sr)'  - [S]urround [R]eplace [)] [']
            require("mini.surround").setup()
            -- automatically change buffer cwd to the root of the project (vim-rooter-esque)
            require("mini.misc").setup_auto_root({ ".git", "Makefile", "stylua.toml" })
            -- move visual selection in Visual mode
            require("mini.move").setup({
                mappings = {
                    left = "<S-h>",
                    right = "<S-l>",
                    down = "<S-j>",
                    up = "<S-k>",
                },
            })
            local wk = require("which-key")
            wk.add({
                {
                    "<leader>z",
                    function()
                        require("mini.misc").zoom()
                    end,
                    desc = "zoom",
                    icon = "",
                },
            })
        end,
    },
    -- this is split so that we can lazy load effectively
    --
    -- the default 'gc' (:help commenting) binding works for most things, but react/web frameworks
    -- have a different comment syntax, so this plugin only loads on those filetypes
    {
        "nvim-mini/mini.comment",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
        ft = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
        },
        keys = { { "gc", mode = { "n", "x" } }, { "gbc", mode = { "n", "x" } } },
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
                end,
            },
        },
    },
}
