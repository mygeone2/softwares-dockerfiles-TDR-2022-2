FROM ubuntu:20.04

WORKDIR /tmp

ENV DEBIAN_FRONTEND=noninteractive
# Credenciales a usar
ENV USER taller
ENV PASS taller

# 1\\ Instalar dependencias
RUN apt-get update -yqq &&\
    apt-get install -yqq build-essential git &&\
    apt-get clean &&\
    git clone https://github.com/proftpd/proftpd 

# 2\\ Instalar proftpd
RUN cd proftpd  &&\
    ./configure &&\
    make        &&\
    make install

# 3\\ Agregar el usuario taller
RUN useradd -ms /bin/bash $USER &&\
    echo "$USER:$PASS" | chpasswd $USER

CMD ["proftpd", "--nodaemon"]