local wk = require("which-key")

wk.add({
    { "<leader>c", group = "config" },
    { "<leader>f", group = "telescope" },
})

---@module 'lazy'
---@type LazyPluginSpec[]
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
        },
        opts = function()
            -- https://github.com/nvim-telescope/telescope.nvim#pickers
            local actions = require("telescope.actions")
            local previewers = require("telescope.previewers")

            -- this is a no-op for now, just here in case I want to modify things
            -- https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#previewers
            local function buffer_previewer(filepath, bufnr, custom_opts)
                return previewers.buffer_previewer_maker(filepath, bufnr, custom_opts or {})
            end

            return {
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
                            -- scroll previewerer horizontally
                            ["<C-h>"] = actions.preview_scrolling_left,
                            ["<C-l>"] = actions.preview_scrolling_right,
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
            }
        end,
        config = function(_, opts)
            local telescope = require("telescope")
            telescope.setup(opts)

            telescope.load_extension("fzf") -- native fzf
            telescope.load_extension("ui-select")
        end,
    },
}
