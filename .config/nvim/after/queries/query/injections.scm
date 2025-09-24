; extends

; highlight regex strings in treesitter query files
(predicate
  name: (identifier) @query_cond
  (#any-of? @query_cond "match" "any-match" "vim-match" "any-match"
   "any-vim-match" "lua-match" "any-lua-match")
  parameters: (parameters
    (string
      (string_content) @injection.content))
  (#set! injection.language "regex"))
