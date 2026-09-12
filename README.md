# SDR-Hub

**Software Defined Radio hub for Home Assistant OS (HAOS) and standalone Docker deployments**

SDR-Hub provides a centralized SDR service with USB device passthrough, a web UI accessible via Home Assistant Ingress, and MQTT telemetry for automations. This repository is intended primarily as a **HAOS add-on**, with the option to run the upstream image standalone.

[![License: GPL-3.0](https://img.shields.io/badge/license-GPL--3.0-blue.svg)](LICENSE)
[![GitHub Actions](https://github.com/infamousrusty/sdr-hub/actions/workflows/build-and-sign.yml/badge.svg)](https://github.com/infamousrusty/sdr-hub/actions/workflows/build-and-sign.yml)

## Features

- Multi-arch support: `amd64`, `aarch64`
- USB SDR device passthrough
- Web UI via Home Assistant Ingress (or direct port)
- MQTT integration for telemetry and automations
- HAOS add-on wrapper + upstream Docker image
- Automated builds to GHCR; optional Docker Hub mirror

## Quick Start

### Home Assistant OS (recommended)

1. **Add the repository** in HAOS:
   - Supervisor → Add-on Store → ⋮ (menu) → Repositories
   - Add: `https://github.com/infamousrusty/sdr-hub`
2. **Install the SDR-Hub add-on** from the store.
3. **Configure** (optional):
   - `log_level`: `debug`, `info`, `warning`, `error`
   - `mqtt_host`: MQTT broker hostname (default: `core-mosquitto`)
4. **Start** the add-on and access via the sidebar (radio tower icon).

### Docker (standalone)

```bash
docker run -d \
  --name sdr-hub \
  --privileged \
  -v /dev/bus/usb:/dev/bus/usb \
  -p 8080:8080 \
  ghcr.io/infamousrusty/sdr-hub:latest
```

Adjust `--privileged` and USB mounts as needed for your SDR device.

## Repository Structure

- `Dockerfile`, `entrypoint/`, `config/`, `scripts/` — upstream SDR-Hub image build
- `sdr-hub/` — HAOS add-on wrapper (config, Dockerfile, run.sh, docs)
- `repository.yaml` — HAOS add-on store manifest
- `.github/workflows/`:
  - `build-and-sign.yml` — primary multi-arch build & publish (GHCR + optional Docker Hub)
  - `haos-build.yml` — HAOS add-on build & publish
  - `haos-lint.yml` — add-on config linting
  - `ci.yml`, `codeql-analysis.yml` — CI and security scanning

## Configuration

### HAOS Add-on Options

```yaml
log_level: info
mqtt_host: core-mosquitto
```

### Environment Variables (Docker)

- `LOG_LEVEL`: `debug`, `info`, `warning`, `error`
- `MQTT_HOST`: MQTT broker hostname

## Manual Publishing

If CI builds fail or you need to publish manually, see [docs/manual-publish.md](docs/manual-publish.md) for step-by-step instructions to build and push images to GHCR and Docker Hub.

## Documentation

- [HAOS Add-on Usage](docs/haos-addon.md)
- [Architecture Overview](docs/architecture.md)
- [Manual Publish Guide](docs/manual-publish.md)

## Development

```bash
# Build upstream image
docker build -t ghcr.io/infamousrusty/sdr-hub:latest .

# Run tests / lint (if applicable)
# ... add your test commands here ...
```

## License

GPL-3.0 — see [LICENSE](LICENSE).

## Support

- Issues & feature requests: https://github.com/infamousrusty/sdr-hub/issues
