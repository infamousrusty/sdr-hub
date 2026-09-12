# HAOS Add-on Usage

## Installation

1. In Home Assistant OS, go to **Supervisor** → **Add-on Store**.
2. Click the menu (⋮) → **Repositories**.
3. Add the repository URL: `https://github.com/infamousrusty/sdr-hub`.
4. The **SDR-Hub** add-on should appear in the store. Click **Install**.

## Configuration

After installation, configure the add-on options:

```yaml
log_level: info
mqtt_host: core-mosquitto
```

- `log_level`: `debug`, `info`, `warning`, `error`
- `mqtt_host`: optional MQTT broker hostname (default: `core-mosquitto`)

## Usage

- Access the SDR-Hub UI via the Home Assistant sidebar (radio tower icon).
- Configure your SDR devices and MQTT settings as needed.
- Use MQTT topics in your Home Assistant automations.

## USB Devices

The add-on supports USB passthrough. Ensure your SDR device is recognized by the host and accessible to the add-on.

## Troubleshooting

- Check the add-on logs in the Supervisor panel.
- Ensure USB permissions and device paths are correct.
- Verify MQTT connectivity if telemetry is not appearing.

## Updating

Updates are available via the Add-on Store when new releases are published.
