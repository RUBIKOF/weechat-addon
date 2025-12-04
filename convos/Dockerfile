FROM perl:5.38-slim

# Variables básicas
ENV CONVOS_HOME=/data
ENV PERL_MM_USE_DEFAULT=1

# Instalar dependencias y Convos desde CPAN
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      build-essential \
      git \
      ca-certificates \
      curl && \
    update-ca-certificates && \
    curl -L https://cpanmin.us | perl - App::cpanminus && \
    cpanm --notest Convos && \
    apt-get purge -y build-essential git && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Puerto por defecto de Convos
EXPOSE 3000

# Script de arranque
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]
