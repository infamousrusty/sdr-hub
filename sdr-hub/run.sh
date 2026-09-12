#!/usr/bin/env bash
set -euo pipefail

echo "[sdr-hub-haos] Starting SDR-Hub Home Assistant add-on wrapper"

# Export add-on options as environment variables where supported
if [ -f /data/options.json ]; then
  if command -v jq >/dev/null 2>&1; then
    while IFS='=' read -r key value; do
      export "$key=$value"
    done < <(jq -r 'to_entries | map("\(.key | ascii_upcase)=\(.value | tostring)") | .[]' /data/options.json)
  fi
fi

# Delegate to the wrapped SDR-Hub image entrypoint
if [ -x /entrypoint.sh ]; then
  exec /entrypoint.sh "$@"
elif [ -x /usr/local/bin/entrypoint.sh ]; then
  exec /usr/local/bin/entrypoint.sh "$@"
else
  exec /app/entrypoint.sh "$@"
fi
