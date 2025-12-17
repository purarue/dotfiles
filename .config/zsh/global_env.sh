#!/bin/sh
# variables which ideally should be sourced into the global
# environment since they could be referenced without opening a terminal
# e.g. from my menu bar/window manager/run launcher
#
# helper envvar to be used in names of files
SHELL_BOOT_TIME="$(date '+%s')"
export SHELL_BOOT_TIME

# https://github.com/purarue/ttally
export TTALLY_DATA_DIR="${HPIDATA}/ttally"
# https://github.com/purarue/mint
export MINT_DATA="${HPIDATA}/mint"
# https://github.com/purarue/ttt
TTT_DATADIR="${XDG_DATA_HOME}/ttt"

# might be nice to move this check elsewhere, but ttt is built into
# a lot of my keybindings so having this here just makes sure I'm
# never in a situation where a keybinding fails if ttt doesn't work
if [ ! -d "$TTT_DATADIR" ]; then
	mkdir -p "$TTT_DATADIR"
fi
export TTT_HISTFILE="${TTT_DATADIR}/${SHELL_BOOT_TIME}.csv"
# https://github.com/purarue/url_cache
export URL_CACHE_DIR="${HPIDATA}/url_cache"
# https://github.com/purarue/oh-my-stars
export OH_MY_STARS_NETRC="${XDG_CONFIG_HOME}/netrc"
# https://github.com/purarue/malexport
export MALEXPORT_DIR="${HPIDATA}/malexport"
export MALEXPORT_USE_MERGED_FILE=1
export MALEXPORT_ZIP_BACKUPS="${HPIDATA}/malexport_backups"
export MAL_ID_CACHE_DIR="${REPOS}/dbsentinel/data/mal-id-cache"
# https://github.com/purarue/plaintext-playlist
export PLAINTEXT_PLAYLIST_MUSIC_DIR="${XDG_MUSIC_DIR}"
# https://github.com/purarue/ipgeocache
export IPGEOCACHE_DIR="${HPIDATA}/ipgeocache"
# https://github.com/todotxt/todo.txt-cli
export TODO_DIR="${HPIDATA}/todo" # todo.txt
# https://github.com/purarue/mpv-history-daemon
export MPV_HISTORY_DAEMON_SCAN_TIME='5'
export CALCURSE_DIR="${HPIDATA}/calcurse"
export CALCURSE_LOAD_DIR="${HPIDATA}/calcurse_load"
# $PATH for bgproc directories, for background processes
# https://github.com/purarue/bgproc
export BGPROC_PATH="${REPOS}/HPI-personal/jobs:${HPIDATA}/jobs:${HOME}/.local/scripts/supervisor_jobs:${REPOS}/vps/jobs"
export BGPROC_DATE_FMT='+%Y-%m-%dT%H-%M-%S'
# $PATH for https://github.com/purarue/reminder-sink
export REMINDER_SINK_PATH="${HPIDATA}/reminder-sink:${HOME}/.local/scripts/reminder-sink"
export REMINDER_SINK_SILENT_FILE="${HPIDATA}/reminder-sink-silent.txt"
# https://github.com/purarue/my_feed
export TMDB_CACHE_DIR="${FILES_DIR}/feed_tmdb_cache"
export GIANTBOMB_CACHE_DIR="${FILES_DIR}/feed_giantbomb_cache"
export MAL_TMDB_MAPPING="${FILES_DIR}/mal_tmdb_mapping.json"
# https://github.com/purarue/albums
export DISCOGS_CACHE_DIR="${FILES_DIR}/discogs_cache"
# https://github.com/purarue/offline_listens
export OFFLINE_LISTENS_COMMANDS='offline-listens-source'
export OFFLINE_LISTENS_FILE="${HPIDATA}/offline_listens/${ON_OS}.yaml"
export ABOOK_FILE="${XDG_DOCUMENTS_DIR}/addressbook"

export NVIM_SPELLFILE="${XDG_DOCUMENTS_DIR}/.nvim_spelldir/en.utf-8.add"
export GENPASSWD_LENGTH=48
