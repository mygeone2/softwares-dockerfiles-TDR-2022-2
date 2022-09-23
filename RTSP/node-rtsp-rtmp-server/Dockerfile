FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -yqq  && apt-get -yqq install git \
  nodejs npm byobu ffmpeg

RUN npm install --global coffeescript

RUN git clone https://github.com/iizukanao/node-rtsp-rtmp-server.git

WORKDIR node-rtsp-rtmp-server

RUN npm install

RUN sed -i 's/serverPort: 80/serverPort: 554/' config.coffee

COPY video.mp4 .

EXPOSE 8554
EXPOSE 554
EXPOSE 8080

RUN echo "#!/bin/sh\nbyobu new-session -d -s 'Server RTSP' && byobu select-pane -t 0 && byobu send-keys 'coffee server.coffee' Enter\nbyobu split-window -h\nbyobu send-keys 'sleep 10' Enter\nbyobu send-keys 'ffmpeg -re -stream_loop -1 -i video.mp4 -c:v libx264 -preset fast -c:a aac -b:a 128k -ar 44100 -f rtsp rtsp://172.17.0.2:554/live/stream' Enter\nexec byobu" > start.sh && chmod +x start.sh

CMD ./start.sh