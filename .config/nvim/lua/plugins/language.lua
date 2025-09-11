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
    }, -- update lua workspace libraries
    { "Bilal2453/luvit-meta", lazy = true },
    { "tpope/vim-sleuth", event = "VeryLazy" }, -- detect indentation
}
