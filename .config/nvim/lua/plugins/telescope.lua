local wk = require("which-key")

wk.add({
    { "<leader>c", group = "config" },
})

---@module 'lazy'
---@type LazyPluginSpec
return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            lazy = true,
        },
    },
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
            "<leader>cR",
            function()
                require("user.telescope").switch_to_repo()
            end,
            desc = "switch repo",
        },
    },
    opts = function()
        -- https://github.com/nvim-telescope/telescope.nvim#pickers
        local actions = require("telescope.actions")

        return {
            defaults = {
                winblend = 20, -- transparency
                path_display = { "relative" },
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
                results_title = false,
                prompt_title = false,
                preview = {
                    check_mime_type = true,
                    filesize_limit = 2, -- limit previewer to files under 2MB
                    timeout = 500,
                    treesitter = true,
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
        }
    end,
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)

        telescope.load_extension("fzf") -- native fzf
    end,
}
