-- if this is in a directory called 'tmp', this is probably me using the
-- zsh edit-command-line widget set it to bash so I get nice treesitter
-- highlighting, including for embedded languages (e.g. awk/jq)
-- (see queries/bash/injections.scm)
local dirname = vim.fn.expand("%:h")
local parent_dir = vim.fs.basename(dirname)
vim.notify(parent_dir)
if parent_dir == "tmp" then
    vim.bo.filetype = "bash"
end
