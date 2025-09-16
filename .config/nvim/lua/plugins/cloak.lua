---@module 'lazy'
---@type LazyPluginSpec
return {
    "laytan/cloak.nvim",
    event = "BufRead",
    keys = { {
        "<leader>C",
        function()
            require("cloak").toggle()
        end,
        "toggle cloak",
    } },
    opts = {
        patterns = {
            {
                file_pattern = ".env*",
                cloak_pattern = "=.+",
            },
        },
    },
}
