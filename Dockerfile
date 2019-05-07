# Build OpenRCT2
FROM ubuntu:19.04 AS build-env
RUN apt-get update \
 && apt-get install --no-install-recommends -y git cmake pkg-config ninja-build clang-6.0 libsdl2-dev libspeexdsp-dev libjansson-dev libcurl4-openssl-dev libcrypto++-dev libfontconfig1-dev libfreetype6-dev libpng-dev libzip-dev libssl-dev libicu-dev \
 && ln -s /usr/bin/clang-6.0 /usr/bin/clang \
 && ln -s /usr/bin/clang++-6.0 /usr/bin/clang++

ENV OPENRCT2_REF develop
WORKDIR /openrct2
RUN git -c http.sslVerify=false clone --depth 1 -b $OPENRCT2_REF https://github.com/OpenRCT2/OpenRCT2 . \
 && mkdir build \
 && cd build \
 && cmake .. -G Ninja -DCMAKE_BUILD_TYPE=release -DCMAKE_INSTALL_PREFIX=/openrct2-install/usr -DCMAKE_INSTALL_LIBDIR=/openrct2-install/usr/lib \
 && ninja -k0 install

# Build runtime image
FROM ubuntu:19.04
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y rsync ca-certificates libjansson4 libpng16-16 libzip5 libcurl4 libfreetype6 libfontconfig1 libicu63
RUN apt-get install --no-install-recommends -y curl

# Set up ordinary user
RUN useradd -m container

# Install OpenRCT2
COPY --from=build-env /openrct2-install /openrct2-install
RUN ls -la /home/container \
 && rsync -va /openrct2-install/* / \
 && rm -rf /openrct2-install

USER container
ENV HOME /home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh

CMD ["/bin/sh","/entrypoint.sh"]