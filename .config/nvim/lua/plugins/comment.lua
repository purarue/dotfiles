-- the default 'gc' (:help commenting) binding works for most things, but react/web frameworks
-- have a different comment syntax, so this plugin only loads on those filetypes
---@module 'lazy'
---@type LazyPluginSpec
return {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
    ft = {
        "javascript",
        "typescript",
        "javascriptreact",
        "typescriptreact",
    },
    keys = { { "gc", mode = { "n", "v" } }, { "gbc", mode = { "n", "v" } } },
    lazy = not vim.g.on_android, -- only load if on android, on an old version of nvim
    config = function()
        ---@diagnostic disable-next-line: missing-fields
        require("Comment").setup({
            pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        })
    end,
}
