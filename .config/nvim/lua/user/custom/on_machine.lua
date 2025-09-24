-- https://github.com/purarue/on_machine
-- what operating system I'm on controls how some plugins load
vim.g.on_os = os.getenv("ON_OS") or "unknown" ---@type string
vim.g.on_android = vim.split(vim.g.on_os, "_")[1] == "android" ---@type boolean
