-- vim.o sets global options, vim.opt sets buffer-local options
-- see :help vim-differences for some defaults set in nvim
-- for :help syntax, treesitter will disable this for filetypes it knows, otherwise
-- syntax highlighting is enabled by default
vim.opt.number = true
vim.opt.relativenumber = true -- line number
-- Blink cursor on error instead of beeping
vim.opt.visualbell = true

-- disable intro message
vim.opt.shortmess:append("I")

-- Whitespace
vim.opt.wrap = true
vim.opt.textwidth = 0 -- stop line wrapping
vim.opt.formatoptions = "tcqrn1"

-- disable folding
vim.opt.foldenable = false

-- set tab config local to buffer
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- can use :grep "something" to search with rg recursively to populate the quickfix list
-- to include hidden files, pass rg flags like :grep -uu "something"
vim.opt.grepprg = "rg --vimgrep"

-- cursor motion
vim.opt.scrolloff = 8
vim.opt.matchpairs:append("<:>")

-- save spellfile to my Documents
local os = require("os")
local spellfile = os.getenv("NVIM_SPELLFILE")
if spellfile then
    vim.opt.spellfile = spellfile
    vim.api.nvim_create_user_command("Spellfile", function()
        vim.cmd.edit(spellfile)
    end, {
        desc = "open the spellfile for me to edit",
    })
end

-- only show status line for last window
vim.opt.laststatus = 3

-- transparency
vim.opt.pumblend = 10
vim.opt.winblend = 10

-- searching
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showmatch = false -- I don't like the cursor jumping back, is distracting. also looks strange with ghosttext

-- spacing/tabs/newlines
vim.opt.list = true
vim.opt.listchars:append({ tab = "▸ ", eol = "¬" })
vim.opt.breakindent = true -- wrapped lines indent
vim.opt.signcolumn = "yes"
vim.opt.linebreak = true

-- prevents truncated yanks, deletes, etc.
-- makes sure that you can have lots of lines across
-- files/vim instances without truncating the buffer
vim.opt.viminfo = "'20,<1000,s1000"

-- marks
vim.opt.shada = "'1000,f1,<100"

-- enable persistent undo (save undo history across file closes) if possible
vim.opt.undofile = true

-- path
vim.opt.path:append("**")
vim.opt.wildmode = { "longest", "list", "full" }
vim.opt.completeopt = "menuone,noselect"
vim.opt.wildignore:append({
    "*__pycache__/*",
    "*.mypy_cache/*",
    "*.pytest_cache/*",
    "*egg-info/*",
    "*_build/*",
    "**/coverage/*",
    "**/node_modules/*",
    "**/dist/*",
    "**/build/*",
    "**/.git/*",
})

vim.diagnostic.config({ virtual_text = true, virtual_lines = { current_line = true } })
vim.opt.winborder = "rounded"

-- create binding for my remsync code
vim.api.nvim_create_user_command("Remsync", function(opts)
    require("user.custom.remsync").tohtml({
        sync = vim.list_contains(opts.fargs, "sync"),
        number_lines = vim.list_contains(opts.fargs, "lines"),
        no_relative_lines = vim.list_contains(opts.fargs, "norelativenumber"),
    })
end, {
    desc = "Convert buffer to HTML and sync to a tempfile on my website",
    nargs = "*",
    -- defer loading the module
    complete = function(...)
        return require("user.custom.remsync").complete_no_duplicates({ "lines", "sync", "norelativenumber" })(...)
    end,
})
