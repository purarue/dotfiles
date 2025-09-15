return {
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = { { "<leader>u", "<Cmd>UndotreeToggle<CR>", desc = "undotree" } },
    },
    { "folke/twilight.nvim", lazy = true }, -- used for zen-mode.nvim
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = { { "<leader>Z", "<Cmd>ZenMode<CR>", desc = "zen mode" } },
        opts = {},
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        -- colorscheme, 1000 makes things load early
        priority = 1000,
        config = function()
            -- sets the vim 'background' property to dark/light
            -- depending on my terminal theme
            require("user.terminal").set_background()
            require("catppuccin").setup({
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
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        priority = 1000,
        opts = { options = { theme = "catppuccin" } },
    },
    { "j-hui/fidget.nvim", event = "LspAttach", opts = {} },
    { "stevearc/dressing.nvim", opts = {}, event = "VeryLazy" },
    {
        "rcarriga/nvim-notify",
        -- event = "VeryLazy",
        config = function()
            vim.notify = require("notify")
        end,
    },
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
        event = "BufWinEnter",
        keys = {
            {
                "<leader>e",
                function()
                    require("oil").open()
                end,
                desc = "file explorer",
            },
        },
        opts = {
            default_file_explorer = true,
            columns = { "icon" },
            delete_to_trash = true,
        },
    },
    { "sindrets/diffview.nvim", cmd = "DiffviewOpen", config = true, lazy = true },
}
