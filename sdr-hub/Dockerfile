# Home Assistant Add-on: SDR-Hub
# Self-contained build (no external image dependency)

ARG BUILD_FROM
FROM ${BUILD_FROM:-alpine:latest}

# Install runtime dependencies (Alpine uses apk, not apt-get)
RUN apk add --no-cache \
    bash \
    ca-certificates \
    curl \
    jq

# Copy add-on files
COPY entrypoint /sdr-hub/entrypoint
COPY config /sdr-hub/config
COPY scripts /sdr-hub/scripts

WORKDIR /sdr-hub

# Ensure scripts are executable
RUN chmod +x /sdr-hub/entrypoint/entrypoint.sh \
    /sdr-hub/entrypoint/entrypoint_run.sh \
    /sdr-hub/scripts/start.sh

EXPOSE 8080

CMD ["/sdr-hub/entrypoint/entrypoint.sh"]
