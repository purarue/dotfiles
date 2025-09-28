local M = {}

--- converts a filename to a title
---@param name string
---@return string
function M.unslugify(name)
    name = name:gsub("_", " "):match("(.+)%..+")
    name = name:sub(1, 1):upper() .. name:sub(2):lower()
    return name
end

--- frontmatter generator
---@param items table<string, string>
---@return string[]
function M.frontmatter(items)
    local res = { "---" }
    for k, v in pairs(items) do
        table.insert(res, k .. ": " .. v)
    end
    table.insert(res, "---")
    return res
end

-- if a file like filename.md is opened in
-- anything that uses yaml frontmatter
-- and its empty, add something like:

-- ---
-- title: Filename
-- ---

---@param bufnr number
---@return nil
function M.generate_frontmatter(bufnr)
    local buf = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) ---@type string[]
    -- if file is empty, the result is { "" }
    if #buf == 1 and buf[1] == "" then
        local items = M.frontmatter({ title = M.unslugify(vim.fn.expand("%:t")) })
        table.insert(items, "")
        vim.api.nvim_buf_set_lines(bufnr, 0, #items, false, items)
        vim.cmd("normal! G")
        vim.cmd.startinsert()
    end
end

return M
