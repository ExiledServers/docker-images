FROM node:alpine

LABEL maintainer="phantom@exiledservers.net"

USER container

ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/sh","/entrypoint.sh"]