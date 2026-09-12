#!/usr/bin/env bash
set -eu

log() {
    echo "[entrypoint] $*"
}

log "Starting SDR Hub entrypoint"

if [ ! -f /data/options.json ]; then
    log "ERROR: /data/options.json not found. Ensure running as Home Assistant add-on."
    exit 1
fi

if ! command -v jq >/dev/null 2>&1; then
    log "ERROR: jq is required but not installed."
    exit 1
fi

log "Options loaded, executing main application"
exec "$@"
