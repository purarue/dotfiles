-- vim.o sets global options, vim.opt sets buffer-local options
-- see :help vim-differences for some defaults set in nvim
-- for :help syntax, treesitter will disable this for filetypes it knows, otherwise
vim.cmd([[filetype plugin indent on]])

-- lines
vim.o.number = true
vim.o.relativenumber = true

-- Blink cursor on error instead of beeping
vim.o.visualbell = true

-- shorten some messages
vim.opt.shortmess:append("IcCwa")

-- Whitespace
vim.o.wrap = true
vim.o.textwidth = 0 -- stop line wrapping
vim.o.formatoptions = "tcqrn1"

-- dont save options when using mkview/loadview
-- prevents things like cwd from saving
vim.opt.viewoptions:remove("options")
vim.opt.viewoptions:remove("curdir")

-- disable folding
vim.o.foldenable = false

-- backups
vim.o.backup = false
vim.o.writebackup = false

-- splits
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.splitkeep = "screen"

-- set tab config local to buffer
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

-- can use :grep "something" to search with rg recursively to populate the quickfix list
-- to include hidden files, pass rg flags like :grep -uu "something"
vim.opt.grepprg = "rg --vimgrep"

-- cursor motion
vim.o.scrolloff = 8
vim.opt.matchpairs:append("<:>")

-- save spellfile to my Documents
local os = require("os")
local spellfile = os.getenv("NVIM_SPELLFILE")
if spellfile then
    vim.o.spellfile = spellfile
    vim.api.nvim_create_user_command("Spellfile", function()
        vim.cmd.edit(spellfile)
    end, {
        desc = "open the spellfile for me to edit",
    })
end

-- only show status line for last window
vim.o.laststatus = 3

-- transparency/windows
vim.o.pumblend = 10
vim.o.winblend = 10
vim.o.pumheight = 10
vim.o.winborder = "rounded"

-- searching
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.infercase = true
vim.o.showmatch = false -- I don't like the cursor jumping back, is distracting. also looks strange with ghosttext

-- spacing/tabs/newlines
vim.o.list = true
vim.opt.listchars:append({ tab = "▸ ", eol = "¬" })
vim.o.breakindent = true -- wrapped lines indent
vim.o.signcolumn = "yes"
vim.o.fillchars = "eob: " -- Don't show `~` outside of buffer
vim.o.linebreak = true

-- prevents truncated yanks, deletes, etc.
-- makes sure that you can have lots of lines across
-- files/vim instances without truncating the buffer
vim.o.viminfo = "'20,<1000,s1000"

-- marks
vim.o.shada = "'1000,f1,<100"

-- enable persistent undo (save undo history across file closes) if possible
vim.o.undofile = true

-- path
vim.opt.path:append("**")
vim.o.wildmode = "longest,list,full"
vim.o.completeopt = "menuone,noselect"
vim.o.virtualedit = "block"
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

vim.diagnostic.config({
    severity_sort = true,
    float = { border = "rounded", source = "if_many" },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
    },
    virtual_text = {
        source = "if_many",
        spacing = 2,
    },
    virtual_lines = false,
})

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
