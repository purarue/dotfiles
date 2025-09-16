---@module 'lazy'
---@type LazyPluginSpec
return {
    "lewis6991/gitsigns.nvim",
    dependencies = {
        {
            "purarue/gitsigns-yadm.nvim",
            lazy = true,
            -- dir = "~/Repos/gitsigns-yadm.nvim",
        },
        {
            "nvim-lua/plenary.nvim",
            lazy = true,
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
                { "<leader>hs", "<Cmd>Gitsigns stage_hunk<CR>", desc = "stage hunk", buffer = bufnr },
                { "<leader>hr", "<Cmd>Gitsigns reset_hunk<CR>", desc = "reset hunk", buffer = bufnr },
                { "<leader>hS", "<Cmd>Gitsigns stage_buffer<CR>", desc = "stage buffer", buffer = bufnr },
                { "<leader>hR", "<Cmd>Gitsigns reset_buffer<CR>", desc = "reset buffer", buffer = bufnr },
                { "<leader>hp", "<Cmd>Gitsigns preview_hunk<CR>", desc = "preview hunk", buffer = bufnr },
                { "<leader>hb", "<Cmd>lua require'gitsigns'.blame_line{full=true}<CR>", desc = "blame line", buffer = bufnr },
                { "<leader>ht", "<Cmd>Gitsigns toggle_current_line_blame<CR>", desc = "toggle line blame", buffer = bufnr },
                { "<leader>hd", "<Cmd>Gitsigns diffthis<CR>", desc = "diff this", buffer = bufnr },
                { "<leader>hT", "<Cmd>Gitsigns toggle_deleted<CR>", desc = "toggle deleted", buffer = bufnr },
            })
        end,
    },
}
