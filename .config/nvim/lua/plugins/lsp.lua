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
        dependencies = { {
            "b0o/SchemaStore.nvim",
            lazy = true,
        }, "Saghen/blink.cmp" },
        event = { "BufReadPost", "BufNewFile" },
        cmd = { "LspInfo", "LspInstall", "LspUninstall" },
        opts = function()
            -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
            local servers = { "bashls", "lua_ls", "jsonls", "yamlls" }
            if not vim.g.on_android then
                servers = vim.list_extend(servers, {
                    "basedpyright",
                    "clangd",
                    "gopls",
                    "rust_analyzer",
                    "cssls",
                    "html",
                    "gdscript",
                    "templ",
                    "eslint",
                    "tailwindcss",
                    "ts_ls",
                    "prismals",
                    "astro",
                })
            end
            return {
                servers = servers,
                enable_inlay_hints = false,
            }
        end,
        config = function(_, opts)
            vim.lsp.enable(opts.servers)
            vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
                group = vim.api.nvim_create_augroup("lsp_disable", { clear = true }),
                pattern = { ".env", ".env.*" },
                callback = function(event)
                    vim.diagnostic.enable(false, { filter = { bufnr = event.buf } })
                end,
                desc = "disable lsp diagnostics for .env files",
            })

            if opts.enable_inlay_hints then
                -- run on any client connecting
                vim.api.nvim_create_autocmd("LspAttach", {
                    group = vim.api.nvim_create_augroup("custom-lsp-attach", { clear = true }),
                    callback = function(event)
                        -- when the client attaches, add keybindings
                        -- lsp commands with leader prefix
                        -- setup inlay hints
                        if not (event.data and event.data.client_id) then
                            return
                        end
                        local client = vim.lsp.get_client_by_id(event.data.client_id)

                        if
                            client and (client:supports_method("textDocument/inlayHint") or client.server_capabilities.inlayHintProvider)
                        then
                            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
                        end
                    end,
                    desc = "lsp keybindings",
                })
            end
        end,
    },
}
