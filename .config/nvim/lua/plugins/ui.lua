---@module 'snacks'
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
        ---@module 'catppuccin.types'
        ---@type CatppuccinOptions
        opts = {
            background = { light = "latte", dark = "macchiato" },
            -- change background colors to match terminal
            color_overrides = {
                macchiato = { base = "#282828" },
                latte = { base = "#fbf1c7" },
            },
            integrations = {
                blink_cmp = true,
                fidget = true,
                gitsigns = true,
                treesitter = true,
                treesitter_context = true,
                snacks = true,
                lsp_trouble = true,
                which_key = true,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "meuter/lualine-so-fancy.nvim",
        },
        priority = 500,
        opts = {
            options = { theme = "catppuccin" },
            sections = {
                lualine_a = { "fancy_mode" }, -- fixed width
                lualine_b = { "branch", "fancy_diff" },
                lualine_c = { { "fancy_cwd", substitute_home = true }, "filename" },
                lualine_x = { "fancy_diagnostics", "fancy_searchcount" },
                -- ts_icon is present if treesitter is attached
                lualine_y = { { "fancy_filetype", ts_icon = { "󱁉", color = { fg = "lightblue" } } } },
                lualine_z = { "progress", "location" },
            },
        },
    },
    { "j-hui/fidget.nvim", opts = {
        notification = {
            window = { winblend = 0 },
        },
    }, event = "LspAttach" },
    {
        "folke/todo-comments.nvim",
        event = "VeryLazy",
        ---@module 'todo-comments'
        ---@type TodoOptions
        ---@diagnostic disable-next-line: missing-fields
        opts = { signs = false },
        keys = {
            -- stylua: ignore start
            ---@diagnostic disable-next-line: undefined-field
            { "<leader>ft", function() Snacks.picker.todo_comments() end, desc = "todos" },
            ---@diagnostic disable-next-line: undefined-field
            { "<leader>fT", function() Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "BUG" } }) end, desc = "todo/fix/fixme" },
            -- stylua: ignore end
        },
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown",
        ---@module 'render-markdown'
        ---@type render.md.partial.Config
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
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
    {
        "sindrets/diffview.nvim",
        cmd = "DiffviewOpen",
        ---@module 'diffview.config'
        ---@class DiffviewConfig
        opts = {},
        lazy = true,
    },
}
