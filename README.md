![Demo](images/demo.webp)

- [Introduction](#introduction)
  - [Scanner](#scanner)
  - [Web panel](#web-panel)
- [Features](#features)
  - [Multi-Band Recording](#multi-band-recording)
  - [AI-Powered Audio Tagging](#ai-powered-audio-tagging)
  - [Satellite Tracking](#satellite-tracking)
  - [Scheduled Recording with Crontab](#scheduled-recording-with-crontab)
  - [Gain comparison](#gain-comparison)
- [Info](#info)
  - [YouTube](#youtube)
  - [Community](#community)
  - [Wiki](#wiki)
- [Screens](#screens)
  - [Data](#data)
  - [Configuration](#configuration)
- [Quickstart](#quickstart)
  - [Install docker](#install-docker)
  - [Run](#run)
  - [Web panel](#web-panel-1)
  - [Configuration](#configuration-1)
- [Advanced](#advanced)
  - [Update](#update)
  - [Build from sources](#build-from-sources)
  - [Debug](#debug)
- [Disclaimer](#disclaimer)
- [Contributing](#contributing)
- [Donations](#donations)
- [License](#license)

# Introduction

This project is **all in one** type, it combines two subprojects into one to allow easy launch them.

## Scanner

[sdr-scanner](https://github.com/shajen/rtl-sdr-scanner-cpp)

This project is a `C++` based SDR scanner designed to detect, record, and analyze multiple radio signals simultaneously across different frequency bands. It combines **high performance** with **flexibility**, supporting a **wide range of SDR devices** via [Soapy SDR](https://github.com/pothosware/SoapySDR) and [GNU Radio](https://github.com/gnuradio/gnuradio). Full list of supported devices/drivers [here](https://github.com/pothosware/SoapyOsmo/wiki).

## Web panel

[sdr-monitor](https://github.com/shajen/sdr-monitor)

Very powerful **web panel** to explore transmissions, spectrograms and configure sdr device.

## Fork and Home Assistant OS integration

This repository is a fork of the upstream project [shajen/sdr-hub](https://github.com/shajen/sdr-hub), maintained by [infamousrusty](https://github.com/infamousrusty). It preserves the original architecture and GNU GPLv3 licensing while also serving as the upstream container image for the SDR-Hub Home Assistant OS app published at [infamousrusty/sdr-hub-haos](https://github.com/infamousrusty/sdr-hub-haos).

The HAOS app wraps this project and exposes SDR-Hub inside Home Assistant OS using USB passthrough, Ingress, and MQTT, but does not change the core SDR-hub functionality. All modifications in this fork and its HAOS integration remain licensed under the GNU GPLv3, consistent with the upstream project.

# Features

## Multi-Band Recording

The scanner can **simultaneously scan and record multiple frequencies** (e.g., `108 MHz`, `144 MHz`, `440 MHz`, etc.) by rapidly switching between frequency ranges. This makes it possible to monitor wide portions of the spectrum in real time.

It can also **record several transmissions within the same band** - for example, if one signal is at `145.200 MHz` and another at `145.600 MHz`, both will be automatically captured and saved. Perfect for monitoring busy amateur or public service bands.

## AI-Powered Audio Tagging

The scanner now includes an **AI-based audio classifier** that automatically tags your recordings - distinguishing between noise, human speech, and other signal types. The model runs entirely locally for full privacy and performance. This makes it effortless to browse, filter, and replay.

## Satellite Tracking

The scanner now includes **automatic satellite tracking**! Simply enter your location coordinates and an API key (from [n2y0.com](https://n2yo.com/api/)) and the scanner will fetch upcoming satellite passes over your area. When a satellite is in range, it will **automatically tune, track, and record** the transmission - no manual setup needed. Perfect for capturing real-time signals from weather satellites, ISS, and more!

Keep in mind that **receiving satellite signals requires a good-quality antenna, precise radio calibration, and minimal interference** for best results. With proper setup, you can effortlessly capture real-time signals from weather satellites, the ISS, and more!

## Scheduled Recording with Crontab

You can now schedule automatic recordings using simple crontab-style entries. Define exact times or recurring intervals to start recording transmissions - ideal for capturing periodic signals, beacon transmissions. Once configured, the scanner handles everything automatically, so you’ll never miss an interesting signal again!

## Gain comparison

The scanner can now **automatically test all available gain settings** for your SDR device and **capture short spectrogram samples** for each configuration. These results are then displayed in a **side-by-side visual view**, making it easy to compare signal quality and noise levels across different gain values. With just one scan, you can instantly **identify the optimal gain settings** for your hardware and environment - no more tedious manual tuning.

# Info

## YouTube

Video [here](https://www.youtube.com/watch?v=YzQ2N0VkKvE), thanks to **Tech Minds**!

## Community

Join our [discord server](https://discord.gg/6ubfZkmc2C) to get help, share ideas, or contribute.

## Wiki

Many useful instructions and information are on the [wiki](https://github.com/shajen/sdr-hub/wiki).

# Screens

## Data

| Spectrogram                        | Transmission                        |
| ---------------------------------- | ----------------------------------- |
| ![](images/spectrograms.png?raw=1) | ![](images/transmissions.png?raw=1) |
| ![](images/spectrogram.png?raw=1)  | ![](images/transmission.png?raw=1)  |

## Configuration

| Scanner                      | Groups                       |
| ---------------------------- | ---------------------------- |
| ![](images/config.png?raw=1) | ![](images/groups.png?raw=1) |

# Quickstart

## Install docker

If you do not have `docker` installed, follow the instructions [here](https://docs.docker.com/desktop/) to install `docker`.

## Run

Using the upstream image:

```
docker run --rm -it --env TZ=Europe/Warsaw -p 8000:80 -v ./data:/app/data -v ./log:/var/log/sdr --device /dev/bus/usb:/dev/bus/usb shajen/sdr-hub
```

where `TZ=Europe/Warsaw` is your time zone.

All collected data and config will be permanently saved in the local `data` directory.

All logs will be permanently saved in the local `log` directory.

If you build and publish an image from this fork (for example, using `docker build` and pushing as `infamousrusty/sdr-hub` or to `ghcr.io/infamousrusty/sdr-hub`), you can substitute that image name in the command above. Any such image must continue to be distributed under the GPLv3 license (see License section).

## Web panel

Default web panel address is [http://127.0.0.1:8000/](http://127.0.0.1:8000/), default login: `admin`, password: `password`.

# Advanced

## Update

To update to the latest version just pull docker image `docker pull shajen/sdr-hub` and run again.

If you use a forked image (for example, `infamousrusty/sdr-hub`), rebuild and pull that image instead.

## Build from sources

Clone repository and run:

```
export SDR_MONITOR_IMAGE=shajen/sdr-monitor:latest # enter the selected image
export SDR_SCANNER_IMAGE=shajen/sdr-scanner:latest # enter the selected image

docker build -t shajen/sdr-hub --build-arg SDR_MONITOR_IMAGE --build-arg SDR_SCANNER_IMAGE .
```

You may change the `-t` tag to point at your own registry (e.g. `infamousrusty/sdr-hub` or `ghcr.io/infamousrusty/sdr-hub`) when redistributing this fork, provided you comply with the GPLv3 license.

## Debug

All logs are stored in the `/var/log/sdr/` directory in the docker container and can be downloaded [here](http://127.0.0.1:8000/sdr/logs/).

All data are stored in the `/app/data/` directory in the docker container and can be downloaded [here](http://127.0.0.1:8000/sdr/data/).

Please attach the `logs` when reporting a bug. **Issues without logs will be closed quickly!**

It's best to attach the ``logs and data`` from [here](http://127.0.0.1:8000/sdr/all/).

# Disclaimer

This software may receive and record radio signals. Use it legally — the authors take no responsibility for misuse or unlawful recording.

This applies equally to the upstream project and to this fork and any derived images (including the HAOS integration). You are responsible for ensuring your use complies with local laws and regulations.

# Contributing

In general don't be afraid to send pull request. Use the "fork-and-pull" Git workflow.

1. **Fork** the repo
2. **Clone** the project to your own machine
3. **Commit** changes to your own branch
4. **Push** your work back up to your fork
5. Submit a **Pull request** so that we can review your changes

NOTE: Be sure to merge the **latest** from **upstream** before making a pull request!

When contributing to this fork or to the HAOS integration, please ensure that any code you submit is compatible with the GPLv3 license and that you do not introduce proprietary components that would violate the upstream licensing.

# Donations

If you enjoy this project and want to support ongoing maintenance:

- GitHub: [infamousrusty](https://github.com/infamousrusty)
- Ko‑fi: https://ko-fi.com/infamousrusty
- Revolut: https://revolut.me/rustynuts
- BTC: bc1qdh860fvt3uz2yjwwtrr3ny36h3m4374x49509e

# License

[![License](https://img.shields.io/:license-GPLv3-blue.svg?style=flat-square)](https://www.gnu.org/licenses/gpl.html)

- *[GPLv3 license](https://www.gnu.org/licenses/gpl.html)*

This fork, the upstream project, and the Home Assistant OS integration are all distributed under the terms of the GNU General Public License version 3 (GPLv3). By using, modifying, or redistributing this code or any derived container images, you agree to comply with the GPLv3, including making source code available and preserving the license when distributing binaries or images.
