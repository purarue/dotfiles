local gr = vim.api.nvim_create_augroup("user.autocmds", { clear = true })

---@param event vim.api.keyset.events|vim.api.keyset.events[] events that trigger this
---@param pattern string|string[] pattern to match filename
---@param action function|string function/vimscript to execute
---@param desc string description of the autocmd
local function au(event, pattern, action, desc)
    local opts = { group = gr, pattern = pattern, desc = desc }
    if type(action) == "string" then
        opts.command = action
    else
        opts.callback = action
    end
    vim.api.nvim_create_autocmd(event, opts)
end

-- stylua: ignore
local hl_on_yank = function() vim.hl.on_yank() end
au("TextYankPost", "*", hl_on_yank, "highlight when yanking (copying) text")
au("BufWritePost", "shortcuts.toml", "!shortcuts create", "create shortcuts script when I save config file")
au("TermOpen", "*", "startinsert", "enter insert mode when I open a terminal")
au({ "BufNewFile", "BufEnter" }, { "*/Documents/Notes/exo/*.md", "*/Repos/exobrain/src/content/*.md" }, function(e)
    return require("user.custom.frontmatter").generate_frontmatter(e.buf)
end, "Add metadata to new empty Markdown files")
au({ "BufNewFile", "BufEnter" }, { "*/*interview*/*" }, function()
    vim.opt_local.cursorcolumn = true
    vim.opt_local.cursorline = true
end, "enable cursor line/cursor column if Im sharing screen with someone")
