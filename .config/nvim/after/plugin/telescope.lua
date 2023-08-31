local cached_repo_bases = function()
    -- cache/roots.txt gets populated by a bgproc job
    -- https://sean.fish/d/cache_repos.job?dark
    local home = os.getenv('HOME')
    local cache_file = home .. '/.cache/roots.txt'
    local f = io.open(cache_file, 'r')
    if f == nil then return {} end
    local roots = {}
    for line in f:lines() do table.insert(roots, line) end
    return roots
end

-- https://github.com/nvim-telescope/telescope.nvim#pickers
require('telescope').setup {
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        mappings = {
            i = {
                -- fzf-like up/down (remember, can also switch to normal mode and use j/k)
                ["<C-j>"] = require("telescope.actions").move_selection_next,
                ["<C-k>"] = require("telescope.actions").move_selection_previous
            }
        },
        -- ignore some directory caches with lots of file results
        file_ignore_patterns = {
            '/discogs_cache/', '/feed_giantbomb_cache/', '/feed_tmdb_cache/'
        },
        results_title = false, -- don't show results title
        prompt_title = false, -- don't show prompt title
        -- TODO: continue looking through telescope.setup docs at file_previewer
        preview = {
            check_mime_type = true, -- check mime type before opening previewer
            filesize_limit = 2, -- limit previewer to files under 2MB
            timeout = 500, -- timeout previewer after 500 ms
            treesitter = true -- use treesitter when available
        }
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case" -- or "ignore_case" or "respect_case"
        },
        repo = {
            list = {
                fd_opts = {},
                search_dirs = cached_repo_bases(),
                previewer = false
            }
        }
    }
}

require('telescope').load_extension('fzf')
require('telescope').load_extension('repo')
