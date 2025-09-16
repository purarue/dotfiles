---@return boolean
local function codespell_enabled()
    -- disable on android
    if vim.g.on_android == true then
        return false
    end

    -- disable if my helper script isn't installed
    return vim.fn.executable("codespell-conf") == 1
end

---@module 'lazy'
---@type LazyPluginSpec
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

            local function fix_and_lint()
                require("user.codespell").codespell_fix()
                lint.try_lint("codespell")
            end

            vim.api.nvim_create_user_command("CodespellFix", fix_and_lint, {
                desc = "pick one of the codespell fixes and replace it in the line",
            })
            local mh = require("user.mapping_helpers")
            mh.nnoremap("<leader>z", fix_and_lint, "codespell fix")
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
