FROM ubuntu:18.04

LABEL maintainer="noah@noahnu.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y sudo \
    m4 libmad0-dev libmp3lame-dev libpcre3-dev \
    libsamplerate0-dev libtag1-dev camlp4-extra pkg-config \
    opam icecast2 && \
    apt-get clean && \
    adduser --uid 1001 --disabled-password --gecos '' docker && \
    adduser docker sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER docker
RUN opam init -a -y && opam install -y depext && \
    opam depext taglib mad lame cry samplerate liquidsoap && \
    opam install -y taglib mad lame cry samplerate liquidsoap

EXPOSE 8000

COPY ./liquidsoap/liquidsoap.tmpl.liq /home/docker/liquidsoap.liq
COPY ./icecast/icecast.tmpl.xml /etc/icecast2/icecast.xml

RUN sudo mkdir -p /home/docker/audiofiles
COPY ./audiofiles /home/docker/audiofiles
VOLUME /home/docker/audiofiles

COPY ./docker-entrypoint.sh / 
ENTRYPOINT ["/docker-entrypoint.sh"]
