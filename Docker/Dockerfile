FROM busybox:ubuntu-14.04
MAINTAINER Mikel Egaña Aranguren <mikel.egana.aranguren@gmail.com>

RUN mkdir /sadi
COPY test-io.sh /sadi/
RUN chmod a+x /sadi/test-io.sh
ENV PATH $PATH:/sadi




