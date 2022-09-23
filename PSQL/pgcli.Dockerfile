FROM ubuntu:20.04

WORKDIR /tmp

ENV DEBIAN_FRONTEND=noninteractive
ENV VERSION=14.1

ENV USER=postgres
ENV PASS=postgres

# 1\\ Instalar las dependencias del software.
RUN apt-get -y update && apt-get install -y \
    python3 python3-dev python3-pip libpq-dev git byobu 

RUN git clone https://github.com/dbcli/pgcli pgcli &&\
    pip3 install ./pgcli

# configurar 'pgcli' -> conexión completa al contenedor del servidor :)
RUN echo "#!/bin/sh\nbyobu new-session -d -s 'Cliente PGSQL' && byobu select-pane -t 0 && byobu send-keys 'pgcli' Enter\nexec byobu" > start.sh && chmod +x start.sh

# Comando a ejecutar cuando se levanta el contenedor
CMD ./start.sh