#!/usr/bin/env bash
set -euo pipefail

APP_USER="ubuntu"
APP_GROUP="ubuntu"
APP_DIR="/app"
LOG_DIR="/var/log/sdr"
RUNNER="/entrypoint/entrypoint_run.sh"

log() {
    printf '%s
' "[sdr-hub] $*"
}

ensure_writable_dir() {
    local directory="$1"

    if [[ ! -e "${directory}" ]]; then
        mkdir -p "${directory}"
    fi

    if [[ -w "${directory}" ]]; then
        return 0
    fi

    if chown -R "${APP_USER}:${APP_GROUP}" "${directory}" 2>/dev/null; then
        return 0
    fi

    log "WARNING: Cannot change ownership of ${directory}; continuing with existing permissions."
}

if [[ ! -x "${RUNNER}" ]]; then
    log "ERROR: Runtime entrypoint is missing or not executable: ${RUNNER}"
    exit 1
fi

if [[ "$(id -u)" -eq 0 ]]; then
    ensure_writable_dir "${APP_DIR}"
    ensure_writable_dir "${LOG_DIR}"

    # /dev/bus/usb is mounted from the HAOS host and is read-only.
    # Do not chown, chmod, or otherwise modify host device nodes here.
    if [[ -d /dev/bus/usb ]]; then
        log "USB bus is available at /dev/bus/usb; leaving host-managed permissions unchanged."
    else
        log "WARNING: /dev/bus/usb is not available in this container."
    fi

    exec runuser -u "${APP_USER}" -- "${RUNNER}" "$@"
fi

exec "${RUNNER}" "$@"