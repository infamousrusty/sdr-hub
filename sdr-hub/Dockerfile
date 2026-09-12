# Home Assistant Add-on: SDR-Hub
# Build directly from upstream SDR-Hub sources

ARG BUILD_FROM
FROM ${BUILD_FROM:-debian:bullseye-slim}

# Install runtime dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Copy SDR-Hub sources from parent directory
COPY ../entrypoint /sdr-hub/entrypoint
COPY ../config /sdr-hub/config
COPY ../scripts /sdr-hub/scripts
COPY ../Dockerfile /sdr-hub/Dockerfile.upstream

# Set working directory
WORKDIR /sdr-hub

# Ensure entrypoint is executable
RUN chmod +x /sdr-hub/entrypoint/entrypoint.sh /sdr-hub/entrypoint/entrypoint_run.sh || true

# Expose web UI port
EXPOSE 8080

# Default command
CMD ["/sdr-hub/entrypoint/entrypoint.sh"]
