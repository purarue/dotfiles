---@module 'lazy'
---@type LazyPluginSpec[]
return {
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = { { "<leader>ut", "<Cmd>UndotreeToggle<CR>", desc = "undotree" } },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        -- colorscheme, 1000 makes things load early
        priority = 1000,
        opts = {
            background = { light = "latte", dark = "macchiato" },
            float = {
                transparent = false,
                solid = false,
            },
            -- change background colors to match terminal
            color_overrides = {
                macchiato = { base = "#282828" },
                latte = { base = "#fbf1c7" },
            },
        },
        config = function(_, opts)
            -- sets the vim 'background' property to dark/light
            -- depending on my terminal theme
            require("user.terminal").set_background()
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        priority = 1000,
        opts = { options = { theme = "catppuccin" } },
    },
    { "j-hui/fidget.nvim", opts = {}, event = "LspAttach" },
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown",
        keys = {
            {
                "<leader>p",
                function()
                    require("render-markdown").toggle()
                end,
                desc = "preview markdown toggle",
            },
        },
    },
    {
        -- g? : show help
        "stevearc/oil.nvim",
        event = "BufWinEnter", -- present so that if you open an oil buffer on launch, the plugin is loaded
        keys = {
            {
                "<leader>e",
                function()
                    require("oil").open()
                end,
                desc = "file explorer",
            },
        },
        --- @module 'oil'
        --- @type oil.SetupOpts
        opts = {
            default_file_explorer = true,
            columns = { "icon" },
            delete_to_trash = true,
        },
        config = function(_, opts)
            require("oil").setup(opts)
            vim.api.nvim_create_autocmd("User", {
                pattern = "OilActionsPost",
                callback = function(event)
                    if event.data.actions.type == "move" then
                        Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
                    end
                end,
            })
        end,
    },
    { "sindrets/diffview.nvim", cmd = "DiffviewOpen", config = true, lazy = true },
}
