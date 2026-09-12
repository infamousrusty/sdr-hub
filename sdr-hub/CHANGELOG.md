# Changelog

## [1.0.1] - 2026-09-12

### Fixed
- Fixed Home Assistant add-on container startup/runtime alignment
- Aligned HAOS image publication with supported amd64 and arm64 manifests
- Removed forced `/init` command overrides that caused exec format errors

### Added
- Added structured per-radio configuration with validation
- Added stable serial-device selection guidance (`/dev/serial/by-id`)
- Added startup diagnostics and graceful shutdown handling
- Added MQTT configuration with secure credential handling
- Added architecture verification in CI workflow

### Changed
- Updated Dockerfile to use Debian bookworm slim base
- Improved run.sh with comprehensive config validation
- Enhanced entrypoint script with better error messages
- Updated documentation with troubleshooting section

## [1.0.0] - Initial Release

- Initial SDR Hub add-on implementation
- Basic RTL-SDR and serial backend support
- Home Assistant add-on integration
