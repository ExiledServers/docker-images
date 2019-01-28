FROM mono:5.14

LABEL maintainer="phantom@exiledservers.net"

RUN apt-get -q -y update \
	&& apt-get -q -y dist-upgrade \
	&& apt-get -q -y --no-install-recommends install mono-complete unzip \
	&& apt-get -q -y autoremove \
	&& apt-get -q -y clean \
	&& useradd -m container

USER container

ENV HOME /home/container

WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/sh","/entrypoint.sh"]