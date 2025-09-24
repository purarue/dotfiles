local wk = require("which-key")

wk.add({
    { "<leader>f", group = "find" },
    { "<leader>u", group = "toggle" },
    { "<leader>g", group = "git" },
    { "<leader>c", group = "config", icon = "" },
})

local function lazygit()
    if vim.b["lazygit_cwd"] and vim.b["lazygit_cwd"] ~= vim.uv.cwd() then
        -- reset the cached terminal if the cwd has changed
        -- unload to force refresh the terminal cache
        package.loaded["snacks.lazygit"] = nil
    end
    vim.b["lazygit_cwd"] = vim.uv.cwd()

    if vim.b["yadm_tracked"] then
        local gitsigns_config = require("gitsigns-yadm").config
        Snacks.lazygit({
            args = {
                "--git-dir=" .. gitsigns_config.yadm_repo_git,
                "--work-tree=" .. gitsigns_config.homedir,
            },
        })
    else
        Snacks.lazygit()
    end
end

local function gitopen()
    if vim.b["yadm_tracked"] then
        -- wrapper script that opens my dotfiles repo
        -- in my browser:
        -- https://purarue.xyz/d/.local/share/shortcuts/dotfiles?redirect
        vim.fn.system("dotfiles")
    else
        -- NOTE: 'what' = "permalink" seems to do nothing
        Snacks.gitbrowse.open({ what = "permalink" })
    end
end

---@module 'lazy'
---@type LazyPluginSpec
return {
    "folke/snacks.nvim",
    priority = 800,
    lazy = false,
    opts = function(_, opts)
        ---@module 'snacks'
        ---@type snacks.Config
        return vim.tbl_deep_extend("force", opts or {}, {
            bigfile = { enabled = true },
            gitbrowse = {
                enabled = true,
                open = function(url)
                    -- '%-' is an escaped hyphen
                    url = url:gsub("^(https://)git%-new", "%1github.com")
                    url = url:gsub("^(https://)git%-old", "%1github.com")
                    vim.ui.open(url)
                end,
            },
            input = { enabled = true },
            picker = {
                actions = require("trouble.sources.snacks").actions,
                win = {
                    input = {
                        keys = {
                            ["<C-t>"] = {
                                "trouble_open",
                                mode = { "n", "i" },
                            },
                        },
                    },
                },
                enabled = true,
                reverse = true,
                sources = {},
                layout = {
                    preset = "telescope",
                },
            },
            notify = { enabled = true },
            quickfile = { enabled = true },
            notifier = {
                enabled = true,
                timeout = 3000,
            },
            statuscolumn = { enabled = true },
            zen = { enabled = true },
        })
    end,
    keys = {
        -- stylua: ignore start
        { "<leader><space>", function() Snacks.picker.smart() end, desc = "smart find files" },
        { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "find nvim config file" },
        { "<leader>ff", function() Snacks.picker.files() end, desc = "find files" },
        { "<leader>fp", function() Snacks.picker.git_files() end, desc = "find git files"},
        { "<leader>f:", function() Snacks.picker.command_history() end, desc = "command history" },
        { "<leader>fn", function() Snacks.picker.notifications() end, desc = "notification history" },
        { "<leader>E", function() Snacks.explorer() end, desc = "file explorer" },
        { "<leader>gr", function() Snacks.picker.git_branches() end, desc = "git branches" },
        { "<leader>gl", function() Snacks.picker.git_log() end, desc = "git log" },
        { "<leader>gg", lazygit, desc = "lazygit" },
        { "<leader>gF", function() Snacks.gitbrowse.open({ what = "file" }) end, desc = "git browse file", mode = { "n", "v" } },
        { "<leader>gL", function() Snacks.gitbrowse.open({ what = "branch" }) end, desc = "git browse branch", mode = { "n", "v" } },
        { "<leader>fl", function() Snacks.picker.lines() end, desc = "buffer lines" },
        { "<leader>fL", function() Snacks.picker.files({ cwd = vim.fn.stdpath("data") .. "/lazy" }) end, desc = "lazy plugins" },
        { "<leader>fg", function() Snacks.picker.grep() end, desc = "grep" },
        { "<leader>fB", function() Snacks.picker.grep_buffers() end, desc = "grep open buffers" },
        { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "visual selection or word", mode = { "n", "x" } },
        { "<leader>f/", function() Snacks.picker.search_history() end, desc = "search history" },
        { "<leader>fa", function() Snacks.picker.autocmds() end, desc = "autocmds" },
        { "<leader>fb", function() Snacks.picker.buffers() end, desc = "buffers" },
        { "<leader>fC", function() Snacks.picker.commands() end, desc = "commands" },
        { "<leader>fh", function() Snacks.picker.help() end, desc = "help pages" },
        { "<leader>fH", function() Snacks.picker.highlights() end, desc = "highlights" },
        { "<leader>fi", function() Snacks.picker.icons() end, desc = "icons" },
        { "<leader>fj", function() Snacks.picker.jumps() end, desc = "jumps" },
        { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "keymaps" },
        { "<leader>fQ", function() Snacks.picker.loclist() end, desc = "location list" },
        { "<leader>fM", function() Snacks.picker.man() end, desc = "man pages" },
        { "<leader>fP", function() Snacks.picker.lazy() end, desc = "search for plugin spec" },
        { "<leader>fq", function() Snacks.picker.qflist() end, desc = "quickfix list" },
        { "<leader>fR", function() Snacks.picker.resume() end, desc = "resume" },
        { "<leader>fu", function() Snacks.picker.undo() end, desc = "undo history" },
        { "<leader>n", function() Snacks.notifier.show_history() end, desc = "notification history" },
        { "<leader>cr", function() Snacks.rename.rename_file() end, desc = "rename file" },
        { "<leader>go", gitopen, desc = "git browse", mode = { "n", "v" } },
        { "<leader>d", function() Snacks.notifier.hide() end, desc = "dismiss all notifications" },
        { "<leader>ce", function() Snacks.picker.pick({ finder = require("user.custom.projects")._config_finder }) end, desc = "edit config" },
        -- picker.projects seem to not work with "mini.misc".setup_auto_root?, doesnt change dir
        { "<leader>cR", function() Snacks.picker.projects({ dev = require("user.custom.projects").dev_list() }) end, desc = "projects" },
        { "gd", function() Snacks.picker.lsp_definitions() end, desc = "lsp definitions" },
        -- stylua: ignore end
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

                -- for when I'm sharing screen, is useful to have a crosshair
                Snacks.toggle.option("cursorline", { name = "cursorline" }):map("<leader>ul")
                Snacks.toggle.option("cursorcolumn", { name = "cursorcolumn" }):map("<leader>uc")

                Snacks.toggle.inlay_hints():map("<leader>uh")
                Snacks.toggle.indent():map("<leader>ug")
                Snacks.toggle.dim():map("<leader>uz")
            end,
        })
    end,
}
