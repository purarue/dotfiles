---@module 'lazy'
---@type LazyPluginSpec[]
return {
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        enabled = os.getenv("ON_OS") ~= nil,
        opts = {
            suggestion = {
                enabled = false,
            },
            filetypes = {
                markdown = false,
                env = false,
                gitcommit = false,
            },
            should_attach = function(_, bufname)
                -- disable for .env files and markdown files
                if string.match(bufname, "^.env") then
                    return false
                end
                return true
            end,
        },
        keys = {
            {
                "<leader>cc",
                function()
                    require("copilot.panel").open({
                        position = "bottom",
                        ratio = 0.4,
                    })
                end,
                desc = "copilot panel",
            },
        },
        config = function(_, opts)
            require("copilot").setup(opts)
        end,
    },
}
