FROM ubuntu:20.04

WORKDIR /tmp

ENV DEBIAN_FRONTEND=noninteractive
ENV VERSION=14.1

# 1\\ Instalar las dependencias del software.
RUN apt-get -y update && apt-get install -y \
    build-essential zlib1g-dev libreadline6-dev byobu wget

RUN wget https://ftp.postgresql.org/pub/source/v$VERSION/postgresql-$VERSION.tar.bz2 &&\
    tar -xvf postgresql-$VERSION.tar.bz2 

# 2\\ Installar Postgres desde código fuente.
RUN cd postgresql-$VERSION &&\
    ./configure            &&\
    make world-bin         &&\
    make install-world-bin

# 3\\ Configurar el entorno para el correcto funcionamiento del sw.
RUN useradd -ms /bin/bash postgres      &&\
    echo "postgres:postgres" | chpasswd &&\
    mkdir /usr/local/pgsql/data         &&\
    chown postgres:postgres /usr/local/pgsql/data

ENV PATH="/usr/local/pgsql/bin:${PATH}"

USER postgres

RUN echo "postgres" > password_file.txt &&\
    /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data/ -A md5 --pwfile=password_file.txt &&\
    echo "listen_addresses = '*'" >> /usr/local/pgsql/data/postgresql.conf &&\
    echo "host samerole all 0.0.0.0/0 md5" >> /usr/local/pgsql/data/pg_hba.conf

# Comando a ejecutar cuando se levanta el contenedor
RUN echo "#!/bin/sh -e\nbyobu new-session -d -s 'Server Postgres' && byobu select-pane -t 0 && byobu send-keys 'postmaster -D /usr/local/pgsql/data' Enter\nexec byobu" >> start.sh && \
    chmod +x start.sh
    
# Puerto conocido utilizado por postgres
EXPOSE 5432/tcp

CMD ["./start.sh"]

