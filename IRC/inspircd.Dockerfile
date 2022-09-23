# Version
FROM ubuntu:20.04
# Para que no tenga interacción con inputs del usuario al momento de instalación
ARG DEBIAN_FRONTEND=noninteractive
WORKDIR /inspircd
# Se actualiza y se instalan las dependencias del software
RUN apt-get update \
&& apt-get install -y build-essential git wget curl byobu
# Se realiza una copia del directorio del software del servidor y se instala este último
RUN git clone --branch v3.11.0 "https://github.com/inspircd/inspircd.git" \
&& cd inspircd/ \
&& ./configure --disable-interactive --gid 0 --uid 0 \
&& make install \ 
&& chown root -R ../inspircd/
# Se añade la configuracción que esta contenida en el archivo
COPY inspircd.conf /inspircd/inspircd/run/conf/inspircd.conf

# Cambia el directorio de trabajo y al final se instanacia el servidor
RUN echo "cd /inspircd/inspircd && run/inspircd start --runasroot" >> ~/.bashrc
