; extends

; https://github.com/purarue/pmark
(fenced_code_block
  (code_fence_content) @injection.content
  (#match? @injection.content "^...PMARK")
  ; skip the first line, is a PMARK marker
  (#offset! @injection.content 1 0 0 0)
  (#set! injection.language "bash"))
