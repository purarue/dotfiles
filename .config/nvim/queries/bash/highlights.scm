; extends

; https://github.com/purarue/evry
; evry has syntax like:
; evry 1 day -do_some_job
;
; this identifies the -tag as @evry_flag, so it
; can be highlighted
(command
  name: (command_name
    (word) @_cmd_name)
  (#eq? @_cmd_name "evry")
  argument: (word) @evry_flag
  (#match? @evry_flag "^-")) @_evry

; can then use a command like this to highlight it specifically:
; vim.api.nvim_set_hl(0, "@evry_flag", {italic = true, fg = "lightgrey"})
