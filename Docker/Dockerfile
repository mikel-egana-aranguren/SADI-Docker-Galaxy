FROM ubuntu:14.04
MAINTAINER Mikel Egaña Aranguren <mikel.egana.aranguren@gmail.com>

# Install the necessary stuff with apt-get

RUN apt-get update && apt-get install -y git wget vim python python-setuptools raptor2-utils libraptor2-0

apt-get install python-rdflib is not working so use easy_install instead

RUN easy_install rdflib

# SADI does not like OpneJDK so install Java from http://www.duinsoft.nl/packages.php?t=en

RUN wget http://www.duinsoft.nl/pkg/pool/all/update-sun-jre.bin
RUN sh update-sun-jre.bin

RUN mkdir /sadi
COPY sadi_generic_client.jar /sadi/
COPY RDFSyntaxConverter.jar /sadi/
COPY __init__.py /sadi/
COPY MergeRDFGraphs.py /sadi/ 
COPY tab2rdf.py /sadi/
ENV PATH $PATH:/sadi




