local ensure_installed = {
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
    "dtd",
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
    "php_only",
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
    "tsv",
    "tsx",
    "typescript",
    "vim",
    "vimdoc",
    "xml",
    "yaml",
}

---@module 'lazy'
---@type LazyPluginSpec[]
return {
    {
        "windwp/nvim-ts-autotag",
        event = "InsertEnter",
        opts = function()
            local default_opts = {
                enable_close = true,
                enable_rename = true,
            }

            ---@module 'nvim-ts-autotag.config.plugin'
            ---@type nvim-ts-autotag.PluginSetup
            return {
                per_filetype = {
                    html = default_opts,
                    xml = default_opts,
                    jsx = default_opts,
                    tsx = default_opts,
                    markdown = default_opts,
                    astro = default_opts,
                },
            }
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            enable = true,
            max_lines = 10,
            multiline_threshold = 20,
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        -- dir = "~/Files/OldRepos/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local TS = require("nvim-treesitter")
            -- NOTE: no setup() call required

            -- From: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/ui/treesitter-main.lua
            -- maintain a list of installed languages
            local installed = TS.get_installed("parsers")
            local install = vim.tbl_filter(function(lang)
                return not vim.tbl_contains(installed, lang)
            end, ensure_installed)

            -- if there are any missing parsers, install them
            if #install > 0 then
                TS.install(install, { summary = true })
                vim.list_extend(installed, install)
            end

            -- use bash treesitter highlighting for zsh files
            vim.treesitter.language.register("bash", "zsh")

            -- enable treesitter highlighting
            vim.api.nvim_create_autocmd("FileType", {
                -- no pattern, run on all files
                callback = function(event)
                    local lang = vim.treesitter.language.get_lang(event.match)
                    if vim.tbl_contains(installed, lang) then
                        -- ignore errors
                        pcall(vim.treesitter.start)
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
        dir = "~/Repos/nvim-treesitter-textobjects",
        ---@module 'nvim-treesitter-textobjects.configs'
        ---@type TSTextObjects.UserConfig
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
            -- stylua: ignore start
            -- selecting
            { "af", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end, mode = { "x", "o" }, desc = "select around function (outer)" },
            { "if", function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end, mode = { "x", "o" }, desc = "select inside function (inner)" },
            { "ac", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end, mode = { "x", "o" }, desc = "select around class (outer)" },
            { "ic", function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end, mode = { "x", "o" }, desc = "select inside class (inner)" },
            { "co", function() require("nvim-treesitter-textobjects.select").select_textobject("@comment.outer", "textobjects") end, mode = { "x", "o" }, desc = "select around comment (outer)" },
            -- swaps
            { "<leader>a", function() require("nvim-treesitter-textobjects.swap").swap_next("@parameter.outer") end, mode = "n", desc = "swap with next parameter (inner)" },
            { "<leader>A", function() require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.outer") end, mode = "n", desc = "swap with previous parameter (outer)" },
            -- movement
            { "]m", function() require("nvim-treesitter-textobjects.move").goto_next_start("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "next function start" },
            { "]]", function() require("nvim-treesitter-textobjects.move").goto_next_start("@class.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "next class start" },
            { "]o", function() require("nvim-treesitter-textobjects.move").goto_next_start({ "@loop.inner", "@loop.outer" }, "textobjects") end, mode = { "n", "x", "o" }, desc = "next loop start" },
            { "]M", function() require("nvim-treesitter-textobjects.move").goto_next_end("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "next function end" },
            { "][", function() require("nvim-treesitter-textobjects.move").goto_next_end("@class.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "next class end" },
            { "[m", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "previous function start" },
            { "[[", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@class.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "previous class start" },
            { "[M", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@function.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "previous function end" },
            { "[]", function() require("nvim-treesitter-textobjects.move").goto_previous_end("@class.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "previous class end" },
            { "]d", function() require("nvim-treesitter-textobjects.move").goto_next("@conditional.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "next conditional (nearest)" },
            { "[d", function() require("nvim-treesitter-textobjects.move").goto_previous("@conditional.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "previous conditional (nearest)" },
            { "]c", function() require("nvim-treesitter-textobjects.move").goto_next_start("@comment.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "next comment start" },
            { "[c", function() require("nvim-treesitter-textobjects.move").goto_previous_start("@comment.outer", "textobjects") end, mode = { "n", "x", "o" }, desc = "previous comment start" },
            -- stylua: ignore end
        },
    },
}
