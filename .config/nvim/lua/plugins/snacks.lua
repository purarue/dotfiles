---@module 'lazy'
---@type LazyPluginSpec
return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@module 'snacks'
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        gitbrowse = { enabled = true },
        input = { enabled = true },
        picker = {
            enabled = true,
            reverse = true,
            sources = {},
            layout = {
                preset = "telescope",
            },
        },
        notify = { enabled = true },
        notifier = {
            enabled = true,
            timeout = 3000,
        },
        statuscolumn = { enabled = true },
        zen = { enabled = true },
    },
    keys = {
        {
            "<leader><space>",
            function()
                Snacks.picker.smart()
            end,
            desc = "smart find files",
        },
        {
            "<leader>fc",
            function()
                Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
            end,
            desc = "find config file",
        },
        {
            "<leader>ff",
            function()
                Snacks.picker.files()
            end,
            desc = "find files",
        },
        {
            "<leader>fr",
            function()
                Snacks.picker.recent()
            end,
            desc = "recent",
        },
        {
            "<leader>fp",
            function()
                Snacks.picker.git_files()
            end,
            desc = "find git files",
        },
        {
            "<leader>:",
            function()
                Snacks.picker.command_history()
            end,
            desc = "command history",
        },
        {
            "<leader>fn",
            function()
                Snacks.picker.notifications()
            end,
            desc = "notification history",
        },
        {
            "<leader>E",
            function()
                Snacks.explorer()
            end,
            desc = "file explorer",
        },
        {
            "<leader>gb",
            function()
                Snacks.picker.git_branches()
            end,
            desc = "git branches",
        },
        {
            "<leader>gl",
            function()
                Snacks.picker.git_log()
            end,
            desc = "git log",
        },
        {
            "<leader>gL",
            function()
                Snacks.picker.git_log_line()
            end,
            desc = "git log line",
        },
        {
            "<leader>gs",
            function()
                Snacks.picker.git_status()
            end,
            desc = "git status",
        },
        {
            "<leader>gd",
            function()
                Snacks.picker.git_diff()
            end,
            desc = "git diff (hunks)",
        },
        {
            "<leader>gf",
            function()
                Snacks.picker.git_log_file()
            end,
            desc = "git log file",
        },
        {
            "<leader>fl",
            function()
                Snacks.picker.lines()
            end,
            desc = "buffer lines",
        },
        {
            "<leader>fg",
            function()
                Snacks.picker.grep()
            end,
            desc = "grep",
        },
        {
            "<leader>fB",
            function()
                Snacks.picker.grep_buffers()
            end,
            desc = "grep open buffers",
        },
        {
            "<leader>fw",
            function()
                Snacks.picker.grep_word()
            end,
            desc = "visual selection or word",
            mode = { "n", "x" },
        },
        {
            "<leader>f/",
            function()
                Snacks.picker.search_history()
            end,
            desc = "search history",
        },
        {
            "<leader>fa",
            function()
                Snacks.picker.autocmds()
            end,
            desc = "autocmds",
        },
        {
            "<leader>fb",
            function()
                Snacks.picker.lines()
            end,
            desc = "buffer lines",
        },
        {
            "<leader>fc",
            function()
                Snacks.picker.command_history()
            end,
            desc = "command history",
        },
        {
            "<leader>fC",
            function()
                Snacks.picker.commands()
            end,
            desc = "commands",
        },
        {
            "<leader>fd",
            function()
                Snacks.picker.diagnostics()
            end,
            desc = "diagnostics",
        },
        {
            "<leader>fD",
            function()
                Snacks.picker.diagnostics_buffer()
            end,
            desc = "buffer diagnostics",
        },
        {
            "<leader>fh",
            function()
                Snacks.picker.help()
            end,
            desc = "help pages",
        },
        {
            "<leader>fH",
            function()
                Snacks.picker.highlights()
            end,
            desc = "highlights",
        },
        {
            "<leader>fi",
            function()
                Snacks.picker.icons()
            end,
            desc = "icons",
        },
        {
            "<leader>fj",
            function()
                Snacks.picker.jumps()
            end,
            desc = "jumps",
        },
        {
            "<leader>fk",
            function()
                Snacks.picker.keymaps()
            end,
            desc = "keymaps",
        },
        {
            "<leader>fQ",
            function()
                Snacks.picker.loclist()
            end,
            desc = "location list",
        },
        {
            "<leader>fM",
            function()
                Snacks.picker.man()
            end,
            desc = "man pages",
        },
        {
            "<leader>fP",
            function()
                Snacks.picker.lazy()
            end,
            desc = "search for plugin spec",
        },
        {
            "<leader>fq",
            function()
                Snacks.picker.qflist()
            end,
            desc = "quickfix list",
        },
        {
            "<leader>fR",
            function()
                Snacks.picker.resume()
            end,
            desc = "resume",
        },
        {
            "<leader>fu",
            function()
                Snacks.picker.undo()
            end,
            desc = "undo history",
        },
        {
            "<leader>uC",
            function()
                Snacks.picker.colorschemes()
            end,
            desc = "colorschemes",
        },

        {
            "gd",
            function()
                Snacks.picker.lsp_definitions()
            end,
            desc = "goto definition",
        },
        {
            "gD",
            function()
                Snacks.picker.lsp_declarations()
            end,
            desc = "goto declaration",
        },
        {
            "gr",
            function()
                Snacks.picker.lsp_references()
            end,
            nowait = true,
            desc = "references",
        },
        {
            "gI",
            function()
                Snacks.picker.lsp_implementations()
            end,
            desc = "goto implementation",
        },
        {
            "gy",
            function()
                Snacks.picker.lsp_type_definitions()
            end,
            desc = "goto t[y]pe definition",
        },
        {
            "<leader>fs",
            function()
                Snacks.picker.lsp_symbols()
            end,
            desc = "lsp symbols",
        },
        {
            "<leader>fS",
            function()
                Snacks.picker.lsp_workspace_symbols()
            end,
            desc = "lsp workspace symbols",
        },
        {
            "<leader>z",
            function()
                Snacks.zen()
            end,
            desc = "toggle zen mode",
        },
        {
            "<leader>Z",
            function()
                Snacks.zen.zoom()
            end,
            desc = "toggle zoom",
        },
        {
            "<leader>n",
            function()
                Snacks.notifier.show_history()
            end,
            desc = "notification history",
        },
        {
            "<leader>cR",
            function()
                Snacks.rename.rename_file()
            end,
            desc = "rename file",
        },
        {
            "<leader>gB",
            function()
                -- open in browser
                Snacks.gitbrowse()
            end,
            desc = "git browse",
            mode = { "n", "v" },
        },
        {
            "<leader>d",
            function()
                Snacks.notifier.hide()
            end,
            desc = "dismiss all notifications",
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Setup some globals for debugging (lazy-loaded)
                _G.dd = function(...)
                    Snacks.debug.inspect(...)
                end
                _G.bt = function()
                    Snacks.debug.backtrace()
                end
                vim.print = _G.dd -- Override print to use snacks for `:=` command

                -- Create some toggle mappings
                Snacks.toggle.option("spell", { name = "spelling" }):map("<leader>us")
                Snacks.toggle.option("wrap", { name = "wrap" }):map("<leader>uw")

                -- for when Im sharing screen, is useful to have a crosshair
                Snacks.toggle.option("cursorline", { name = "cursorline" }):map("<leader>ul")
                Snacks.toggle.option("cursorcolumn", { name = "cursorcolumn" }):map("<leader>uc")

                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>ug")
                Snacks.toggle.dim():map("<leader>uz")
            end,
        })
    end,
}
