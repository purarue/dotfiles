; extends
;
; TODO: these dont work when the cmd_name is exec, is there
; some terse way to programmatically check if its first arg with exec..?

; Highlight awk strings in shell scripts using the AWK syntax
; TODO: only do this when the raw_string is the last argument in the command
(command
  name: (command_name
    (word) @cmd_name
    (#eq? @cmd_name "awk"))
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "awk")) @sh_embedded_awk

; NOTE: This does not do a *ton*, but it does highlight ^ and $ nicely
(command
  name: (command_name
    (word) @cmd_name
    (#eq? @cmd_name "sed"))
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "regex")) @sh_embedded_sed

(command
  name: (command_name
    (word) @cmd_name
    (#eq? @cmd_name "fd"))
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "regex")) @sh_embedded_fd

(command
  name: (command_name
    (word) @cmd_name
    (#eq? @cmd_name "jq"))
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "jq")) @sh_embedded_jq

; https://github.com/purarue/fzfcache
(command
  name: (command_name
    (word) @cmd_name
    (#eq? @cmd_name "fzfcache"))
  argument: (string
    (string_content) @injection.content)
  (#set! injection.language "bash")) @sh_embedded_fzfcache
