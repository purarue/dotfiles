local M = {}

---@param cmd string
---@return string[]
function M._command_list(cmd)
    local handle = io.popen(cmd, "r")
    if handle == nil then
        return {}
    end
    local result = handle:read("*a")
    handle:close()
    return vim.iter(result:gmatch("[^\r\n]+")):totable()
end

---@param list string[]
---@return {text: string, file: string}[]
function M._transform_items(list)
    return vim.iter(list)
        :map(function(item)
            return {
                text = item,
                file = item,
            }
        end)
        :totable()
end

---@return {text: string, file: string}[]
function M._config_finder()
    return M._transform_items(M._command_list("list-config-no-hist"))
end

---@return string[]
function M.project_list()
    return M._command_list("list-my-git-repos")
end

return M
