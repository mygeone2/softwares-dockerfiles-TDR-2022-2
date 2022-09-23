# Version
FROM ubuntu:20.04
# Para que no tenga interacción con inputs del usuario al momento de instalación
ARG DEBIAN_FRONTEND=noninteractive
# Instalación de dependencias, actualización e instalación de software
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get install -y libgcrypt20-dev zlib1g-dev clang clang clang libgcrypt20-dev\
   libcurl4-gnutls-dev pkg-config libncursesw5-dev cmake build-essential wget zlib1g-dev\ 
   libgcrypt20-dev libgnutls28-dev gettext ca-certificates libaspell-dev python3-dev\
   libperl-dev ruby ruby-dev liblua5.3-dev tcl-dev guile-2.0-dev libv8-dev php-dev libphp-embed\
   libxml2-dev libargon2-0-dev libsodium-dev asciidoctor libcpputest-dev\
   && wget https://github.com/weechat/weechat/archive/v2.9.tar.gz\
   && tar -xzf v2.9.tar.gz\
   && cd weechat-2.9\
   && mkdir build\
   && cd build\
   && cmake ..\
   && make\
   && make install

# Se define el puerto por el cual debiese de generar tráfico 
#EXPOSE 6666/tcp 6667/tcp 6697/tcp
# Comando para accionar el cliente
ENTRYPOINT ["weechat"]

# sudo docker run --net=IRC -it client