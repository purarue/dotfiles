# load zsh-completions installed with pacman,
# user defined functions and completions
fpath=("${ZDOTDIR}/functions" "${ZDOTDIR}/completions" "$HOME/.cache/zsh_generated_completions" "${fpath[@]}")

case "$ON_OS" in
linux*)
	fpath+=(/usr/share/zsh/site-functions)
	;;
mac*)
	# on mac
	# if compaudit complains:
	# run:
	# sudo chown -R $(whoami) <folders>...
	fpath+=(/usr/local/share/zsh/site-functions)
	;;
android*)
	fpath+=("${HOME}/../usr/share/zsh/site-functions")
	;;
esac

# autoload must be after modifying fpath to auto-load completions

# -U ignores alias/shell expansion
# -z forches zsh style autoloading over ksh, if that's set for some reason
autoload -Uz compinit && compinit

# Note: tried caching the result to compinit, using
# zcompudmp (which calls compaudit)
# to speed up start times by caching zcompdump,
# ends up taking longer. Difference is reasonable,
# about ~0.1s. longer. This may change as zcompdump
# size increases

# lazy-load user defined functions
autoload -Uz "${ZDOTDIR}/functions/"*

# so that when copy/pasting commands '$' doesn't cause a command to fail
function \$() {
	"$@"
}

# bind fzf_select (fuzzy match everything and open/cd to dir in ranger)
bindkey -s '^F' "R --cmd='fzf_select'^M"
bindkey -s '^G' "R --cmd='chain set show_hidden true; fzf_select_hidden'^M"

# ^u is Ctrl+U, which is bound to
# to kill-whole-line
# this means that Alt+R deletes everything at
# the current prompt, types ranger, and then sends a newline
# this is done since ranger requires it to be run
# from the terminal and can't be done from a function or (zle -N)
# See <https://unix.stackexchange.com/a/595281/282432>

# Alt+R to launch ranger (file manager) (aliased to 'R')
bindkey -s '^[r' '^uR^M'

# Alt+F to rg-nvim
f-rg-nvim() {
	rg-nvim "$@"
}
zle -N f-rg-nvim
bindkey '^[f' f-rg-nvim

loopcmd() {
	local contents ecmd
	if [[ ! -e '/tmp/loopcmd' ]]; then
		echo 'No loopcmd tempfile found' >&2
		return 1
	fi
	contents="$(cat '/tmp/loopcmd')"
	if [[ -z "$contents" ]]; then
		echo 'Did not receive a command' >&2
		return 1
	fi
	ecmd="$(printf 'while true; do %s; sleep 3; done' "$contents")"
	echo "Going to run: '$ecmd'"
	printf 'Run? '
	read || return
	eval "$ecmd"
}

# Alt+o to run the last command/function you just did, but as a loop
bindkey -s '\eo' '^uecho "!!" >/tmp/loopcmd; loopcmd^M'

# Alt+q to run the last command I did, but pipe the output to a quickfix list in nvim
# this uses my 'qf' script: https://purarue.xyz/d/qf?dark
bindkey -s '\eq' '^uqf <(!!)^M'
