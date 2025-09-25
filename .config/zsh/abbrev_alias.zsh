# after sourcing this file, you can use 'abbrev-alias' instead of 'alias',
# which will create an alias that expands automatically when you type it (and a space)

typeset -ga _alias_abbreviations
abbrev-alias() {
	alias $1
	# NOTE: this is a linear array search implementation, but it only runs
	# once per command, when you type a space after the first word, so should
	# be fine. could change to associative array maybe
	_alias_abbreviations+=(${1%%\=*})
}

_autoexpand_abbreviations() {
	# if there's anything in RBUFFER (after cursor) or if there's a space in the entire buffer, short circuit
	# otherwise check if the LBUFFER (text before cursor) matches an abbrev-alias
	if [[ -z "$RBUFFER" && "$LBUFFER$RBUFFER" != *" "* ]] && (( ${#_alias_abbreviations[(r)${LBUFFER}]} )); then
		# if enabled, clear zsh-autoggestion to avoid inserting into RBUFFER
		(( $+widgets[autosuggest-clear] )) && zle autosuggest-clear
		zle _expand_alias # expand the alias into the full command
		return
	fi
	# otherwise just insert the space
	zle self-insert
}
zle -N _autoexpand_abbreviations
bindkey -M main ' ' _autoexpand_abbreviations
