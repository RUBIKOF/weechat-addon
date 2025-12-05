ARG BUILD_FROM

FROM debian:stable-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        znc \
        ca-certificates \
        net-tools \
        curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
    
EXPOSE 6667 8888

COPY run.sh /usr/bin/run.sh
RUN chmod +x /usr/bin/run.sh

CMD [ "/usr/bin/run.sh" ]
