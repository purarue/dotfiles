-- nvim-cmp
local cmp = require("cmp")

local lspkind = require("lspkind")
lspkind.init()

cmp.setup({
    mapping = {
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
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
        {name = "luasnip", keyword_length = 2}, -- snippets
        {name = "path"}, -- complete names of files
        {name = "buffer", keyword_length = 4}
    },
    experimental = {native_menu = false, ghost_text = true},
    formatting = {
        -- Youtube: How to set up nice formatting for your sources.
        format = lspkind.cmp_format {
            with_text = true,
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[lsp]",
                nvim_lua = "[lua]",
                path = "[path]",
                luasnip = "[snip]"
            }
        }
    },
    snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end
    }
})

-- completions for '/' based on current buffer
-- cmp.setup.cmdline('/', {sources = {{name = 'buffer', keyword_length = 4}}})

-- https://github.com/hrsh7th/cmp-nvim-lsp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

capabilities.textDocument.completion.completionItem.snippetSupport = true

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- web stuff
require("lspconfig").jsonls.setup {capabilities = capabilities}
require("lspconfig").cssls.setup {capabilities = capabilities}
require("lspconfig").html.setup {capabilities = capabilities}
require("lspconfig").eslint.setup {}
require("lspconfig").cssmodules_ls.setup {}
require("lspconfig").tailwindcss.setup {}
require("lspconfig").tsserver.setup {}

-- python
require("lspconfig").pyright.setup {}

-- yaml
require("lspconfig").yamlls.setup {}

-- shell
require("lspconfig").bashls.setup {}

-- golang
require("lspconfig").gopls.setup {}

-- lua
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require"lspconfig".sumneko_lua.setup {
    settings = {
        Lua = {
            runtime = {version = "LuaJIT", path = runtime_path},
            diagnostics = {globals = {"vim"}},
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true)
            }
        }
    }
}

