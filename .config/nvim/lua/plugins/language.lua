return {
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
        config = function(_, opts)
            -- Monkeypatch in a PR to remove a call to the deprecated `client.notify`
            -- function.
            -- See: https://github.com/folke/lazydev.nvim/pull/106
            local lsp = require("lazydev.lsp")
            ---@diagnostic disable-next-line: duplicate-set-field
            lsp.update = function(client)
                lsp.assert(client)
                client:notify("workspace/didChangeConfiguration", {
                    settings = { Lua = {} },
                })
            end

            require("lazydev").setup(opts)
        end,
    }, -- update lua workspace libraries
    { "Bilal2453/luvit-meta", lazy = true },
    { "tpope/vim-sleuth", event = "VeryLazy" }, -- detect indentation
}
