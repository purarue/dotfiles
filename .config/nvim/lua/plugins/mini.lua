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
                    left = "<M-h>",
                    right = "<M-l>",
                    down = "<M-j>",
                    up = "<M-k>",
                },
            })
        end,
    },
    -- this is split so that we can lazy load on filetype effectively
    --
    -- the default 'gc' (:help commenting) binding works for most things, but react/web frameworks
    -- have a different comment syntax, so this plugin only loads on those filetypes
    {
        "nvim-mini/mini.comment",
        dependencies = {
            "JoosepAlviste/nvim-ts-context-commentstring",
            ---@module 'ts_context_commentstring'
            ---@type ts_context_commentstring.Config
            opts = { enable_autocmd = false },
        },
        ft = {
            "javascript",
            "typescript",
            "javascriptreact",
            "typescriptreact",
        },
        keys = { { "gc", mode = { "n", "x" } } },
        --- NOTE: no setup types
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
                end,
            },
        },
    },
}
