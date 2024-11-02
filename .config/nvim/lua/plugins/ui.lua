return {
    {
        "mbbill/undotree",
        cmd = "UndotreeToggle",
        keys = { { "<leader>u", "<Cmd>UndotreeToggle<CR>", desc = "undotree" } },
    },
    { "folke/twilight.nvim", lazy = true },
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
            require("catppuccin").setup({
                background = { light = "latte", dark = "macchiato" },
                -- change background colors to match terminal
                color_overrides = {
                    macchiato = { base = "#282828" },
                    latte = { base = "#fbf1c7" },
                },
            })
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    { "nvim-tree/nvim-web-devicons", lazy = true },
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
        "toppair/peek.nvim",
        ft = "markdown",
        cond = not vim.g.on_android,
        build = "deno task --quiet build:fast",
        keys = {
            {
                "<leader>p",
                function()
                    vim.notify("launching preview...")
                    require("peek").open()
                end,
                desc = "preview markdown",
            },
        },
        config = function()
            require("peek").setup()
        end,
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
    {
        "2KAbhishek/nerdy.nvim",
        dependencies = {
            "stevearc/dressing.nvim",
        },
        cmd = "Nerdy",
    },
}
