---@module 'lazy'
---@type LazyPluginSpec[]
return {
    {
        "folke/lazydev.nvim",
        dependencies = { "Bilal2453/luvit-meta", lazy = true }, -- update lua workspace libraries
        ft = "lua",
        ---@module 'lazydev'
        ---@type lazydev.Config
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
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "b0o/SchemaStore.nvim",
            lazy = true,
        },
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        config = function()
            -- NOTE: no setup() required v0.11+
            local blink_cmp = require("blink.cmp")
            local default_capabilities = blink_cmp.get_lsp_capabilities()

            default_capabilities.workspace = {
                didChangeWatchedFiles = {
                    -- https://github.com/neovim/neovim/issues/23725#issuecomment-1561364086
                    -- https://github.com/neovim/neovim/issues/23291
                    -- disable watchfiles for lsp, runs slow on linux
                    dynamicRegistration = false,
                },
            }

            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
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
            -- disable most LSPs on android
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
                local use_capabilities = default_capabilities
                if not config == true then
                    use_capabilities = vim.tbl_extend("force", { capabilities = default_capabilities }, config)
                end
                vim.lsp.config(server, { capabilities = use_capabilities })
                vim.lsp.enable(server)
            end

            -- this needs to be separate, I think because of the on_init function/vim.tbl_extend
            vim.lsp.config("lua_ls", {
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
            vim.lsp.enable("lua_ls")

            vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
                group = vim.api.nvim_create_augroup("lsp_disable", { clear = true }),
                pattern = { ".env", ".env.*" },
                callback = function(event)
                    vim.diagnostic.enable(false, { filter = { bufnr = event.buf } })
                end,
                desc = "disable lsp diagnostics for .env files",
            })

            -- run on any client connecting
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
                callback = function(event)
                    local wk = require("which-key")
                    -- set omnifunc to lsp omnifunc
                    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
                    -- when the client attaches, add keybindings
                    -- lsp commands with leader prefix
                    wk.add({
                        { "<leader>T", vim.lsp.buf.code_action, desc = "lsp code action", buffer = event.buf },
                        { "<leader>r", vim.lsp.buf.rename, desc = "lsp rename", buffer = event.buf },
                    })

                    -- setup inlay hints
                    if not (event.data and event.data.client_id) then
                        return
                    end
                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    if client and (client:supports_method("textDocument/inlayHint") or client.server_capabilities.inlayHintProvider) then
                        vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
                    end
                end,

                desc = "lsp keybindings",
            })
        end,
    },
}
