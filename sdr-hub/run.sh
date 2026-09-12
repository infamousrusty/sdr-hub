#!/usr/bin/env bash
set -euo pipefail

log() {
    echo "[sdr-hub] $*"
}

die() {
    log "FATAL: $*"
    exit 1
}

OPTIONS_FILE="/data/options.json"

if [ ! -f "$OPTIONS_FILE" ]; then
    die "Options file not found at $OPTIONS_FILE"
fi

if ! command -v jq >/dev/null 2>&1; then
    die "jq is required but not installed"
fi

LOG_LEVEL=$(jq -r '.log_level // "info"' "$OPTIONS_FILE")
export LOG_LEVEL

log "Log level: $LOG_LEVEL"

MQTT_ENABLED=$(jq -r '.mqtt.enabled // false' "$OPTIONS_FILE")
if [ "$MQTT_ENABLED" = "true" ]; then
    MQTT_HOST=$(jq -r '.mqtt.host // "core-mosquitto"' "$OPTIONS_FILE")
    MQTT_PORT=$(jq -r '.mqtt.port // 1883' "$OPTIONS_FILE")
    MQTT_USER=$(jq -r '.mqtt.username // ""' "$OPTIONS_FILE")
    MQTT_BASE=$(jq -r '.mqtt.base_topic // "sdr_hub"' "$OPTIONS_FILE")
    log "MQTT configured: $MQTT_HOST:$MQTT_PORT (base: $MQTT_BASE)"
fi

RADIOS_JSON=$(jq -c '.radios // []' "$OPTIONS_FILE")
RADIOS_COUNT=$(echo "$RADIOS_JSON" | jq 'length')

if [ "$RADIOS_COUNT" -eq 0 ]; then
    log "WARNING: No radios configured. Add at least one radio to configuration."
fi

declare -A SEEN_IDS
declare -a PIDS=()

validate_radio() {
    local radio="$1"
    local id backend selector device baud_rate

    id=$(echo "$radio" | jq -r '.id // empty')
    [ -z "$id" ] && die "Radio missing required field: id"

    if [ -n "${SEEN_IDS[$id]:-}" ]; then
        die "Duplicate radio ID detected: $id"
    fi
    SEEN_IDS[$id]=1

    backend=$(echo "$radio" | jq -r '.backend // empty')
    [ -z "$backend" ] && die "Radio '$id' missing required field: backend"

    case "$backend" in
        rtl_sdr|hackrf|airspy|sdrplay|other)
            selector=$(echo "$radio" | jq -r '.selector // empty')
            if [ -z "$selector" ]; then
                log "WARNING: Radio '$id' ($backend) may require 'selector' field"
            fi
            ;;
        serial)
            device=$(echo "$radio" | jq -r '.device // empty')
            baud_rate=$(echo "$radio" | jq -r '.baud_rate // empty')
            if [ -z "$device" ]; then
                die "Radio '$id' (serial) missing required field: device"
            fi
            if [ -z "$baud_rate" ]; then
                die "Radio '$id' (serial) missing required field: baud_rate"
            fi
            if [[ "$device" == /dev/ttyUSB* ]] || [[ "$device" == /dev/ttyACM* ]]; then
                log "WARNING: Radio '$id' uses volatile path '$device'. Prefer /dev/serial/by-id/..."
            fi
            ;;
        *)
            die "Radio '$id' has unsupported backend: $backend"
            ;;
    esac

    local freq sample_rate ppm gain
    freq=$(echo "$radio" | jq -r '.frequency_hz // empty')
    if [ -n "$freq" ]; then
        if ! [[ "$freq" =~ ^[0-9]+$ ]] || [ "$freq" -lt 1000000 ] || [ "$freq" -gt 60000000000 ]; then
            die "Radio '$id' has invalid frequency_hz: $freq (must be 1MHz-60GHz)"
        fi
    fi

    sample_rate=$(echo "$radio" | jq -r '.sample_rate_hz // empty')
    if [ -n "$sample_rate" ]; then
        if ! [[ "$sample_rate" =~ ^[0-9]+$ ]] || [ "$sample_rate" -lt 100000 ]; then
            die "Radio '$id' has invalid sample_rate_hz: $sample_rate"
        fi
    fi

    ppm=$(echo "$radio" | jq -r '.ppm // empty')
    if [ -n "$ppm" ]; then
        if ! [[ "$ppm" =~ ^-?[0-9]+$ ]]; then
            die "Radio '$id' has invalid ppm: $ppm"
        fi
    fi

    log "Radio '$id' validated (backend: $backend)"
}

launch_radio() {
    local radio="$1"
    local id backend

    id=$(echo "$radio" | jq -r '.id')
    backend=$(echo "$radio" | jq -r '.backend')

    log "Launching radio '$id' (backend: $backend)"

    case "$backend" in
        rtl_sdr)
            log "RTL-SDR backend stub - implement actual rtl_fm/rtl_tcp launch"
            ;;
        serial)
            local device baud_rate
            device=$(echo "$radio" | jq -r '.device')
            baud_rate=$(echo "$radio" | jq -r '.baud_rate')
            log "Serial backend stub for $device at $baud_rate"
            ;;
        *)
            log "Backend '$backend' not yet implemented"
            ;;
    esac
}

cleanup() {
    log "Received shutdown signal, stopping radios..."
    for pid in "${PIDS[@]:-}"; do
        if kill -0 "$pid" 2>/dev/null; then
            kill -TERM "$pid" 2>/dev/null || true
        fi
    done
    wait
    log "Shutdown complete"
    exit 0
}

trap cleanup SIGTERM SIGINT

ENABLED_COUNT=0

for i in $(seq 0 $((RADIOS_COUNT - 1))); do
    radio=$(echo "$RADIOS_JSON" | jq -c ".[$i]")
    enabled=$(echo "$radio" | jq -r '.enabled // false')

    if [ "$enabled" != "true" ]; then
        log "Radio $i is disabled, skipping"
        continue
    fi

    validate_radio "$radio"
    launch_radio "$radio" &
    PIDS+=($!)
    ENABLED_COUNT=$((ENABLED_COUNT + 1))
done

if [ "$ENABLED_COUNT" -eq 0 ]; then
    log "No enabled radios to start. Container will idle."
fi

if [ ${#PIDS[@]} -gt 0 ]; then
    log "Waiting for ${#PIDS[@]} radio process(es)..."
    wait
fi

log "All radio processes exited"
