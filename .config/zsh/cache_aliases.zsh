# periodically cache my aliases so I can reconstruct the meaning of commands using them
# should be the last thing run when starting zsh
# meant to be used as part of HPI https://github.com/purarue/HPI

hash evry && evry 1 week -zsh_alias_cache && {
	ALIAS_CACHE_BACKUP_DIR="$(python3 -m my.utils.backup_to 'zsh_aliases')" || exit $?
	ALIAS_CACHE_TARGET="${ALIAS_CACHE_BACKUP_DIR}/$(date +'%s')-$(uname)"
	alias | sort >"${ALIAS_CACHE_TARGET}"
	unset ALIAS_CACHE_BACKUP_DIR ALIAS_CACHE_TARGET
}
