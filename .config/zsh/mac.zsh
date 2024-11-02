# mac-specific shell startup commands

# If on mac, put gnu utils on path before others:
# ~/.local/bin/ here is duplicated, so that its before
# /usr/local/bin/, for any scripts I want to override
# e.g. https://github.com/purarue/mpv-sockets#install
PATH="\
${HOME}/.local/bin:\
/usr/local/bin:\
${HOME}/.rbenv/versions/2.7.1/bin:\
${HOME}/Library/Python/3.9/bin:\
/usr/local/opt/coreutils/libexec/gnubin:\
/usr/local/opt/diffutils/bin:\
/usr/local/opt/findutils/libexec/gnubin:\
/usr/local/opt/gawk/libexec/gnubin:\
/usr/local/opt/gnu-indent/libexec/gnubin:\
/usr/local/opt/gnu-sed/libexec/gnubin:\
/usr/local/opt/gnu-tar/libexec/gnubin:\
/usr/local/opt/gnu-which/libexec/gnubin:\
/usr/local/opt/grep/libexec/gnubin:\
/usr/local/opt/gnu-getopt/bin:\
${PATH}"
export PATH

# reset $PWD to $HOME since sometimes starts in at '/'
cd

# check if supervisord (background processes are running)
# else start them
#
# this does mean processes don't start running till
# I open a terminal, but I start one on boot anyways

if [[ ! -e /tmp/supervisord.pid ]]; then
	echo "Supervisor pid file does not exist, starting supervisor..."
	super --daemon
fi
