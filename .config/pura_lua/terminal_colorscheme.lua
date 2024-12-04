local M = {}

local utils = require("pura_utils")

local terminal_theme_file = os.getenv("HOME") .. "/.cache/terminal-theme"

---@return string?
function M.terminal_colorscheme()
    return utils.read_to_string(terminal_theme_file)
end

---@return boolean
function M.dark_mode()
    local colorscheme = M.terminal_colorscheme()
    return colorscheme == nil or utils.trim(colorscheme:lower()) == "dark"
end

---@return boolean
function M.light_mode()
    return not M.dark_mode()
end

return M
