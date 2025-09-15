return {
    {
        "b0o/SchemaStore.nvim",
        lazy = true,
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Library items can be absolute paths
                -- "~/projects/my-awesome-lib",
                -- Or relative, which means they will be resolved as a plugin
                -- "LazyVim",
                -- When relative, you can also provide a path to the library in the plugin dir
                { path = "${3rd}/luv/library", words = { "vim%.uv", "vim%.loop" } },
            },
        },
    }, -- update lua workspace libraries
    { "Bilal2453/luvit-meta", lazy = true },
    {
        "MysticalDevil/inlay-hints.nvim",
        event = "LspAttach",
        after = { "nvim-lspconfig" },
        opts = {},
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        config = function()
            local blink_cmp = require("blink.cmp")
            local default_capabilities = blink_cmp.get_lsp_capabilities()

            default_capabilities.textDocument.completion.completionItem.snippetSupport = true
            default_capabilities.workspace = {
                didChangeWatchedFiles = {
                    -- https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
                    -- https://github.com/neovim/neovim/issues/23291
                    -- disable watchfiles for lsp, runs slow on linux
                    dynamicRegistration = false,
                },
            }

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
            local lspconf = require("lspconfig")
            local servers = {
                jsonls = {
                    settings = {
                        json = {
                            schemas = require("schemastore").json.schemas(),
                            validate = { enable = true },
                        },
                    },
                },
                basedpyright = {
                    settings = {
                        basedpyright = {
                            analysis = {
                                autoSearchPaths = true,
                                typeCheckingMode = "off",
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "openFilesOnly",
                                inlayHints = {
                                    callArgumentNames = true,
                                },
                            },
                        },
                    },
                },
                yamlls = {
                    settings = {
                        yaml = {
                            keyOrdering = false,
                            schemaStore = {
                                -- Disable built-in schemaStore support
                                enable = false,
                                -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                                url = "",
                            },
                            schemas = require("schemastore").yaml.schemas(),
                        },
                    },
                },
                bashls = true,
            }
            -- disable some LSPs on android
            if not vim.g.on_android then
                -- find elixir-ls binary
                local elixir_ls_bin = vim.fn.exepath("elixir-ls")
                if elixir_ls_bin ~= "" then
                    servers.elixirls = { cmd = { elixir_ls_bin } }
                end
                servers.clangd = true
                servers.gopls = true
                servers.ocamllsp = true
                servers.rust_analyzer = true
                servers.cssls = true
                servers.html = true
                servers.gdscript = true
                servers.templ = true
                servers.eslint = true
                servers.cssmodules_ls = true
                servers.tailwindcss = true
                servers.ts_ls = true
                servers.prismals = true
                servers.astro = true
            end

            for server, config in pairs(servers) do
                if config == true then
                    lspconf[server].setup({ capabilities = default_capabilities })
                else
                    lspconf[server].setup(vim.tbl_extend("force", { capabilities = default_capabilities }, config))
                end
            end

            lspconf.lua_ls.setup({
                capabilities = default_capabilities,
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = "LuaJIT",
                            -- Tell the language server how to find Lua modules same way as Neovim
                            -- (see `:h lua-module-load`)
                            path = {
                                "lua/?.lua",
                                "lua/?/init.lua",
                            },
                        },
                        diagnostics = { globals = { "vim" } },
                        -- Make the server aware of Neovim runtime files
                        workspace = {
                            checkThirdParty = false,
                            library = {
                                vim.env.VIMRUNTIME,
                                "~/.config/pura_lua/", -- personal shared lua code
                                -- dont need to add everything here because lazydev.nvim will
                                -- configure lua_ls as needed:
                                -- https://github.com/folke/lazydev.nvim
                            },
                        },
                    })
                end,
                settings = {
                    Lua = {},
                },
            })

            vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
                group = vim.api.nvim_create_augroup("lsp_disable", { clear = true }),
                pattern = { ".env", ".env.*" },
                callback = function()
                    vim.diagnostic.enable(false)
                end,
                desc = "disable lsp diagnostics for .env files",
            })

            local wk = require("which-key")

            -- run on any client connecting
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
                ---@diagnostic disable-next-line: unused-local
                callback = function(event)
                    -- set omnifunc to lsp omnifunc
                    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
                    -- when the client attaches, add keybindings
                    -- lsp commands with leader prefix
                    wk.add({
                        { "<leader>T", vim.lsp.buf.code_action, desc = "lsp code action" },
                        { "<leader>r", vim.lsp.buf.rename, desc = "lsp rename" },
                    })

                    -- lsp commands in normal mode
                    wk.add({
                        { "gd", vim.lsp.buf.definition, desc = "goto definition" },
                        { "gt", vim.lsp.buf.type_definition, desc = "goto type definition" },
                        { "gr", vim.lsp.buf.references, desc = "goto references" },
                        { "D", vim.diagnostic.open_float, desc = "diagnostic hover" },
                    })
                end,
                desc = "lsp keybindings",
            })
        end,
    },
}
