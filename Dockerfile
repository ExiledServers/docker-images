FROM debian:stable-slim

LABEL maintainer="phantom@exiledservers.net"

RUN apt-get -q -y update \
	&& apt-get -q -y dist-upgrade \
	&& apt-get -q -y --no-install-recommends install lib32gcc1 lib32stdc++6 libtinfo5 ca-certificates curl tar  \
	&& apt-get -q -y autoremove \
	&& apt-get -q -y clean \
	&& useradd -m container \
	&& mkdir -p /opt/steamcmd \
	&& curl -s http://media.steampowered.com/installer/steamcmd_linux.tar.gz | tar -xz -C /opt/steamcmd \
	&& /opt/steamcmd/steamcmd.sh +login anonymous +quit \
	&& chown -R root:root /opt/steamcmd

USER container

ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/sh","/entrypoint.sh"]