FROM debian:bookworm-slim AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    jq \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -r -s /bin/false sdrhub || true

WORKDIR /app

COPY sdr-hub/run.sh /usr/local/bin/sdr-hub-run
COPY sdr-hub/entrypoint/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod 0755 /usr/local/bin/sdr-hub-run /usr/local/bin/entrypoint.sh \
    && sed -i 's/\r$//' /usr/local/bin/sdr-hub-run /usr/local/bin/entrypoint.sh

USER sdrhub

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/local/bin/sdr-hub-run"]
