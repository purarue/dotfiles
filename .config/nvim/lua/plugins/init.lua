return {
    {
        "folke/which-key.nvim",
        lazy = true,
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {},
    },
    -- while in visual mode
    -- []x to encode/decode HTML, []u to encode/decode URLs, []y to do C-style escaping
    {
        "purarue/vim-unimpaired-conversions",
        keys = { { "[", mode = "v" }, { "]", mode = { "v" } } },
    },
    {
        "airblade/vim-rooter",
        event = "BufWinEnter",
        init = function()
            -- change directory in the window's local directory instead of the whole application
            vim.g.rooter_cd_cmd = "lcd"
            vim.g.rooter_silent_chdir = 1
            vim.g.rooter_patterns = {
                ".git",
                "Makefile",
                "setup.py",
                "pyproject.toml",
                "package.json",
                "stylua.toml",
            }
        end,
    },
    { "nvim-lua/plenary.nvim", lazy = true },
}
