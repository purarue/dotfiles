local M = {}
function M.mkview_check()
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

    if bufname == "" or vim.fn.glob(bufname) == "" then
        return false
    end

    local path = vim.fn.expand(":%p")
    if path:match("^/tmp/") or path:match("^/var/") then
        return false
    end

    return true
end
return M
