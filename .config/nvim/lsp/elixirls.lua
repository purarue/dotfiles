local elixir_ls_bin = vim.fn.exepath("elixir-ls")
return {
    { cmd = { elixir_ls_bin } },
}
