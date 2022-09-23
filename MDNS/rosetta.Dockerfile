FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

RUN apt-get -yqq update &&\
    apt-get -yqq install build-essential elixir erlang pkg-config git &&\
    apt clean &&\
    git clone https://github.com/rosetta-home/mdns.git

RUN chown root -R /mdns

RUN cd mdns &&\
    mix local.hex --force &&\
    mix do deps.get, deps.compile 

RUN mix local.hex --force

WORKDIR /tmp/mdns
RUN mix do deps.get, deps.compile
CMD ["iex", "-S", "mix"]
