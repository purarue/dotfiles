---@class (exact) TreesitterConfig
---@field ensure_installed string[] list of parser names
---@field ft_to_treesitter table<string, string> map filetypes to treesitter parser names

---@module 'lazy'
---@type LazyPluginSpec[]
return {
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPre", "BufNewFile" },
        ---@module 'treesitter-context'
        ---@type TSContext.UserConfig
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
        build = ":TSUpdate",
        ---@type TreesitterConfig
        opts = {
            ft_to_treesitter = {},
            ensure_installed = {
                "astro",
                "awk",
                "bash",
                "c",
                "cmake",
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
                "kitty",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "muttrc",
                "nginx",
                "perl",
                "jinja",
                "jinja_inline",
                "php",
                "php_only",
                "po",
                "prisma",
                "python",
                "query",
                "readline",
                "regex",
                "requirements",
                "rifleconf",
                "robots",
                "rst",
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
            },
        },
        ---@param opts TreesitterConfig
        config = function(_, opts)
            -- NOTE: no setup() call required
            local TS = require("nvim-treesitter")

            -- From: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/treesitter.lua
            -- maintain a list of installed languages
            local installed = TS.get_installed("parsers")
            local install = vim.tbl_filter(function(lang)
                return not vim.tbl_contains(installed, lang)
            end, opts.ensure_installed)

            vim.api.nvim_create_user_command("TSInstall", function()
                TS.install(install, { summary = true }):await(function()
                    installed = TS.get_installed("parsers")
                end)
            end, {
                desc = "Install any missing parsers",
            })

            -- enable treesitter highlighting
            vim.api.nvim_create_autocmd("FileType", {
                -- no pattern, run on all files
                callback = function(event)
                    local lang = vim.treesitter.language.get_lang(event.match)
                    local matched = vim.tbl_contains(installed, lang)
                    local use_lang = nil
                    if not matched then
                        use_lang = opts.ft_to_treesitter[event.match]
                        matched = use_lang and vim.tbl_contains(installed, use_lang)
                    end
                    if matched then
                        -- vim.notify("TS highlighting for " .. (use_lang or lang), vim.log.levels.INFO, { title = "nvim-treesitter" })
                        -- ignore errors
                        pcall(vim.treesitter.start, event.buf, use_lang)
                        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                    end
                    -- this will otherwise fallback to vim indentexpr/syntax
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        after = "nvim-treesitter",
        event = { "VeryLazy" },
        branch = "main",
        -- dir = "~/Repos/nvim-treesitter-textobjects",
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
