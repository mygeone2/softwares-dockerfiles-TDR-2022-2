# VERSION
FROM ubuntu:20.04

WORKDIR /tmp

# VARIBLES DE ENTORNO
ENV DEBIAN_FRONTEND noninteractive
ENV GOVERSION 1.15.2
ENV RTSVERSION 0.9.15
ENV GOPATH /root/.go

# INSTALACION DE LIBRERIAS/HERRAMIENTAS
RUN apt-get -yqq update \
    && apt-get clean \
    && apt-get install -yqq build-essential wget ffmpeg byobu

# INSTALACION DE GO
RUN cd /tmp && wget https://golang.org/dl/go${GOVERSION}.linux-amd64.tar.gz &&\
    tar -C /usr/local -xzf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz && \
    echo "export PATH=$PATH:/usr/local/go/bin" >> ~/.bashrc && bash -- &&\
    mkdir $GOPATH

# DESCARGA DE rtsp-simple-server
RUN cd /tmp && wget https://github.com/aler9/rtsp-simple-server/archive/v${RTSVERSION}.tar.gz &&\
    tar -C . -xzf v${RTSVERSION}.tar.gz 
    
WORKDIR /tmp/rtsp-simple-server-${RTSVERSION}

ENV PATH=/usr/local/go/bin:$PATH

RUN echo "#!/bin/sh\nbyobu new-session -d -s 'Server RTSP' && byobu select-pane -t 0 && byobu send-keys 'go run .' Enter\nbyobu split-window -h\nbyobu send-keys 'sleep 10' Enter\nbyobu send-keys 'ffmpeg -re -stream_loop -1 -i test-images/ffmpeg/emptyvideo.ts -c copy -f rtsp rtsp://localhost:8554/mystream' Enter\nexec byobu" > start.sh && chmod +x start.sh

CMD ./start.sh