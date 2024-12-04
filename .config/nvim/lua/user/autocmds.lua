---create an autocmd group, clearing any existing commands
---test something  else here
---
---@param name string
local function clear_group(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
    desc = "highlight when yanking (copying) text",
    callback = function()
        vim.highlight.on_yank()
    end,
    group = clear_group("YankHighlight"),
    pattern = "*",
})

local user_autocompile = clear_group("UserAutocompile")

vim.api.nvim_create_autocmd("BufWritePost", {
    command = "!reshortcuts",
    group = user_autocompile,
    pattern = { "shortcuts.toml" },
    desc = "create shortcuts script when I save config file",
})

vim.api.nvim_create_autocmd("BufWritePost", {
    command = "!i3-jinja",
    group = user_autocompile,
    pattern = { ".config/i3/config.j2", "i3/config.j2" },
    desc = "create i3 config when I save config file",
})

vim.api.nvim_create_autocmd("BufWritePost", {
    command = "!rm -f $(evry location -i3blocks-cache)",
    group = user_autocompile,
    pattern = { ".config/i3blocks/config.*", "i3blocks/config.*" },
    desc = "clear i3blocks cache file when I save config",
})

vim.api.nvim_create_autocmd("TermOpen", {
    desc = "enter insert mode when I open a terminal",
    command = "startinsert",
    group = clear_group("TerminalInsert"),
    pattern = "*",
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
    desc = "disable LLM-generation for .env files",
    group = clear_group("LlmGroup"),
    pattern = { ".env", ".env.*" },
    callback = function()
        vim.b["codeium_enabled"] = false
    end,
})

--- converts a filename to a title
---@param name string
---@return string
local function unslugify(name)
    name = name:gsub("_", " "):match("(.+)%..+")
    name = name:sub(1, 1):upper() .. name:sub(2)
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
vim.api.nvim_create_autocmd({ "BufEnter", "BufNewFile" }, {
    desc = "Add metadata to new empty Markdown files",
    group = clear_group("NotesMarkdown"),
    pattern = { "*/Documents/Notes/exo/*.md", "*/Repos/exobrain/src/content/*.md" },
    callback = function()
        local file_size = vim.fn.getfsize(vim.fn.expand("%"))

        if file_size <= 0 then
            local items = frontmatter({ title = unslugify(vim.fn.expand("%:t")) })
            for line_no, content in ipairs(items) do
                vim.fn.append(line_no - 1, content)
            end
            vim.cmd("normal! G")
            vim.cmd.startinsert()
        end
    end,
})
