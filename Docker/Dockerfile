FROM ubuntu:14.04
MAINTAINER Mikel Egaña Aranguren <mikel.egana.aranguren@gmail.com>

# Install the necessary stuff with apt-get

RUN apt-get update && apt-get install -y git wget vim python python-setuptools raptor2-utils libraptor2-0

# apt-get install python-rdflib is not working so use easy_install instead

RUN easy_install rdflib

# SADI does not like OpneJDK so install Java from http://www.duinsoft.nl/packages.php?t=en

RUN wget http://www.duinsoft.nl/pkg/pool/all/update-sun-jre.bin
RUN sh update-sun-jre.bin

# Copy SADI jar

RUN mkdir /sadi
COPY test-io.sh /sadi/
RUN chmod a+x /sadi/test-io.sh
ENV PATH $PATH:/sadi
