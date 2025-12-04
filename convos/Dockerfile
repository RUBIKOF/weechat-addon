FROM perl:5.38-slim

# Evitar que debconf intente diálogos interactivos
ENV DEBIAN_FRONTEND=noninteractive
ENV CONVOS_HOME=/data
ENV PERL_MM_USE_DEFAULT=1

# Instalar compiladores + librerías nativas típicas para Convos y dependencias
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      ca-certificates \
      curl \
      libssl-dev \
      libpq-dev \
      libz-dev \
      libgdbm-dev \
      libreadline-dev \
      libsqlite3-dev \
      libcurl4-openssl-dev && \
    update-ca-certificates && \
    curl -L https://cpanmin.us | perl - App::cpanminus && \
    cpanm --notest Convos && \
    apt-get purge -y build-essential git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /root/.cpanm

EXPOSE 3000

COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
