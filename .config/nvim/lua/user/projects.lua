local M = {}

---@param cmd string
---@return string[]
function M._command_list_fzfcached(cmd)
    local handle = io.popen("fzfcache " .. cmd, "r")
    if handle == nil then
        return {}
    end
    local result = handle:read("*a")
    handle:close()
    local config = {} ---@type string[]
    for line in result:gmatch("[^\r\n]+") do
        table.insert(config, line)
    end
    return config
end

---@param list string[]
---@return {text: string, file: string}[]
function M._transform_items(list)
    local out = {}
    for _, item in ipairs(list) do
        table.insert(out, {
            text = item,
            file = item,
        })
    end
    return out
end

function M._config_finder()
    return M._transform_items(M._command_list_fzfcached("list-config-no-hist"))
end

function M.project_list()
    return M._command_list_fzfcached("list-my-git-repos")
end

return M
