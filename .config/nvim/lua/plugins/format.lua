local wk = require("which-key")

wk.register({':Format<CR>', 'format'}, {prefix = '<leader>t'})

return {
    'stevearc/conform.nvim',
    event = "VeryLazy",
    config = function()

        vim.api.nvim_create_user_command("Format", function(args)
            local range = nil
            if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1,
                                                            args.line2, true)[1]
                range = {
                    start = {args.line1, 0},
                    ["end"] = {args.line2, end_line:len()}
                }
            end
            require("conform").format({
                async = true,
                lsp_fallback = true,
                range = range
            }, function(err, did_edit)
                if err ~= nil then return end
                if did_edit then
                    vim.notify("Format successful", vim.log.levels.INFO)
                else
                    vim.notify("No formatting needed", vim.log.levels.INFO)
                end
            end)
        end, {range = true})

        local prettier_filetypes = {
            "javascript", "typescript", "yaml", "toml", "css", "scss", "html",
            "javascriptreact", "typescriptreact", "markdown"
        }

        local prettier_fts = {}
        for _, ft in ipairs(prettier_filetypes) do
            prettier_fts[ft] = {{"prettierd", "prettier"}}
        end

        local conform = require("conform")
        -- Use `:ConformInfo` to see the location of the log file.
        conform.setup({
            formatters_by_ft = vim.tbl_extend("keep", prettier_fts, {
                lua = {"lua-format"},
                go = {"goimports", "gofmt"},
                dosini = {"setup_cfg"},
                json = {"fixjson"},
                elixir = {"mix"},
                c = {"clang-format"},
                cpp = {"clang-format"},
                rust = {"rustfmt"},
                python = {"black"},
                sh = {"shfmt"},
                bash = {"shfmt"},
                -- run on all filetypes
                ["_"] = {"trim_whitespace"}
            }),
            log_level = vim.log.levels.INFO,
            notify_on_error = true,
            formatters = {
                setup_cfg = {
                    command = "setup-cfg-fmt-tempfile",
                    -- override the PWD environment variable to the directory of the setup.cfg
                    -- file. this is needed to discover stuff like the LICENSE/README
                    env = function()
                        return {["PWD"] = vim.fn.expand('%:h')}
                    end,
                    stdin = true,
                    cwd = require("conform.util").root_file({"setup.cfg"}),
                    -- When cwd is not found, don't run the formatter (default false)
                    require_cwd = true,
                    -- When returns false, the formatter will not be used
                    condition = function(_, ctx)
                        return vim.fs.basename(ctx.filename) == "setup.cfg"
                    end
                }
            }
        })

        conform.formatters.injected = {
            ignore_errors = false,
            lang_to_ext = {
                bash = "sh",
                javascript = "js",
                javascriptreact = "jsx",
                typescript = "ts",
                typescriptreact = "tsx",
                python = "py",
                rust = "rs",
                markdown = "md",
                elixir = "exs"
            }
        }
    end
}
