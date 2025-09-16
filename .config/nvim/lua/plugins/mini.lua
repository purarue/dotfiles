---@module 'lazy'
---@type LazyPluginSpec
return {
    "nvim-mini/mini.nvim",
    version = false,
    config = function()
        -- :hlep mini.ai
        --  - va)  - [V]isually select [A]round [)]paren
        --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
        --  - ci'  - [C]hange [I]nside [']quote
        require("mini.ai").setup() -- repeatable text motions
        -- :help mini.surround
        -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
        -- - sd'   - [S]urround [D]elete [']quotes
        -- - sr)'  - [S]urround [R]eplace [)] [']
        require("mini.surround").setup()
    end,
}
