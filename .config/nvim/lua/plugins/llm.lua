local asdf_node_install_path = vim.env.HOME .. "/.asdf/installs/nodejs/23.9.0/bin/node"
---@module 'lazy'
---@type LazyPluginSpec
return {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    enabled = vim.uv.fs_stat(asdf_node_install_path) ~= nil,

    ---@module 'copilot.config'
    ---@type CopilotConfig
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        ---@diagnostic disable-next-line: missing-fields
        suggestion = {
            enabled = false,
        },
        copilot_node_command = asdf_node_install_path,
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
}
