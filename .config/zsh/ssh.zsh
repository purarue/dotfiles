# add both my SSH keys to an agent
# this is so that I can use multiple Github accounts
SHARED_AUTH_SOCK="${TMPDIR:-/tmp}/zsh_shared_socket"
if [[ ! -S "$SHARED_AUTH_SOCK" ]]; then
	eval "$(ssh-agent)"
	# link socket to a shared location
	ln -sf "$SSH_AUTH_SOCK" "$SHARED_AUTH_SOCK"
	ssh-add -l >/dev/null || {
		for ssh_key in "${HOME}/.ssh/id_rsa" "${HOME}/.ssh/id_ed25519"; do
			if [[ -e "$ssh_key" ]]; then
				ssh-add "$ssh_key"
			else
				printf "Key doesn't exist: %s\n" "$ssh_key"
			fi
		done
	}
fi
export SSH_AUTH_SOCK="$SHARED_AUTH_SOCK"
