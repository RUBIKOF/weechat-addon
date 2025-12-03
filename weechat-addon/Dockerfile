ARG BUILD_FROM=weechat/weechat:latest
FROM ${BUILD_FROM}

# Configura el relay de WeeChat
RUN mkdir -p /home/weechat/.weechat
COPY run.sh /run.sh
RUN chmod a+x /run.sh

# Puerto para el relay
EXPOSE 9001

CMD ["/run.sh"]
