#!/usr/bin/env zsh
# run bgproc jobs once every 2 hours
# https://github.com/purarue/bgproc
evry 1 hour -run_windows_jobs && bgproc_on_machine -on

# sync HPI config from syncthing directory to WSL .config/my directory
evry 10 minutes -sync_hpi_config && sync_hpi_config

# update mod time on a file so I can figure out when I last
# used my windows machine, to make sure I update it periodically
touch "${HOME}/data/windows_terminal_opened"

# In WSL, cache the path to the windows home directory,
# something like /mnt/c/Users/Name
WHOME_FILE="${HOME}/.cache/whome"
[[ -d "${HOME}/.cache" ]] || mkdir -p "${HOME}/.cache"
[[ -f "${WHOME_FILE}" ]] || wslpath "$(wslvar USERPROFILE)" >"${WHOME_FILE}"
WHOME="$(cat "${WHOME_FILE}")"
export WHOME
