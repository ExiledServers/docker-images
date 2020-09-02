FROM debian:stable-slim

LABEL maintainer="phantom@exiledservers.net"

RUN apt-get -q -y update \
	&& apt-get -q -y dist-upgrade \
	&& apt-get -q -y --no-install-recommends install lib32gcc1 lib32stdc++6 lib32ncurses6 ca-certificates curl tar \
	&& apt-get -q -y autoremove \
	&& apt-get -q -y clean \
	&& useradd -m container \
	&& mkdir -p /opt/steamcmd \
	&& curl -fsSL http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -xz -C /opt/steamcmd \
	&& chown -R root:root /opt/steamcmd \
	&& chmod -R 777 /opt/steamcmd \
	&& /opt/steamcmd/steamcmd.sh +login anonymous +quit

USER container

ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/sh","/entrypoint.sh"]