ARG BUILD_FROM
FROM $BUILD_FROM

# Install ZNC
RUN \
    apk add --no-cache \
        znc \
        znc-extra \
        su-exec

# Create znc user (if not exists)
RUN \
    if ! id znc >/dev/null 2>&1; then \
        adduser -S -D -H -h /var/lib/znc znc; \
    fi

# Copy run script
COPY run.sh /
RUN chmod a+x /run.sh

# Set up volumes
VOLUME ["/config"]

# Expose ports
EXPOSE 6667
EXPOSE 8888

CMD [ "/run.sh" ]
