return {
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        enabled = os.getenv("ON_OS") ~= nil,
        suggestion = {
            enabled = false,
        },
        panel = {
            enabled = false,
        },
        filetypes = {
            markdown = false,
            env = false,
            gitcommit = false,
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
        config = function()
            require("copilot").setup({
                should_attach = function(bufnr, bufname)
                    -- disable for .env files and markdown files
                    if string.match(bufname, "^.env") then
                        return false
                    end
                    return true
                end,
            })
        end,
    },
}
