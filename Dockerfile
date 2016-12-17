FROM mhart/alpine-node-auto:latest
MAINTAINER jim@bamboocando.com

RUN mkdir /site-master && apk update
RUN apk add curl git

WORKDIR /site-master
ADD package.json /site-master
RUN npm install
RUN npm install coffee-script -g
RUN npm install brunch -g

ADD . /site-master
VOLUME /site-master/public
VOLUME /site-master/domains
RUN pwd && ls -lisa
CMD cake go
