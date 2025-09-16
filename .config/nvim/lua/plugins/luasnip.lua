---@module 'lazy'
---@type LazyPluginSpec
return {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter", -- only load snippets after I enter insert mode
    version = "2.*",
    build = "make install_jsregexp",
    config = function()
        local ls = require("luasnip")

        ls.config.set_config({
            history = true,
            -- support snippets that change dynamically
            updateevents = "TextChanged,TextChangedI",
            enable_autosnippets = true,
        })

        -- <c-k> is my expansion key
        -- this will expand the current item or jump to the next item within the snippet.
        vim.keymap.set({ "i", "s" }, "<c-k>", function()
            if ls.expand_or_jumpable() then
                ls.expand_or_jump()
            end
        end, { silent = true })

        -- <c-j> is my jump backwards key.
        -- this always moves to the previous item within the snippet
        vim.keymap.set({ "i", "s" }, "<c-j>", function()
            if ls.jumpable(-1) then
                ls.jump(-1)
            end
        end, { silent = true })

        -- <c-l> is selecting within a list of options.
        -- This is useful for choice nodes
        vim.keymap.set("i", "<c-l>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end)

        -- Extend with https://github.com/rafamadriz/friendly-snippets
        ls.filetype_extend("gitcommit", {})
        require("luasnip.loaders.from_vscode").lazy_load()

        -- load some personal snippest (I use the snipmate for basic text-based snippets)
        require("luasnip.loaders.from_snipmate").lazy_load()
    end,
    dependencies = { "rafamadriz/friendly-snippets" },
}
