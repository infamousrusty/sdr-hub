# Architecture Overview

## Components

- **Upstream SDR-Hub Image** (`Dockerfile` at repo root)
  - Multi-arch build (`amd64`, `aarch64`)
  - Entrypoint scripts in `entrypoint/`
  - Configuration in `config/`
- **HAOS Add-on Wrapper** (`sdr-hub/` directory)
  - `config.yaml` — add-on manifest for HAOS
  - `Dockerfile` — wraps the upstream image
  - `run.sh` — entry script forwarding to upstream entrypoint
  - `README.md`, `DOCS.md`, `CHANGELOG.md` — add-on documentation
- **CI/CD Workflows** (`.github/workflows/`)
  - `build-and-sign.yml` — primary upstream image build & publish
  - `haos-build.yml` — HAOS add-on build & publish
  - `haos-lint.yml` — add-on config linting
  - `ci.yml`, `codeql-analysis.yml` — CI and security scanning

## Data Flow

1. SDR devices are passed through to the container via USB.
2. The SDR-Hub service runs inside the container, exposing a web UI.
3. In HAOS, the UI is accessible via Ingress in the sidebar.
4. Telemetry is published to the configured MQTT broker for automations.

## Integration Points

- **Home Assistant**: Ingress UI, MQTT discovery.
- **USB Subsystem**: Device passthrough for SDR hardware.
- **MQTT Broker**: Typically `core-mosquitto` in HAOS.

## Security

- Images are signed with Cosign (see `build-and-sign.yml`).
- GHCR packages should be set to **Public** for HAOS pull access.
- Docker Hub mirror is optional and non-authoritative.
