# Version
FROM ubuntu:20.04
# Se crea un entorno de trabajo en el cirecotio de nombre irssi
WORKDIR /irssi
# Para que no tenga interacción con inputs del usuario al momento de instalación
ARG DEBIAN_FRONTEND=noninteractive
# Se actualizan y instalan todas las dependencias para el software en cuestión
RUN apt-get update \
&& apt-get install -yqq autoconf \
                        automake \
                        build-essential \
                        git \
                        libglib2.0-dev \
                        libncurses5-dev \
                        libssl-dev \
                        libtool \
                        lynx \
                        pkg-config \
                        openssl \
                        perl
# Mediante el uso de git se instala software del cliente
RUN git clone --branch 1.2.3 "https://github.com/irssi/irssi" && cd irssi/ \
&& ./autogen.sh \
&& make install
# Se define un usuario para el cliente irssi
RUN useradd -m -r usuario

USER usuario
# Se ejecuta el comando para iniciar el cliente
ENTRYPOINT ["irssi"]