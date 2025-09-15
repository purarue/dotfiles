local treesitter_ignore_filetypes = {
    "blink-cmp-menu",
    "blink-cmp-documentation",
    "i3config",
    "rasi",
    "abook",
    "abookrc",
    "blink-cmp-signature",
    "zenmode-bg",
    "qf",
    "text",
    "snippets",
    "gitattributes",
    "conf",
    "TelescopePrompt",
    "TelescopeResults",
    "TelescopePreview",
    "fidget",
    "notify",
    "lazy",
    "lazy_backdrop",
    "DressingInput",
}

local install_languages = {
    "astro",
    "awk",
    "bash",
    "c",
    "commonlisp",
    "cpp",
    "css",
    "csv",
    "dart",
    "diff",
    "dockerfile",
    "eex",
    "elixir",
    "elm",
    "embedded_template",
    "erlang",
    "git_config",
    "git_rebase",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gosum",
    "graphql",
    "haskell",
    "heex",
    "html",
    "hyprlang",
    "ini",
    "java",
    "javascript",
    "jq",
    "json",
    "jsonc",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "muttrc",
    "nginx",
    "perl",
    "php",
    "po",
    "prisma",
    "python",
    "query",
    "regex",
    "requirements",
    "rifleconf",
    "robots",
    "ruby",
    "rust",
    "scss",
    "sql",
    "ssh_config",
    "templ",
    "todotxt",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
}

return {
    {
        "windwp/nvim-ts-autotag",
        opts = {},
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            enable = true,
            max_lines = 10,
            multiline_threshold = 5,
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        -- dir = "~/Files/OldRepos/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup() -- use the defaults
            require("nvim-treesitter").install(install_languages)

            -- enable treesitter highlighting
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "*" },
                callback = function(e)
                    local ft = e.match
                    if vim.list_contains(treesitter_ignore_filetypes, ft) then
                        return
                    end
                    local succeeded = pcall(vim.treesitter.start, e.buf)
                    if not succeeded then
                        vim.notify("treesitter failed to start for " .. ft, vim.log.levels.WARN, {
                            title = "nvim-treesitter",
                            timeout = 3000,
                        })
                    end
                end,
            })
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        event = { "VeryLazy" },
        branch = "main",
        opts = {
            select = {
                lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
                selection_modes = {
                    ["@parameter.outer"] = "v", -- charwise
                    ["@function.outer"] = "V", -- linewise
                    ["@class.outer"] = "<c-v>", -- blockwise
                },
                include_surrounding_whitespace = false,
            },
            move = {
                set_jumps = true, -- whether to set jumps in the jumplist
            },
        },
        keys = {
            -- selecting
            {
                "af",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "select around function (outer)",
            },
            {
                "if",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "select inside function (inner)",
            },
            {
                "ac",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "select around class (outer)",
            },
            {
                "ic",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "select inside class (inner)",
            },
            {
                "co",
                function()
                    require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects")
                end,
                mode = { "x", "o" },
                desc = "select around comment (outer)",
            },

            -- swaps
            {
                "<leader>a",
                function()
                    require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
                end,
                mode = "n",
                desc = "swap with next parameter (inner)",
            },
            {
                "<leader>A",
                function()
                    require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer")
                end,
                mode = "n",
                desc = "swap with previous parameter (outer)",
            },

            -- movement
            {
                "]m",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "next function start",
            },
            {
                "]]",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "next class start",
            },
            {
                "]o",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "next loop start",
            },
            {
                "]M",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "next function end",
            },
            {
                "][",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "next class end",
            },
            {
                "[m",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "previous function start",
            },
            {
                "[[",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "previous class start",
            },
            {
                "[M",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "previous function end",
            },
            {
                "[]",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "previous class end",
            },
            {
                "]d",
                function()
                    require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "next conditional (nearest)",
            },
            {
                "[d",
                function()
                    require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects")
                end,
                mode = { "n", "x", "o" },
                desc = "previous conditional (nearest)",
            },
        },
    },
}
