local M = {}

-- shorter helper with nicer order, w/ types to warn me so
-- I have to provide a description
---@param mode string|table
---@param key string
---@param cmd string|function
---@param desc string
function M.map_key(key, cmd, desc, mode)
    vim.keymap.set(mode or "n", key, cmd, { noremap = true, nowait = false, desc = desc })
end

---map a key with semantics like nnoremap
---@param key string
---@param cmd string|function
---@param desc string
function M.nnoremap(key, cmd, desc)
    M.map_key(key, cmd, desc, "n")
end

---map a key with semantics like vnoremap
---@param key string
---@param cmd string|function
---@param desc string
function M.vnoremap(key, cmd, desc)
    M.map_key(key, cmd, desc, "v")
end

return M
