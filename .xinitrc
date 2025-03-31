#!/bin/sh

# source keymap configuration
# move xmodmap somewhere else so it doesn't pollute my home directory
usermodmap="$HOME/.config/X11/Xmodmap"

if [ -f "$usermodmap" ]; then
	xmodmap "$usermodmap"
fi

# source user profile
# sets a bunch of global-ish environment variables, detects which OS I'm
# on and sets the ON_OS environment variable which I use in lots of my scripts
if [ -f "${HOME}/.profile" ]; then
	. "${HOME}/.profile"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		# shellcheck disable=SC1090
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# set key repeat rate
xset r rate 300 25

exec i3
