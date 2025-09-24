---@module 'lazy'
---@type LazyPluginSpec
return {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = { { "<leader>t", "<Cmd>Format<CR>", desc = "format" } },
    opts = function()
        local prettier_filetypes = {
            "javascript",
            "typescript",
            "yaml",
            "css",
            "scss",
            "html",
            "javascriptreact",
            "typescriptreact",
            "markdown",
        }

        local prettier_fts = {}
        for _, ft in ipairs(prettier_filetypes) do
            prettier_fts[ft] = { "prettierd", "eslint_d" }
        end

        ---@module 'conform'
        ---@type conform.setupOpts
        return {
            default_format_opts = {
                timeout_ms = 500,
                async = false,
                quiet = false,
                lsp_format = "fallback",
            },
            formatters_by_ft = vim.tbl_extend("keep", prettier_fts, {
                lua = { "stylua" },
                go = { "goimports", "gofmt" },
                dosini = { "setup_cfg" },
                json = { "fixjson" },
                elixir = { "mix" },
                templ = { "templ" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                python = { "black" },
                toml = { "taplo" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                -- NOTE: if there's a fallback here, it won't use LSP fallback
                -- can use ["*"] to run on every filetype
            }),
            log_level = vim.log.levels.INFO,
            formatters = {
                -- https://purarue.xyz/d/styluac?redirect
                stylua = {
                    command = "styluac",
                },
                eslint_d = {
                    timeout_ms = 3000,
                },
                setup_cfg = {
                    command = "setup-cfg-fmt-tempfile",
                    -- override the PWD environment variable to the directory of the setup.cfg
                    -- file. this is needed to discover stuff like the LICENSE/README
                    env = function()
                        return { PWD = vim.fn.expand("%:h") }
                    end,
                    stdin = true,
                    cwd = require("conform.util").root_file({ "setup.cfg" }),
                    -- When cwd is not found, don't run the formatter (default false)
                    require_cwd = true,
                    -- When returns false, the formatter will not be used
                    condition = function(_, ctx)
                        return vim.fs.basename(ctx.filename) == "setup.cfg"
                    end,
                },
            },
        }
    end,
    config = function(_, opts)
        local conform = require("conform")
        conform.setup(opts)

        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = {
                    ["start"] = { args.line1, 0 },
                    ["end"] = { args.line2, end_line:len() },
                }
            end
            conform.format({
                range = range,
            }, function(err, did_edit)
                if err ~= nil then
                    return
                end
                if did_edit then
                    vim.print("Formatted successful")
                else
                    vim.print("No format needed")
                end
            end)
        end, { range = true })
    end,
}
