FROM ubuntu:20.04

ENV DEBIAN_FRONTEND interactive

RUN apt-get update -y && \
    apt-get install -y build-essential python3 git && \
    apt-get clean

WORKDIR /tmp
RUN git clone https://github.com/jrosdahl/miniircd miniircd && \
    cp miniircd/miniircd /usr/local/bin

#EXPOSE 6666/tcp 6667/tcp 6697/tcp

USER nobody

CMD ["miniircd", "--verbose"]