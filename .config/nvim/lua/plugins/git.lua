---@module 'lazy'
---@type LazyPluginSpec[]
return {
    {
        "tpope/vim-dispatch",
        cmd = { "Dispatch", "Make", "Focus", "Start" },
    },
    {
        "tpope/vim-fugitive",
        config = function()
            vim.cmd("command Push G! push")
            vim.cmd("command Pull G! pull")
            vim.cmd("command -nargs=1 Commit Dispatch! git commit -m <args>")
            vim.cmd("command -nargs=* K Dispatch git <args>")
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        dependencies = {
            {
                "purarue/gitsigns-yadm.nvim",
                lazy = true,
                -- dir = "~/Repos/gitsigns-yadm.nvim",
                ---@module 'gitsigns-yadm'
                ---@type GitsignsYadm.Config
                opts = {
                    on_yadm_attach = function()
                        vim.b.yadm_tracked = true
                        vim.fn.FugitiveDetect(require("gitsigns-yadm").config.yadm_repo_git)
                    end,
                },
            },
        },
        --- can't use type config validation here because it expects an exact class with non nullable fields?
        opts = {
            signs = {
                add = { text = "│" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
                untracked = { text = "┆" },
            },
            _on_attach_pre = function(bufnr, callback)
                if vim.fn.executable("yadm") == 1 then
                    require("gitsigns-yadm").yadm_signs(callback, { bufnr = bufnr })
                else
                    callback()
                end
            end,
            -- debug_mode = true,
            on_attach = function(bufnr)
                local wk = require("which-key")

                local function map(mode, lhs, rhs, opts)
                    opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
                    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
                end

                -- Navigation
                map("n", "]h", "&diff ? ']c' : '<Cmd>Gitsigns next_hunk<CR>'", { desc = "next git hunk", expr = true })
                map("n", "[h", "&diff ? '[c' : '<Cmd>Gitsigns prev_hunk<CR>'", { desc = "prev git hunk", expr = true })

                wk.add({ "<leader>h", group = "git hunk", buffer = bufnr })

                -- Text objects
                wk.add({
                    { "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>", desc = "stage hunk", buffer = bufnr, icon = "" },
                    { "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>", desc = "reset hunk", buffer = bufnr, icon = "" },
                    { "<leader>hS", "<Cmd>Gitsigns stage_buffer<CR>", desc = "stage buffer", buffer = bufnr, icon = "" },
                    { "<leader>hR", "<Cmd>Gitsigns reset_buffer<CR>", desc = "reset buffer", buffer = bufnr, icon = "" },
                    { "<leader>hp", "<Cmd>Gitsigns preview_hunk<CR>", desc = "preview hunk", buffer = bufnr, icon = "" },
                    {
                        "<leader>hb",
                        "<Cmd>Gitsigns toggle_current_line_blame<CR>",
                        desc = "blame line",
                        buffer = bufnr,
                        icon = "",
                    },
                    {
                        "<leader>gt",
                        "<Cmd>Gitsigns toggle_current_line_blame<CR>",
                        desc = "toggle line blame",
                        buffer = bufnr,
                        icon = "",
                    },
                    { "<leader>hd", "<Cmd>Gitsigns diffthis<CR>", desc = "diff this", buffer = bufnr, icon = "" },
                    { "<leader>gD", "<Cmd>Gitsigns toggle_deleted<CR>", desc = "toggle deleted", buffer = bufnr, icon = "" },
                    { "<leader>gw", "<Cmd>Gitsigns toggle_word_diff<CR>", desc = "toggle word diff", buffer = bufnr, icon = "" },
                })
            end,
        },
    },
}
