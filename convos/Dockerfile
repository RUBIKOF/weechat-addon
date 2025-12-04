FROM nordaaker/convos:latest

# Home Assistant usa /data como volumen persistente
ENV CONVOS_HOME=/data

# Copiamos nuestro script de arranque
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
