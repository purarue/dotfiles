#!/bin/zsh
# move these into language specific functions, so I'm not updating everything all the time

update_node() {
	echo "Updating global node packages..."
	yarn global --prefix "${HOME}/.local/" upgrade
}

update_gem() {
	echo "Updating ruby packages..."
	gem update
} && alias update_ruby='update_gem'

update_pip() {
	echo "Updating python packages..."
	python -m pip install --user -U --break-system-packages -r "${XDG_CONFIG_HOME}/yadm/package_lists/python3_packages.txt"
	case "$ON_OS" in
	linux_*)
		python -m pip install --user -U --break-system-packages -r "${XDG_CONFIG_HOME}/yadm/package_lists/linux_python3_packages.txt"
		;;
	esac
	case "$ON_OS" in
	android*) ;;
	*)
		python -m pip install --user -U --break-system-packages -r "${XDG_CONFIG_HOME}/yadm/package_lists/computer_python.txt"
		;;
	esac
}

update_cargo() {
	echo "Updating cargo packages..."
	cargo install-update -a
}

update_golang() {
	echo "Updating golang packages..."
	cd || return $?
	spkglist "$HOME/.config/yadm/package_lists/go_packages.txt" | awk '{ print $2 "@latest" }' | xargs -I '{}' go install -v "{}"
	cd "$OLDPWD" || return $?
}

update_basher() {
	echo "Updating bash scripts..."
	(cd "$(basher package-path .)" && git pull)
	basher-upgrade-all
}

update_opam() {
	echo "Updating opam packages..."
	eval "$(opam env)"
	opam update
	opam upgrade
}

update_ranger_plugins() {
	clone-repos "${HOME}/.config/clone-repos/ranger-plugins.yaml"
}

update_todo_addons() {
	clone-repos "${HOME}/.config/clone-repos/todotxt-actions.yaml"
}

update_lang_all() {
	update_node
	update_pip
	pipx upgrade-all
	update_cargo
	update_golang
	update_basher
	update_ranger_plugins
	update_todo_addons
}
