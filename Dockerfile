FROM ubuntu:18.04

WORKDIR /project/

COPY . .

RUN apt-get update \ 
    && apt-get install -y wget

ARG VERSION=v4.13.0
ARG BINARY=yq_linux_386
RUN wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq \ 
    && chmod +x /usr/bin/yq
