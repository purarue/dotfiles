local M = {}

-- A lot of the commands here are wrapped with
-- https://github.com/purarue/fzfcache
-- That is an external command which caches the results
-- of the previous run, so it can prompt you with the choices faster

--- Get a list of all of my config files tracked by yadm
--- @return string[]
function M.list_config()
    local handle = io.popen("list-config-no-hist", "r")
    if handle == nil then
        return {}
    end
    local result = handle:read("*a")
    handle:close()
    local config = {} ---@type string[]
    for line in result:gmatch("[^\r\n]+") do
        table.insert(config, line)
    end
    return config
end

--- Edit one of my config files
--- @return nil
function M.edit_config()
    require("telescope.pickers")
        .new({}, {
            prompt_title = "Edit Config",
            finder = require("telescope.finders").new_oneshot_job({ "fzfcache", "list-config-no-hist" }, {}),
            sorter = require("telescope.config").values.generic_sorter({}),
            preview = require("telescope.config").values.preview,
        })
        :find()
end

--- Grep all of my config files
--- @return nil
function M.grep_config()
    require("telescope.builtin").live_grep({
        shorten_path = true,
        prompt_title = "Grep Config",
        cwd = "~/",
        search_dirs = M.list_config(),
        hidden = false,
        -- use my default settings from telescope setup
        preview = require("telescope.config").values.preview,
    })
end

--- Pick one of my git repos, cd to it, and open telescope to pick a file
--- @return nil
function M.switch_to_repo()
    local actions = require("telescope.actions")

    require("telescope.pickers")
        .new({}, {
            prompt_title = "Pick Repo",
            cwd = "~/",
            -- list my git repos runs a parallel search across all my git repos
            finder = require("telescope.finders").new_oneshot_job({ "fzfcache", "list-my-git-repos", "-r" }, {}),
            sorter = require("telescope.config").values.generic_sorter({}),
            attach_mappings = function(prompt_bufnr, _)
                actions.select_default:replace(function()
                    local selection = require("telescope.actions.state").get_selected_entry()
                    if selection == nil then
                        vim.notify("No repository selected", vim.log.levels.ERROR, { title = "Repo" })
                    else
                        actions.close(prompt_bufnr)
                        -- cd to this directory, and open telescope to pick a file
                        vim.cmd("lcd " .. vim.fn.expand(selection.value))
                        require("telescope.builtin").find_files()
                    end
                end)
                return true
            end,
        })
        :find()
end

return M
