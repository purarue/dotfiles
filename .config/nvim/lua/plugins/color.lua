local wk = require("which-key")
wk.add({ { "<leader>H", group = "hex colors" } })

return {
    {
        "norcalli/nvim-colorizer.lua",
        cmd = { "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer" },
        keys = {
            { "<leader>Ha", "<Cmd>ColorizerAttachToBuffer<CR>", desc = "attach" },
            { "<leader>He", "<Cmd>ColorizerAttachToBuffer<CR>", desc = "enable" },
            {
                "<leader>Hd",
                "<Cmd>ColorizerDetachFromBuffer<CR>",
                desc = "disable",
            },
        },
        -- https://github.com/norcalli/nvim-colorizer.lua
        -- colors hex codes/html colors etc #000000
        opts = {
            "*", -- Highlight all files, but customize some others.
            css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
            html = { names = false }, -- Disable parsing "names" like Blue or Gray
        },
    },
}
