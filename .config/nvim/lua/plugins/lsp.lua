return {
    {
        "b0o/SchemaStore.nvim",
        lazy = true,
    },
    {
        "hrsh7th/cmp-nvim-lsp",
        lazy = true,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        config = function()
            -- https://github.com/hrsh7th/cmp-nvim-lsp
            local capabilities = vim.lsp.protocol.make_client_capabilities()
            capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

            capabilities.textDocument.completion.completionItem.snippetSupport = true
            capabilities.workspace = {
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
                pyright = {
                    flags = { debounce_text_changes = 100 },
                    settings = {
                        {
                            pyright = { autoImportCompletions = true },
                            python = {
                                analysis = {
                                    autoSearchPaths = true,
                                    diagnosticMode = "openFilesOnly",
                                    useLibraryCodeForTypes = true,
                                    typeCheckingMode = "off",
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
                    lspconf[server].setup({ capabilities = capabilities })
                else
                    lspconf[server].setup(vim.tbl_extend("force", { capabilities = capabilities }, config))
                end
            end

            lspconf.lua_ls.setup({
                capabilities = capabilities,
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.loop.fs_stat(path .. "/.luarc.json") or vim.loop.fs_stat(path .. "/.luarc.jsonc") then
                            return
                        end
                    end

                    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            -- (most likely LuaJIT in the case of Neovim)
                            version = "LuaJIT",
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
                            -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
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
                callback = function()
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
                    -- BUG: hmm... doesn't actually seem to display for me
                    -- may have to enable these for each language server
                    --
                    -- local client = vim.lsp.get_client_by_id(event.data.client_id)
                    -- if client and vim.lsp.inlay_hint and
                    --     client.supports_method('textDocument/inlayHint') then
                    --     wk.add({
                    --         ['ft'] = {
                    --             function()
                    --                 vim.lsp.inlay_hint.enable(
                    --                     not vim.lsp.inlay_hint.is_enabled({}))
                    --             end, desc = "toggle inlay hints"
                    --         }
                    --     })
                    --     -- toggle on by default, for now
                    --     vim.lsp.inlay_hint.enable(true)
                    -- end
                end,
                desc = "lsp keybindings",
            })
        end,
    },
}
