FROM mono:latest

LABEL maintainer="phantom@exiledservers.net"

RUN apt-get -q -y update \
	&& apt-get -q -y dist-upgrade \
	&& apt-get -q -y autoremove \
	&& apt-get -q -y clean \
#	&& rm -rf /var/lib/{apt,dpkg,cache,log} \
	&& useradd -m container

USER container

ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/sh","/entrypoint.sh"]