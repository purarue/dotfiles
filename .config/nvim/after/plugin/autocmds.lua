---create an autocmd group, clearing any existing commands
---test something  else here
---
---@param name string
local function clear_group(name)
    return vim.api.nvim_create_augroup(name, { clear = true })
end
local autocmd = vim.api.nvim_create_autocmd

autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.hl.on_yank()
    end,
    group = clear_group("YankHighlight"),
    desc = "highlight when yanking (copying) text",
})

local user_autocompile = clear_group("UserAutocompile")

autocmd("BufWritePost", {
    pattern = { "shortcuts.toml" },
    command = "!shortcuts create",
    group = user_autocompile,
    desc = "create shortcuts script when I save config file",
})

autocmd("BufWritePost", {
    pattern = { ".config/i3/config.j2", "i3/config.j2" },
    command = "!i3-jinja",
    group = user_autocompile,
    desc = "create i3 config when I save config file",
})

autocmd("BufWritePost", {
    pattern = { ".config/i3blocks/config.*", "i3blocks/config.*" },
    command = "!rm -f $(evry location -i3blocks-cache)",
    group = user_autocompile,
    desc = "clear i3blocks cache file when I save config",
})

autocmd("TermOpen", {
    pattern = "*",
    command = "startinsert",
    desc = "enter insert mode when I open a terminal",
    group = clear_group("TerminalInsert"),
})

-- if a file like filename.md is opened in
-- anything that uses yaml frontmatter
-- and its empty, add something like:
-- ---
-- title: Filename
-- ---
autocmd({ "BufNewFile", "BufEnter" }, {
    pattern = { "*/Documents/Notes/exo/*.md", "*/Repos/exobrain/src/content/*.md" },
    callback = function(e)
        return require("user.custom.frontmatter").generate_frontmatter(e.buf)
    end,
    group = clear_group("NotesMarkdown"),
    desc = "Add metadata to new empty Markdown files",
})
