#!/bin/sh
# global configuration/environment
# this is sourced in .xinitrc (when I run startx) on Linux and
# from ~/.zshenv on other operating systems
# mac (see ~/.config/yadm/mac_bootstrap for the generated .zshenv)

# Directories

## XDG
export XDG_DOWNLOAD_DIR="${HOME}/Downloads"
export XDG_DOCUMENTS_DIR="${HOME}/Documents"
export XDG_PICTURES_DIR="${HOME}/Pictures"
export XDG_VIDEOS_DIR="${HOME}/Movies"
export XDG_CONFIG_HOME="${HOME}/.config"
export XDG_CACHE_HOME="${HOME}/.cache"
export XDG_DATA_HOME="${HOME}/.local/share"

# I want a separate Files directory that has more backup-like
# files that I dont need on all my machines
#
# that way I can nicely sync my ~/Documents across machines
export FILES_DIR="${HOME}/Files"
SCREENSHOTS="${FILES_DIR}/Screenshots"

export REPOS="${HOME}/Repos"

# https://github.com/purarue/HPI
# the 'root data directory' for HPI
HPIDATA="${HOME}/data"

# common path modifications
export PATH="\
${XDG_DATA_HOME}/basher/cellar/bin:\
${REPOS}/personal/bin:\
${HPIDATA}/bin:\
${REPOS}/vps/bin:\
${REPOS}/HPI-personal/scripts:\
${REPOS}/bleanser/bin:\
${REPOS}/plaintext_playlist_py/bin:\
${REPOS}/my_feed/scripts:\
${REPOS}/ttally/bin:\
${XDG_DATA_HOME}/shortcuts:\
${HOME}/.local/bin:\
${HOME}/.local/scripts/cross-platform:\
${HOME}/.local/scripts/generic:\
${XDG_DATA_HOME}/go/bin:\
${XDG_DATA_HOME}/cargo/bin:\
${XDG_DATA_HOME}/pubcache/bin:\
${HOME}/.config/i3blocks/blocks:\
${PATH}"

# defaults, some of these are overwrriten in the case below
XDG_MUSIC_DIR="${HOME}/Music"
BROWSER='floorp'

if hash on_machine; then
	ON_OS="$(on_machine)"
else
	echo 'Warning: on_machine not available, falling back to manual OS detection...' >&2
	ON_OS="$(manual_on_os)"
fi
export ON_OS

# overwrite some envvars with OS-specific data
case "$ON_OS" in
linux*)
	# add linux stuff to $PATH
	PATH="${HOME}/.local/scripts/linux:${PATH}"
	if [ -d "$HOME/.local/share/gem/" ]; then
		for dir in "${HOME}"/.local/share/gem/ruby/3.*; do
			PATH="$dir/bin:$PATH"
		done
	fi
	export ARCHFLAGS="-arch x86_64" # Compilation flags
	;;
mac*)
	SCREENSHOTS="${HOME}/Desktop" # Screenshots on Mac are saved on the Desktop
	;;
android*)
	HPIDATA="${HOME}/storage/shared/data"
	XDG_MUSIC_DIR="${HOME}/storage/music"
	XDG_DOWNLOAD_DIR="${HOME}/storage/downloads"
	XDG_DOCUMENTS_DIR="${HOME}/storage/shared/Documents"
	XDG_PICTURES_DIR="${HOME}/storage/pictures"
	XDG_VIDEOS_DIR="${HOME}/storage/shared/Movies"
	SCREENSHOTS="${XDG_PICTURES_DIR}/Screenshots"
	BROWSER='termux-open-url'
	;;
windows*)
	BROWSER='/mnt/c/Program Files/Mozilla Firefox/firefox.exe'
	;;
esac

export HPIDATA BROWSER XDG_MUSIC_DIR PATH SCREENSHOTS XDG_DOWNLOAD_DIR XDG_DOCUMENTS_DIR XDG_PICTURES_DIR XDG_VIDEOS_DIR
export PLAINTEXT_PLAYLIST_PLAYLISTS="${HPIDATA}/playlists"

# some system wide defaults

# manually set language environment
export LANG='en_US.UTF-8'
export LC_ALL='en_US.UTF-8'

# Set default applications
export VISUAL='nvim'   # e.g. for edit-command-line in ~/.zshrc, to prompt in current terminal
export EDITOR='editor' # basic nvim wrapper
export PAGER='less'
export TERMINAL='kitty'
export READER='okular'

# define where ZDOTDIR (rest of zsh configuration) is
export ZDOTDIR="${XDG_CONFIG_HOME}/zsh"

# variables which ideally should be sourced into the global
# environment since they could be referenced without opening a terminal
# e.g. from my menu bar/window manager/run launcher
if [ -f "${ZDOTDIR}/global_env.sh" ]; then
	# shellcheck disable=SC1091
	. "${ZDOTDIR}/global_env.sh"
fi
