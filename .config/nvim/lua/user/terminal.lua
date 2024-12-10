local M = {}

function M.set_background()
    local ok, mod = pcall(require, "terminal_colorscheme")
    if not ok then
        vim.o.background = "dark"
    else
        -- vim.o to set global option
        vim.o.background = mod.dark_mode() and "dark" or "light"
    end
end

return M
