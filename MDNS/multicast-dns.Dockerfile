FROM ubuntu:20.04

#Configuramos nuestro espacio de trabajo y seteamos la zona y la hrs
WORKDIR /tmp
ENV TZ=America/Santiago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#Variable de entorno que impide interaccion
ARG DEBIAN_FRONTEND=noninteractive
#Actualizamos los paquetes e instalamos los escenciales para ubuntu
RUN apt -yqq update && apt upgrade -yqq
RUN apt install -yqq build-essential 
RUN apt install -yqq libapr1-dev libaprutil1-dev libpcre3-dev
RUN apt-get install ca-certificates -y \
    && apt clean

#Instalamos los paquete necesarios para la instalacion del cliente y el cliente 
RUN apt install -yqq elixir erlang git pkg-config
RUN git clone https://github.com/NationalAssociationOfRealtors/mdns.git
WORKDIR /tmp/mdns
#Como estamos en modo no interactivo necesitamos forzar el local
RUN mix local.hex --force
RUN mix do deps.get
RUN mix do deps.compile

CMD iex -S mix

#docker build -t servidor .
#docker run --name sv --net=internet -it servidor
