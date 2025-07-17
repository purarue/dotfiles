return {
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        cmd = "Copilot",
        event = "InsertEnter",
        -- if on one of my local machines (I'm on a known OS)
        enabled = os.getenv("ON_OS") ~= nil,
        config = function()
            require("copilot_cmp").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
            })

            local wk = require("which-key")
            local panel = require("copilot.panel")

            wk.add({
                {
                    "<leader>cc",
                    function()
                        panel.open({
                            position = "bottom",
                            ratio = 0.4,
                        })
                    end,
                    desc = "copilot panel",
                },
            })
        end,
    },
    {
        "zbirenbaum/copilot.lua",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                should_attach = function(bufnr, bufname)
                    -- disable for .env files and markdown files
                    local ft = vim.bo[bufnr].ft
                    if not ft then
                        return true
                    end
                    if ft == "markdown" or string.match(ft, "^git") then
                        return false
                    end
                    if string.match(bufname, "^.env") then
                        return false
                    end
                    return true
                end,
            })
        end,
    },
}
