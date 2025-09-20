function expand-alias() {
  zle _expand_alias
  zle self-insert
}
zle -N expand-alias
bindkey -M main ' ' expand-alias

ALIAS_DIR="${ZDOTDIR}/aliases"
source "${ALIAS_DIR}/aliases"         # General aliases
source "${ALIAS_DIR}/git_aliases"     # Git aliases (from oh-my-zsh)
source "${ALIAS_DIR}/project_aliases" # Aliases for my own projects
source "${ALIAS_DIR}/dev_aliases"     # language tooling/programming aliases
# Personal Aliases (e.g. ssh to servers)
source_if_exists "${HPIDATA}/personal_aliases"
# Tokens for interacting with APIs etc
source_if_exists "${HPIDATA}/tokens"
