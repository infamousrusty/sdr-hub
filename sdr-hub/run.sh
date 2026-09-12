#!/usr/bin/env bash
set -euo pipefail

echo "[sdr-hub] Starting SDR-Hub Home Assistant add-on"

# Export add-on options as environment variables where supported
if [ -f /data/options.json ]; then
  if command -v jq >/dev/null 2>&1; then
    while IFS='=' read -r key value; do
      export "$key=$value"
    done < <(jq -r 'to_entries | map("\(.key | ascii_upcase)=\(.value | tostring)") | .[]' /data/options.json)
  fi
fi

# Run the main SDR-Hub entrypoint
exec /sdr-hub/entrypoint/entrypoint.sh "$@"
