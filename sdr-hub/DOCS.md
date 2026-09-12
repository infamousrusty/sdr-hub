# SDR Hub Add-on Documentation

## Supported Architectures

This add-on supports the following Home Assistant host architectures:
- **linux/amd64** (x86_64)
- **linux/arm64** (aarch64)

## Image Publication

The add-on image is published to `ghcr.io/infamousrusty/sdr-hub` with tags matching the add-on version. For version `1.0.1`, the image tag is `1.0.1` and `latest` (on master branch).

## USB SDR vs Serial Receiver Configuration

### USB SDR Devices (RTL-SDR, HackRF, Airspy, SDRplay)
- Use `backend` values: `rtl_sdr`, `hackrf`, `airspy`, `sdrplay`
- Configure the `selector` field with the device serial or identifier
- Device access is automatic via `/dev/bus/usb` mapping

### Serial Receivers
- Use `backend: serial`
- Configure `device` with the full path (prefer `/dev/serial/by-id/...`)
- Configure `baud_rate` matching your device (e.g., `115200`)
- Optionally set `protocol` for backend-specific handling

## Finding Stable Serial Paths

On your Home Assistant host, run:
```bash
ls -l /dev/serial/by-id/
```

Use the full path (e.g., `/dev/serial/by-id/usb-FTDI_FT232R_USB_UART_AB12CD34-if00-port0`) instead of volatile paths like `/dev/ttyUSB0`.

## Configuration Reference

### Root Options

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `log_level` | `info|debug|warning|error` | No | Logging verbosity (default: `info`) |
| `mqtt` | object | No | MQTT broker configuration |
| `radios` | array | No | List of radio configurations |

### MQTT Options

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `enabled` | boolean | No | Enable MQTT publishing |
| `host` | string | No | Broker hostname (default: `core-mosquitto`) |
| `port` | integer | No | Broker port (default: `1883`) |
| `username` | string | No | Authentication username |
| `password` | string | No | Authentication password (not logged) |
| `base_topic` | string | No | Base MQTT topic (default: `sdr_hub`) |

### Radio Configuration

Each radio in the `radios` array supports:

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | string | **Yes** | Unique identifier for this radio |
| `enabled` | boolean | No | Whether to start this radio (default: `false`) |
| `backend` | string | **Yes** | Backend type: `rtl_sdr`, `hackrf`, `airspy`, `sdrplay`, `serial`, `other` |
| `selector` | string | Conditional | USB device selector (required for most USB SDR backends) |
| `device` | string | Conditional | Serial device path (required for `backend: serial`) |
| `baud_rate` | integer | Conditional | Serial baud rate (required for `backend: serial`) |
| `protocol` | string | No | Protocol identifier for serial backends |
| `frequency_hz` | integer | No | Center frequency in Hz (e.g., `1090000000` for 1090MHz) |
| `sample_rate_hz` | integer | No | Sample rate in Hz (e.g., `2048000`) |
| `gain` | string | No | Gain setting (e.g., `auto`, or numeric) |
| `ppm` | integer | No | Frequency correction in PPM |
| `extra_args` | string | No | Backend-specific additional arguments |

## MQTT Behavior

When enabled, the add-on publishes telemetry and status to the configured MQTT broker. Credentials are read from configuration but **never logged**.

## Known Errors and Troubleshooting

### GHCR Denied / 401 / 403

**Symptom:** Add-on fails to pull image with authentication errors.

**Causes:**
- GHCR package is set to private but add-on expects public access
- Tag/manifest does not exist for the requested architecture

**Resolution:**
1. Verify package visibility in GitHub Settings → Packages
2. Ensure the workflow published all required architectures
3. Check the exact tag exists: `docker buildx imagetools inspect ghcr.io/infamousrusty/sdr-hub:<version>`

### Missing Manifest

**Symptom:** `manifest unknown` or `not found` errors.

**Resolution:**
- Verify the workflow completed successfully
- Check that the tag matches the add-on `version` field in `config.yaml`

### exec /init: exec format error

**Symptom:** Container fails immediately with `exec format error`.

**Causes:**
- Image architecture does not match host
- Entrypoint binary is for wrong CPU architecture
- Using `/init` from incompatible base image

**Resolution:**
1. Verify published manifest includes your host architecture
2. Check image config: `docker image inspect --format='{{.Architecture}}' <image>`
3. Ensure Dockerfile uses correct base image and entrypoint model

## Diagnostic Data to Collect

When reporting issues, provide:

1. **Supervisor logs:** Settings → System → Logs → Supervisor
2. **Add-on logs:** Add-on → Logs tab (full output)
3. **Image details:**
   ```bash
   docker pull ghcr.io/infamousrusty/sdr-hub:<version>
   docker image inspect ghcr.io/infamousrusty/sdr-hub:<version>
   docker buildx imagetools inspect ghcr.io/infamousrusty/sdr-hub:<version>
   ```
4. **Host architecture:** `uname -m`
5. **Exact configuration** (redact passwords)
