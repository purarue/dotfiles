local M = {}

---reads the entire file to a string
---@param filename string
---@return string?
function M.read_to_string(filename)
    local f = io.open(filename, "r")
    if f then
        local content = f:read("*a")
        f:close()
        return content
    end
    return nil
end

--- removes spaces from start and end of a string
--- trim6 from https://lua-users.org/wiki/StringTrim
---@param s string
---@return string
function M.trim(s)
    return s:match("^()%s*$") and "" or s:match("^%s*(.*%S)")
end

return M
