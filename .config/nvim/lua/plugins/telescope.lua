local wk = require("which-key")

wk.add({
    { "<leader>c", group = "config" },
    { "<leader>f", group = "telescope" },
})

return {
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        lazy = true,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        lazy = true,
    },
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        event = { "BufReadPre", "BufNewFile" },
        keys = {
            {
                "<leader>ce",
                function()
                    require("user.telescope").edit_config()
                end,
                desc = "edit config",
            },
            {
                "<leader>cg",
                function()
                    require("user.telescope").grep_config()
                end,
                desc = "grep config",
            },
            {
                "<leader>cr",
                function()
                    require("user.telescope").switch_to_repo()
                end,
                desc = "switch repo",
            },
            -- mnemonic 'cd' binding
            {
                "<leader>cd",
                function()
                    local filename = vim.fn.expand("%:p:h")
                    local cmd = "cd " .. filename
                    vim.cmd(cmd)
                    vim.notify("cd " .. filename)
                end,
                desc = "cd to curdir",
            },
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "find files",
            },
            {
                "<leader>fg",
                function()
                    require("telescope.builtin").live_grep()
                end,
                desc = "grep",
            },
            {
                "<leader>fr",
                function()
                    require("telescope.builtin").lsp_references()
                end,
                desc = "references",
            },
            {
                "<leader>fb",
                function()
                    require("telescope.builtin").buffers()
                end,
                desc = "buffers",
            },
            {
                "<leader>fH",
                function()
                    require("user.telescope").grep_help()
                end,
                desc = "help",
            },
            {
                "<leader>fq",
                function()
                    require("telescope.builtin").quickfix()
                end,
                desc = "quickfix",
            },
            {
                "<leader>fl",
                function()
                    require("telescope.builtin").loclist()
                end,
                desc = "loclist",
            },
            {
                "<leader>fp",
                function()
                    require("telescope.builtin").git_files()
                end,
                desc = "git files",
            },
            {
                "<leader>fo", -- codespell:ignore
                function()
                    require("telescope.builtin").oldfiles()
                end,
                desc = "old files",
            },
            {
                "<leader>fc",
                function()
                    require("telescope.builtin").commands()
                end,
                desc = "commands",
            },
            {
                "<leader>fs",
                function()
                    require("telescope.builtin").spell_suggest()
                end,
                desc = "spell suggest",
            },
            {
                "<leader>fm",
                function()
                    require("telescope.builtin").marks()
                end,
                desc = "marks",
            },
            {
                "<leader>fM",
                function()
                    require("telescope.builtin").man_pages()
                end,
                desc = "man pages",
            },
            {
                "<leader>fn",
                function()
                    require("telescope").extensions.notify.notify()
                end,
                desc = "notify",
            },
            {
                "<leader>fh",
                function()
                    require("telescope.builtin").command_history()
                end,
                desc = "command history",
            },
            {
                "<leader>fk",
                function()
                    require("telescope.builtin").keymaps()
                end,
                desc = "keymaps",
            },
            {
                "<leader>fd",
                function()
                    require("telescope.builtin").diagnostics()
                end,
                desc = "diagnostics",
            },
            { "<leader>ft", ":Telescope<CR>", desc = "telescope" },
            {
                "<leader>fL",
                function()
                    require("user.telescope").find_lazy_plugins()
                end,
                desc = "lazy files",
            },
            {
                "<leader>f ",
                function()
                    require("telescope.builtin").resume()
                end,
                desc = "resume",
            },
        },
        config = function()
            local tl = require("telescope")
            local actions = require("telescope.actions")
            local previewers = require("telescope.previewers")

            -- this is a no-op for now, just here in case I want to modify things
            -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#previewers
            local function buffer_previewer(filepath, bufnr, opts)
                opts = opts or {}
                return previewers.buffer_previewer_maker(filepath, bufnr, opts)
            end

            -- https://github.com/nvim-telescope/telescope.nvim#pickers
            tl.setup({
                defaults = {
                    winblend = 20, -- transparency
                    path_display = { "relative" },
                    -- Default configuration for telescope goes here:
                    -- config_key = value,
                    mappings = {
                        i = {
                            -- esc to exit in insert mode, I never really use normal mode
                            -- just use <C-j> and <C-k> to move up/down, <C-q> to send to quickfix
                            ["<Esc>"] = actions.close,
                            -- fzf-like up/down (remember, can also switch to normal mode and use j/k)
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                    -- ignore some directory caches with lots of file results
                    file_ignore_patterns = {
                        "/discogs_cache/",
                        "/feed_giantbomb_cache/",
                        "/feed_tmdb_cache/",
                    },
                    results_title = false, -- don't show results title
                    prompt_title = false, -- don't show prompt title
                    file_previewer = previewers.vim_buffer_cat.new,
                    buffer_previewer_maker = buffer_previewer,
                    preview = {
                        check_mime_type = true, -- check mime type before opening previewer
                        filesize_limit = 2, -- limit previewer to files under 2MB
                        timeout = 500, -- timeout previewer after 500 ms
                        treesitter = true, -- use treesitter when available
                    },
                },
                pickers = {
                    -- Default configuration for builtin pickers goes here:
                    -- picker_name = {
                    --   picker_config_key = value,
                    --   ...
                    -- }
                },
                extensions = {
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case", -- or "ignore_case" or "respect_case"
                    },
                },
            })

            tl.load_extension("fzf") -- native fzf
            tl.load_extension("notify")
            tl.load_extension("ui-select")
        end,
    },
}
