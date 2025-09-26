local M = {}

---@class (exact) MkviewCheck.Config
---@field checker fun():boolean additional function to be called during setup

---Check if mkview should be called
---@param options MkviewCheck.Config?
function M.mkview_check(options)
    local opts = options or { checker = nil }

    if vim.wo.diff then
        return false
    end
    if vim.bo.buftype ~= "" then
        return false
    end
    if not vim.bo.modifiable then
        return false
    end

    -- special files, like [No Name], [Command Output], etc
    local bufname = vim.api.nvim_buf_get_name(0)
    if bufname:match("%[.*%]") then
        return false
    end

    -- if file does not exist, skip writing
    if bufname == "" or not vim.uv.fs_stat(bufname) then
        return false
    end

    if opts.checker and type(opts.checker) == "function" then
        return opts.checker()
    end

    return true
end
return M
