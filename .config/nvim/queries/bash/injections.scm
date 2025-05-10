; extends
;
; TODO: these dont work when the cmd_name is exec, is there
; some terse way to programmatically check if its first arg with exec..?

; Highlight awk strings in shell scripts using the AWK syntax
; hmm, sadly this does have false positives and it highlights all raw_string
; but that is not terrible, if you have a flag you can do -f'something' and
; that prevents the highlighting
(command
  name: (command_name
    (word) @cmd_name
    (#eq? @cmd_name "awk"))
  argument: (raw_string) @injection.content
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "awk")) @sh_embedded_awk

; example of 'exec awk' matcher, maybe can create these programmatically somehow
(command
  name: (command_name
    (word) @cmd_name
    (#eq? @cmd_name "exec"))
  argument: (_) @first_arg
    (#eq? @first_arg "awk")
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

(command
  name: (command_name
    (word) @cmd_name
    (#eq? @cmd_name "exec"))
  argument: (_) @first_arg
    (#eq? @first_arg "jq")
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
