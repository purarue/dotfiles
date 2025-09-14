return {
    {
        "nvim-tree/nvim-web-devicons",
        lazy = true,
    },
    {
        "onsails/lspkind.nvim",
        lazy = true,
        opts = {
            symbol_map = {
                Copilot = "",
                Snippet = "",
            },
        },
    },
    {
        "saghen/blink.cmp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "fang2hou/blink-copilot",
            "moyiz/blink-emoji.nvim",
            "L3MON4D3/LuaSnip",
        },
        version = "1.*",
        event = { "InsertEnter", "CmdlineEnter" },

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- All presets have the following mappings:
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- C-f/b: Scroll docs
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = { preset = "default" },

            signature = {
                enabled = true,
            },

            cmdline = {
                enabled = true,
                completion = {
                    list = {
                        selection = {
                            preselect = false,
                        },
                    },
                    menu = {
                        auto_show = function(_ctx)
                            return vim.fn.getcmdtype() == ":"
                            -- enable for inputs as well, with:
                            -- or vim.fn.getcmdtype() == '@'
                        end,
                    },
                },
            },

            appearance = {
                nerd_font_variant = "mono",
            },

            completion = {
                -- only show the documentation popup when manually triggered <C-space>,
                -- or after 500ms
                documentation = { auto_show = true, auto_show_delay_ms = 500 },
                ghost_text = {
                    enabled = true,
                },
                list = {
                    selection = {
                        preselect = false,
                    },
                },
                menu = {
                    draw = {
                        treesitter = { "lsp" }, -- use lsp to highlight docs
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local icon = ctx.kind_icon
                                    -- if completing filenames, use the nvim-web-devicons icons
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            icon = dev_icon
                                        end
                                    else
                                        icon = require("lspkind").symbolic(ctx.kind, {
                                            mode = "symbol",
                                        })
                                    end

                                    if icon == nil or icon == "" then
                                        icon = "�" -- fallback icon
                                        vim.notify_once("No icon found for LSP kind: " .. ctx.kind, vim.log.levels.WARN)
                                    end

                                    return icon .. ctx.icon_gap
                                end,
                                highlight = function(ctx)
                                    local hl = ctx.kind_hl
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            hl = dev_hl
                                        end
                                    end
                                    return hl
                                end,
                            },
                        },
                    },
                },
            },

            snippets = {
                preset = "luasnip",
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { "copilot", "lsp", "path", "snippets", "buffer" },
                per_filetype = {
                    lua = {
                        inherit_defaults = true,
                        "lazydev",
                    },
                },
                providers = {
                    lazydev = {
                        name = "lazydev",
                        module = "lazydev.integrations.blink",
                        score_offset = 150, -- higher prio
                    },
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                        opts = {
                            max_completions = 3,
                            max_attempts = 2,
                        },
                    },
                },
            },
        },
        opts_extend = { "sources.default" },
    },
}
