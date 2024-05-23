return {
    'hrsh7th/nvim-cmp',
    event = {"InsertEnter", "CmdlineEnter"},
    dependencies = {
        "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "onsails/lspkind.nvim",
        "hrsh7th/cmp-nvim-lua", "saadparwaiz1/cmp_luasnip",
        "nvim-lua/plenary.nvim", "hrsh7th/cmp-emoji", "hrsh7th/cmp-cmdline"
    },
    config = function()
        local cmp = require('cmp')
        local lspkind = require('lspkind')
        lspkind.init()
        cmp.setup({
            mapping = {
                ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                ["<C-d>"] = cmp.mapping.scroll_docs(4),
                ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(),
                                        {'i', 'c'}),
                ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item(),
                                        {'i', 'c'}),
                ["<C-e>"] = cmp.mapping.close(),
                ["<c-y>"] = cmp.mapping(cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Insert,
                    select = true
                }, {"i", "c"}),
                ["<C-Space>"] = cmp.mapping {
                    i = cmp.mapping.complete(),
                    c = function(_ --[[fallback]] )
                        if cmp.visible() then
                            if not cmp.confirm {select = true} then
                                return
                            end
                        else
                            cmp.complete()
                        end
                    end
                },
                ["<tab>"] = cmp.config.disable
            },
            -- order ranks priority in completion drop-down -- higher has more priority
            sources = {
                {name = "nvim_lsp"}, -- update neovim lsp capabilities https://github.com/hrsh7th/cmp-nvim-lsp
                {name = "nvim_lua", keyword_length = 2}, -- lua completion for nvim-specific stuff
                {name = "luasnip", keyword_length = 2}, -- snippets
                {name = "emoji", keyword_length = 3}, -- emoji
                {name = "path"}, -- complete names of files
                {name = "buffer", keyword_length = 4}
            },
            experimental = {native_menu = false, ghost_text = true},
            formatting = {
                format = lspkind.cmp_format {
                    with_text = true,
                    menu = {
                        buffer = "[buf]",
                        nvim_lsp = "[lsp]",
                        nvim_lua = "[lua]",
                        path = "[path]",
                        luasnip = "[snip]",
                        emoji = "[emoji]"
                    }
                }
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end
            }
        })

        -- complete which searching
        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{name = 'buffer', keyword_length = 3}}
        })

        -- complete while entering commands
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({{name = 'path'}}, {
                {
                    name = 'cmdline',
                    option = {ignore_cmds = {'Man', '!'}},
                    keyword_length = 2
                }
            })
        })
    end
}
