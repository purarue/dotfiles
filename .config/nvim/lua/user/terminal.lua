local M = {}

function M.set_background()
    -- vim.o to set global option
    vim.o.background = require("terminal_colorscheme").dark_mode() and "dark" or "light"
end

return M
