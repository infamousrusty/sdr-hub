ARG BUILD_ARCH
FROM ghcr.io/infamousrusty/sdr-hub:latest

# Home Assistant add-on labels (builder adds these automatically, but explicit is fine)
LABEL io.hass.type="addon"
LABEL io.hass.arch="${BUILD_ARCH}"

# Copy wrapper entrypoint
COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD ["/run.sh"]
