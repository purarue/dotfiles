vim.keymap.set("n", "<leader>rr", function()
    vim.bo.makeprg = "python3 %"
    vim.cmd.make()
end, { desc = "run python file", buffer = 0 })

vim.keymap.set("n", "<leader>rt", function()
    vim.cmd.compiler("pytest")
    vim.cmd.make("%")
end, { desc = "run pytest", buffer = 0 })

vim.keymap.set("n", "<leader>rm", function()
    vim.bo.makeprg = "mypy --show-column-numbers --hide-error-codes --hide-error-context --no-color-output --no-error-summary %"
    vim.cmd.make()
end, { desc = "run mypy", buffer = 0 })
