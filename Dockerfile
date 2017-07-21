FROM mhart/alpine-node-auto:latest
MAINTAINER jim@bamboocando.com

RUN mkdir /site-master && apk update && apk update
RUN apk add curl python make
RUN apk add git

WORKDIR /site-master
ADD package.json /site-master
RUN npm install

ADD . /site-master
#RUN curl -LOu jahbini:Tqbfj0tlD https://github.com/jahbini/snowserv/archive/master.zip && unzip master.zip && rm master.zip
VOLUME /site-master/domains
CMD sleep 500
