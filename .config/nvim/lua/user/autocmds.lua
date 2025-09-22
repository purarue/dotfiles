---create an autocmd group, clearing any existing commands
---test something  else here
---
---@param name string
local function clear_group(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
    desc = "highlight when yanking (copying) text",
    callback = function()
        vim.hl.on_yank()
    end,
    group = clear_group("YankHighlight"),
    pattern = "*",
})

local user_autocompile = clear_group("UserAutocompile")

autocmd("BufWritePost", {
    command = "!shortcuts create",
    group = user_autocompile,
    pattern = { "shortcuts.toml" },
    desc = "create shortcuts script when I save config file",
})

autocmd("BufWritePost", {
    command = "!i3-jinja",
    group = user_autocompile,
    pattern = { ".config/i3/config.j2", "i3/config.j2" },
    desc = "create i3 config when I save config file",
})

autocmd("BufWritePost", {
    command = "!rm -f $(evry location -i3blocks-cache)",
    group = user_autocompile,
    pattern = { ".config/i3blocks/config.*", "i3blocks/config.*" },
    desc = "clear i3blocks cache file when I save config",
})

autocmd("TermOpen", {
    desc = "enter insert mode when I open a terminal",
    command = "startinsert",
    group = clear_group("TerminalInsert"),
    pattern = "*",
})

autocmd("BufWinEnter", {
    group = clear_group("BufEnterLoadView"),
    callback = function()
        pcall(vim.cmd.loadview)
    end,
})

autocmd("BufWinLeave", {
    group = clear_group("BufLeaveMkView"),
    callback = function()
        pcall(vim.cmd.mkview)
    end,
})

--- converts a filename to a title
---@param name string
---@return string
local function unslugify(name)
    name = name:gsub("_", " "):match("(.+)%..+")
    name = name:sub(1, 1):upper() .. name:sub(2):lower()
    return name
end

--- frontmatter generator
---@param items table<string, string>
---@return string[]
local function frontmatter(items)
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
autocmd({ "BufNewFile" }, {
    desc = "Add metadata to new empty Markdown files",
    group = clear_group("NotesMarkdown"),
    pattern = { "*/Documents/Notes/exo/*.md", "*/Repos/exobrain/src/content/*.md" },
    callback = function(e)
        local buf = vim.api.nvim_buf_get_lines(e.buf, 0, -1, false) ---@type string[]
        -- if file is empty, the result is { "" }
        if #buf == 1 and buf[1] == "" then
            local items = frontmatter({ title = unslugify(vim.fn.expand("%:t")) })
            table.insert(items, "")
            vim.api.nvim_buf_set_lines(e.buf, 0, #items, false, items)
            vim.cmd("normal! G")
            vim.cmd.startinsert()
        end
    end,
})
