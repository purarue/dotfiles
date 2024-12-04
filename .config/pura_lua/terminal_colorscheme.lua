local M = {}

---@return string?
function M.terminal_colorscheme()
    local filename = os.getenv("HOME") .. "/.cache/terminal-theme"
    local f = io.open(filename, "r")
    if f ~= nil then
        return f:read()
    end
    return nil
end

---@return boolean
function M.dark_mode()
    local colorscheme = M.terminal_colorscheme()
    if colorscheme == nil then
        return true
    end
    if colorscheme:lower() == "dark" then
        return true
    end
    return false
end

---@return boolean
function M.light_mode()
    return not M.dark_mode()
end

return M
