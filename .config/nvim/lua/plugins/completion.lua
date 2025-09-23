local M = { _ICON_CACHE = {} }

---@param ctx blink.cmp.DrawItemContext
---@return { icon: string, hl: string }
function M.icon_info(ctx)
    -- cached lookup
    if M._ICON_CACHE[ctx.kind] then
        return M._ICON_CACHE[ctx.kind]
    end

    local icon = ctx.kind_icon
    local hl = ctx.kind_hl
    if ctx.source_name == "Path" then
        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
        if dev_icon then
            icon = dev_icon
            hl = dev_hl
        end
    else
        icon = require("lspkind").symbolic(ctx.kind, {
            mode = "symbol",
        })
    end

    -- cache result
    if icon then
        M._ICON_CACHE[ctx.kind] = { icon = icon, hl = hl }
    else
        if icon == nil or icon == "" then
            icon = "�" -- fallback icon
            if ctx.kind then
                vim.notify_once("No icon found for LSP kind: " .. ctx.kind, vim.log.levels.WARN)
            end
        end
    end
    return { icon = icon, hl = hl }
end

---@module 'lazy'
---@type LazyPluginSpec
return {
    "Saghen/blink.cmp",
    dependencies = {
        {
            "fang2hou/blink-copilot",
            lazy = true,
        },
        {
            "nvim-tree/nvim-web-devicons",
            lazy = true,
        },
        {
            "onsails/lspkind.nvim",
            lazy = true,
            opts = {
                symbol_map = {
                    Copilot = "󰚩",
                    Snippet = "",
                },
            },
        },
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
                    ---@diagnostic disable-next-line: unused-local
                    auto_show = function(ctx)
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
            accept = {
                -- experimental auto_brackets support
                auto_brackets = {
                    enabled = true,
                },
            },
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
                ---@type blink.cmp.Draw
                draw = {
                    treesitter = { "lsp" }, -- use lsp to highlight docs
                    components = {
                        kind_icon = {
                            text = function(ctx)
                                local info = M.icon_info(ctx)
                                return info.icon .. ctx.icon_gap
                            end,
                            highlight = function(ctx)
                                return M.icon_info(ctx).hl
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
    config = function(_, opts)
        -- set the base capabilities for all lsp servers
        vim.lsp.config("*", {
            capabilities = require("blink.cmp").get_lsp_capabilities({
                -- override some of the defaults
                workspace = {
                    didChangeWatchedFiles = {
                        -- https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
                        -- https://github.com/neovim/neovim/issues/23291
                        -- disable watchfiles for lsp, runs slow on linux
                        dynamicRegistration = false,
                    },
                },
            }),
            root_markers = { ".git/" },
        })
        require("blink.cmp").setup(opts)
    end,
}
