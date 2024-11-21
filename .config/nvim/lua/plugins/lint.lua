---@return boolean
local function codespell_enabled()
    -- disable on android
    if vim.g.on_android == true then
        return false
    end

    -- disable if my helper script isn't installed
    return vim.fn.executable("codespell-conf") == 1
end

return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "Codespell",
    config = function()
        local lint = require("lint")
        -- overwrite the linters_by_ft variable
        lint.linters_by_ft = { python = { "flake8" } }

        -- filetypes to check misspelled words in
        local codespell_fts = {
            "python",
            "markdown",
            "lua",
            "text",
            "javascript",
            "typescript",
            "typescriptreact",
            "javascriptreact",
            "prisma",
            "plaintext",
            "rst",
            "sh",
            "zsh",
            "rst",
            "gitcommit",
            "go",
            "rust",
            "elixir",
            "make",
        }

        -- some custom wrapper commands that use my global config files
        require("lint.linters.flake8").cmd = "flake8c"
        if codespell_enabled() then
            require("lint.linters.codespell").cmd = "codespell-conf"
            for _, ft in pairs(codespell_fts) do
                if lint.linters_by_ft[ft] then
                    table.insert(lint.linters_by_ft[ft], "codespell")
                else
                    lint.linters_by_ft[ft] = { "codespell" }
                end
            end

            -- parse the diagnostics to let me select one of the suggested
            -- codespell fixes interactively
            local fix = function()
                -- get current line, check if there are any diagnostics on that line
                local bufnr = vim.api.nvim_get_current_buf()
                local curline = vim.fn.line(".") - 1

                ---@type vim.Diagnostic[]
                local diagnostics = vim.diagnostic.get(bufnr)

                ---@type vim.Diagnostic[]
                local misspellings = vim.iter(diagnostics)
                    :filter(function(d)
                        return d.source == "codespell"
                    end)
                    :totable()

                table.sort(misspellings, function(a, b)
                    return a.lnum < b.lnum
                end)

                -- if there's one on the current line, use that, otherwise
                -- pick the next item
                ---@type vim.Diagnostic|nil
                local chosen = vim.iter(misspellings):find(function(d)
                    return d.lnum == curline
                end)
                if chosen == nil then
                    -- search going forwards, for the first item
                    for _, d in ipairs(misspellings) do
                        if d.lnum > curline then
                            chosen = d
                            break
                        end
                    end
                    -- if still not found, just use the first; wrap around
                    if chosen == nil then
                        chosen = misspellings[1]
                    end
                end

                if chosen == nil then
                    return vim.notify("No misspelled words")
                end

                -- jump to that location
                vim.fn.cursor(chosen.lnum + 1, chosen.col + 1)
                -- parse possible corrections from the message
                local parts = vim.split(chosen.message, " ==> ")
                if #parts ~= 2 then
                    return vim.notify("Could not split " .. chosen.message .. " into parts")
                end
                ---@desc Replace the word under the cursor with with 'choice'
                ---@param choice string|nil
                local replace = function(choice)
                    if choice == nil then
                        return
                    end
                    -- replace that word in the line
                    local old = vim.fn.getline(chosen.lnum + 1)
                    vim.fn.setline(chosen.lnum + 1, old:sub(1, chosen.col) .. choice .. old:sub(chosen.end_col + 1))
                    -- re-run codespell so I can spam this to fix all misspelled words
                    lint.try_lint("codespell")
                end
                -- even if there's one option, I should confirm so it doesn't replace something
                -- I was not expecting
                vim.ui.select(vim.split(parts[2], ", "), { prompt = "Replace '" .. parts[1] .. "' with" }, replace)
            end

            vim.api.nvim_create_user_command("CodespellFix", fix, {
                desc = "pick one of the codespell fixes and replace it in the line",
            })
            local mh = require("user.mapping_helpers")
            mh.nnoremap("<leader>z", fix, "codespell fix")
        end

        -- Note: nvim-lint has an internal list of pre-enabled linters
        -- you can disable by doing something like:
        -- lint.linters_by_ft['json'] = nil

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
            group = vim.api.nvim_create_augroup("RunLinter", { clear = true }),
            callback = function()
                lint.try_lint()
            end,
            desc = "run linter",
        })

        vim.api.nvim_create_user_command("Codespell", function()
            lint.try_lint("codespell")
        end, { desc = "run codespell" })
    end,
}
