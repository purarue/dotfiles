local M = {}

---@param s string?
---@return string[]
function M.string_to_list(s)
    if s == nil then
        return {}
    end
    return vim.iter(s:gmatch("[^\r\n]+")):totable()
end

---@param cmd string
---@return string[]
function M._command_list(cmd)
    local handle = io.popen(cmd, "r")
    local contents = require("pura_utils").read_filehandle_to_string(handle)
    return M.string_to_list(contents)
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
function M.dev_list()
    local contents = require("pura_utils").read_to_string(vim.fs.normalize("~/.cache/repo_bases.txt"))
    return M.string_to_list(contents)
end

return M
