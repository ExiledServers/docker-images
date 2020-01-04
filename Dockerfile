FROM debian:stable-slim

LABEL maintainer="phantom@exiledservers.net"

RUN apt-get update \
	&& apt-get install -y --no-install-recommends ca-certificates apt-transport-https gnupg2 curl \
	&& curl -fsSL https://dl.winehq.org/wine-builds/winehq.key | apt-key add - \
	&& dpkg --add-architecture i386 \
	&& echo "deb https://dl.winehq.org/wine-builds/debian/ stable main" >> /etc/apt/sources.list \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends winehq-stable \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/* \
	&& adduser -D -h /home/container container

USER container

ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/sh","/entrypoint.sh"]