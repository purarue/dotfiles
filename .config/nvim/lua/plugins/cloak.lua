---@module 'lazy'
---@type LazyPluginSpec
return {
    "laytan/cloak.nvim",
    event = "BufRead",
    keys = {
        {
            "<leader>C",
            function()
                require("cloak").toggle()
            end,
            desc = "toggle cloak",
        },
    },
    --- NOTE: no setup types
    opts = {
        patterns = {
            {
                file_pattern = ".env*",
                cloak_pattern = "=.+",
            },
        },
    },
}
