FROM ubuntu:18.04

WORKDIR /project/

COPY . .

RUN apt-get update \ 
    && apt-get install -y wget curl

ARG VERSION=v4.13.0
ARG BINARY=yq_linux_386
RUN wget https://github.com/mikefarah/yq/releases/download/${VERSION}/${BINARY} -O /usr/bin/yq \ 
    && chmod +x /usr/bin/yq


RUN curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get > install-helm.sh \ 
    && chmod u+x install-helm.sh \
    && ./install-helm.sh
    
