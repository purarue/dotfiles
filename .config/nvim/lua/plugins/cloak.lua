---@module 'lazy'
---@type LazyPluginSpec
return {
    "laytan/cloak.nvim",
    event = "BufRead",
    keys = { { "<leader>C", "<Cmd>CloakToggle<CR>", "toggle cloak" } },
    -- 'https://github.com/laytan/cloak.nvim?tab=readme-ov-file#configuration'
    opts = {
        patterns = {
            {
                -- Match any file starting with '.env'.
                -- This can be a table to match multiple file patterns.
                file_pattern = ".env*",
                -- Match an equals sign and any character after it.
                -- This can also be a table of patterns to cloak,
                -- example: cloak_pattern = { ':.+', '-.+' } for yaml files.
                cloak_pattern = "=.+",
            },
        },
    },
}
