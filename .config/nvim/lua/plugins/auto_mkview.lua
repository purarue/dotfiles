---@module 'lazy'
---@type LazyPluginSpec
return {
    "purarue/auto-mkview.nvim",
    event = "BufWinEnter",
    -- dir = "~/Repos/auto-mkview.nvim/",
    ---@module 'auto-mkview'
    ---@type AutoMkview.Config?
    opts = {
        create_mappings = true,
    },
}
