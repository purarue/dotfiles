python() {
	python3 "$@"
}
man() {
	if [[ -z "$1" ]]; then
		macho
	else
		command man "$@"
	fi
}

# https://github.com/odeke-em/drive
# if I run drive outside my google drive
# move to ~/GoogleDrive/
drive() {
	local defaultdrive="${HOME}/GoogleDrive"

	# early exit if drive doesn't exist where I expect
	[[ ! -r "${defaultdrive}" ]] && command drive "$@"

	# if not trying to create another google drive instance
	if [[ "$1" != 'init' ]]; then
		if ! grep -q "${defaultdrive}" <<<"${PWD}"; then
			cd "${defaultdrive}" || {
				printf "Couldn't change directory to %s\n" "${defaultdrive}"
			}
		fi
	fi
	command drive "$@"
}

# https://github.com/charmbracelet/glow
glow() {
	# if passed with no arguments
	# and there's only one .md file in this
	# directory, automatically use it
	if (($# == 0)); then
		local -a MD_FILES
		MD_FILES=()
		while IFS= read -r file; do
			MD_FILES+=("$file")
		done < <(find . -maxdepth 1 -name '*.md')
		if [[ "${#MD_FILES[@]}" == "1" ]]; then
			command glow "${MD_FILES[*]}"
		else
			command glow "$@"
		fi
	else
		command glow "$@"
	fi
}

alias icat='kitten icat'

# https://github.com/sharkdp/bat
# https://github.com/eza-community/eza
#
# if trying to 'cat' all images -- use kitty to print the image directly in the terminal
# if only one argument and a directory, ls instead
# else, use bat
cat() {
	local all_dirs=1

	if [[ -z "$1" ]]; then
		all_dirs=0
	else
		for arg in "$@"; do
			if [[ ! -d "$arg" ]]; then
				all_dirs=0
				break
			fi
		done
	fi

	if ((all_dirs)); then
		eza "$@"
	else
		if havecmd bat; then
			bat "$@"
		else
			command cat "$@"
		fi
	fi
}
