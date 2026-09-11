# SDR-Hub Security

## Threat model

- Exposure of SDR radio front-ends.
- Network surfaces (ports, MQTT, Prometheus).
- Host access via USB and device drivers.

## Hardening recommendations

- Run as non-root where possible.
- Limit exposed ports and networks.
- Use firewalls and VLANs to segment SDR-Hub.

## Disclosure process

See SECURITY.md for how to report vulnerabilities.

