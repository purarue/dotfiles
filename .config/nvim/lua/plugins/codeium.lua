-- local mh = require("user.mapping_helpers")
-- mh.map_key("<M-z>", toggle, "toggle codeium", { "i", "n" })

return {
    "Exafunction/codeium.nvim",
    commit = "937667b2cadc7905e6b9ba18ecf84694cf227567",
    event = "InsertEnter",
    cmd = { "Codeium", "CodeiumToggle" },
    -- cond = not vim.g.on_android,
    enabled = false,
    config = function()
        local function toggle()
            require("user.patch_codeium").toggle_codeium_enabled()
        end
        require("codeium").setup()
        require("user.patch_codeium").patch_codeium()

        vim.api.nvim_create_user_command("CodeiumToggle", toggle, { desc = "Toggle Codeium" })
    end,
}
