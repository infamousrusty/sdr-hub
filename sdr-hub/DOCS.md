# SDR-Hub Documentation

## Overview

SDR-Hub provides a centralized Software Defined Radio service for Home Assistant with USB device passthrough, a web UI accessible via Ingress, and MQTT telemetry.

## Usage

After installation, access the SDR-Hub UI via the Home Assistant sidebar (radio tower icon). Configure your SDR devices and MQTT settings as needed.

## USB Devices

The add-on supports USB passthrough. Ensure your SDR device is recognized by the host and accessible to the add-on.

## MQTT

The add-on publishes telemetry to the configured MQTT broker (default: `core-mosquitto`). Use these topics in your Home Assistant automations.
