local M = {}

local terminal_theme_file = os.getenv("HOME") .. "/.cache/terminal-theme"

---@return string?
function M.terminal_colorscheme()
    return os.getenv("TERMINAL_THEME") or require("pura_utils").read_to_string(terminal_theme_file, "*l")
end

---@return boolean
function M.dark_mode()
    local colorscheme = M.terminal_colorscheme()
    return colorscheme == nil or colorscheme:lower() == "dark"
end

---@return boolean
function M.light_mode()
    return not M.dark_mode()
end

return M
