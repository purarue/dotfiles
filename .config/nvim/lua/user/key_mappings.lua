local wk = require("which-key")

local mh = require("user.custom.mapping_helpers")
local map_key = mh.map_key
local nnoremap = mh.nnoremap
local vnoremap = mh.vnoremap

map_key("<Down>", "<Nop>", "disable arrow keys", { "i", "n", "x" })
map_key("<Left>", "<Nop>", "disable arrow keys", { "i", "n", "x" })
map_key("<Right>", "<Nop>", "disable arrow keys", { "i", "n", "x" })
map_key("<Up>", "<Nop>", "disable arrow keys", { "i", "n", "x" })
-- gq is used for formatting, e.g. gqip to format a paragraph, gqq to format a line
map_key("Q", "gq", "reformat lines", { "n", "v" })

nnoremap("/", "/\\v", "incremental search")
nnoremap("/", "/\\v", "incremental search")
nnoremap("<leader>y", 'V"+y', "copy to clipboard")
vnoremap("<leader>y", '"+y', "copy to clipboard")

-- swap wrapped lines behavior:
nnoremap("j", "gj", "move wrapped line down")
nnoremap("k", "gk", "move wrapped line up")
nnoremap("gj", "j", "move line down")
nnoremap("gk", "k", "move line up")

-- zz keeps the cursor in the middle of the screen
nnoremap("<C-u>", "<C-u>zz", "centered page up")
nnoremap("<C-d>", "<C-d>zz", "centered page down")
nnoremap("n", "nzz", "centered next")
nnoremap("N", "Nzz", "centered prev")
nnoremap("G", "Gzz", "centered goto line")
nnoremap("gg", "ggzz", "centered goto line")
nnoremap("<C-i>", "<C-i>zz", "centered next jump")
nnoremap("<C-o>", "<C-o>zz", "centered prev jump")
nnoremap("%", "%zz", "centered match")
nnoremap("*", "*zz", "centered match")
nnoremap("#", "#zz", "centered match")

-- U (opposite of u) for redo
nnoremap("U", "<C-r>", "redo")

-- when I press !B (holding shift for both)
nnoremap("!B", ":.!bash<CR>", "run shell command")
vnoremap("!B", ":.!bash<CR>", "run shell command")

vnoremap("J", ":move '>+1<CR>gv=gv", "move selected text down")
vnoremap("K", ":move '<-2<CR>gv=gv", "move selected text up")

-- save the current view when closing a buffer,
-- even if there are multiple of that buffer open
nnoremap("ZZ", function()
    pcall(vim.cmd.mkview)
    vim.cmd("x")
end, "save view and close window")

nnoremap("J", "mzJ`z", "append to line")

---@param n number
local function leftn(n)
    return string.rep("<Left>", n)
end

-- start a :%s/ search with the selected text, prompting for the replacement
vnoremap("<C-n>", 'y:%s/<C-r>"//gc' .. leftn(3), "search and replace")
-- in normal mode, use the next word as the search term
nnoremap("<C-n>", 'yiw:%s/<C-r>"//gc' .. leftn(3), "search and replace")
-- just start a search/replace and move me to where I can start typing
-- note: overwrites default <C-f> (forward one page)
nnoremap("<C-f>", ":%s///gcI" .. leftn(5), "empty search and replace")
vnoremap("<C-f>", ":s///gcI" .. leftn(5), "empty search and replace on selection")

nnoremap("<Esc>", vim.cmd.nohlsearch, "clear search highlight")

-- misc
wk.add({
    { "<leader>X", ":w<CR>:!chmod +x %<CR>:edit<CR>", desc = "chmod +x" },
    -- reload config
    {
        "<leader>S",
        function()
            vim.cmd("source ~/.config/nvim/lua/user/options.lua")
            vim.cmd("source ~/.config/nvim/lua/user/key_mappings.lua")
            print("Reloaded config")
        end,
        desc = "reload config",
    },
    -- mnemonic 'cd' binding
    {
        "<leader>cd",
        function()
            local filename = vim.fn.expand("%:p:h")
            local cmd = "cd " .. filename
            vim.cmd(cmd)
            vim.notify("cd " .. filename)
        end,
        desc = "cd to curdir",
    },
}, { prefix = "<leader>" })

-- window/buffers
wk.add({ "<leader>b", "<C-^>", desc = "swap buffers" })
-- use WhichKey so I can see the mappings
nnoremap("<leader>w", function()
    wk.show("<C-w>")
end, "window")

wk.add({
    { "<leader>j", ":cnext<CR>", desc = "qf next" },
    { "<leader>k", ":cprev<CR>", desc = "qf prev" },
})

-- stylua: ignore start
wk.add({
    { "]w", function() vim.diagnostic.jump({ count = 1 }) vim.api.nvim_feedkeys("zz", "n", false) end, desc = "next diagnostic", },
    { "[w", function() vim.diagnostic.jump({ count = -1 }) vim.api.nvim_feedkeys("zz", "n", false) end, desc = "prev diagnostic", },
    { "]e", function() vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR, }) vim.api.nvim_feedkeys("zz", "n", false) end, desc = "next error", },
    { "[e", function() vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR, }) vim.api.nvim_feedkeys("zz", "n", false) end, desc = "prev error", },
    { "D", vim.diagnostic.open_float, desc = "diagnostic hover" },
})
-- stylua: ignore end
