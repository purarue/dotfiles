; extends

; highlight embedded SQL queries in go
(call_expression
  function: (selector_expression
    operand: (identifier) @db_object
    (#any-of? @db_object "db" "tx")
    field: (field_identifier) @db_func
    (#any-of? @db_func "Exec" "Query"))
  arguments: (argument_list
    [
      (interpreted_string_literal)
      (raw_string_literal)
    ] @injection.content)
  ; remove the string/backticks at the beginning/end of the string
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql")) @go_embedded_sql

; https://github.com/ray-x/go.nvim/blob/master/after/queries/go/injections.scm
([
  (interpreted_string_literal)
  (raw_string_literal)
] @injection.content
  (#match? @injection.content
    "(SELECT|select|INSERT|insert|UPDATE|update|DELETE|delete).+(FROM|from|INTO|into|VALUES|values|SET|set).*(WHERE|where|GROUP BY|group by)?")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.language "sql")) @go_embedded_string_sql
