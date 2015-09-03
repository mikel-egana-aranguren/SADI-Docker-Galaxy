SADI-Docker for Galaxy
======================

About
-----

A Docker image containing SADI client and associated tools that can be run in Galaxy

Docker: no dependnecies, no installation

Comparison with old SADI-Galaxy-Docker, "hence the name"

[SADI](http://sadiframework.org/content/about-sadi/) is a framework to define Semantic Web Services that consume and output [RDF](http://www.w3.org/standards/techs/rdf), and [SADI-Galaxy](https://github.com/mikel-egana-aranguren/SADI-Galaxy) makes SADI services available in the popular [Galaxy](http://galaxyproject.org/) platform. Thus, SADI-Galaxy is a nice SADI client to invoke SADI services in an environment that Biologists use often.

On the other hand, [Docker](http://www.docker.com/whatisdocker/) is a sort of "virtualisation" environment for deploying applications very easily, without configuration. Therefore I have created a y, so anyone interested in SADI-Galaxy can try it out easily within having to worry about dependencies. 



Installation
-----

Install Docker and do the thingy for avoiding sudo access: 

```
$ sudo apt-get install docker.io
$ sudo groupadd docker
$ sudo gpasswd -a your_user docker
$ sudo service docker.io restart
```

(You might need to log out and back in, and also I had to install apparmor).

Pull the [SADI-Docker image](https://registry.hub.docker.com/u/mikeleganaaranguren/sadi-galaxy):

```
$ docker pull mikeleganaaranguren/sadi-galaxy
```

Check that it has been succesfully pulled:

```
$  docker images

REPOSITORY                        TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
mikeleganaaranguren/sadi-galaxy   latest              xxxxxxxxxxx        3 days ago          895.8 MB
```



Download/clone the latest Galaxy version:

```
git clone https://github.com/galaxyproject/galaxy.git
```

Download/clone this repository (or the toolshed) and copy the `SADI-Docker` directory to the `tools` directory in galaxy.

Add a section to config/tool_conf.xml (first cp tool_conf.xml.sample tool_conf.xml):

```
    <section id="SADI-Docker" name="Docker SADI services">
		<tool file="SADI-Docker/SADI-Docker-sadi_client.xml"/>
		<tool file="SADI-Docker/SADI-Docker-RDFSyntaxConverter.xml"/>
		<tool file="SADI-Docker/SADI-Docker-mergeRDFgraphs.xml"/>
		<tool file="SADI-Docker/SADI-Docker-SPARQLGalaxy.xml"/>
		<tool file="SADI-Docker/SADI-Docker-rapper.xml"/>
		<tool file="SADI-Docker/SADI-Docker-tab2rdf.xml"/>
    </section>
```


Change the galaxy configuration so that it can run docker iamges instead of regular tools installed in your system. Add a destination docker local to job conf, and make it the default

cp job_conf.xml.sample_basic job_conf.xml Add these lines to job_conf.xml (change docker_memory to fit your needs):

```
<?xml version="1.0"?>
<!-- A sample job config that explicitly configures job running the way it is configured by default (if there is no explicit config). -->
<job_conf>
    <plugins>
        <plugin id="local" type="runner" load="galaxy.jobs.runners.local:LocalJobRunner" workers="4"/>
    </plugins>
    <handlers>
        <handler id="main"/>
    </handlers>
    <destinations default="docker_local">
        <destination id="local" runner="local"/>
	<destination id="docker_local" runner="local">
	  <param id="docker_enabled">true</param>
	  <param id="docker_memory">6G</param>
	  <param id="docker_sudo">false</param>
	  <param id="docker_net">bridge</param>
        </destination>
    </destinations>
</job_conf>

```

(look at job_conf.xml.sample_Advanced for more options regarding how Galaxy invokes docker containers, there are a lot of options)

The tools can also be installed through the tool shed.

Use case
------

run workflow (install workflow from tool shed or from .ga file in workflow/)

services:

http://sadiframework.org/services/getKEGGIDFromUniProt
http://biordf.org/cgi-bin/SADI/OpenLifeData2SADI/SADI/hgnc/uniprot_vocabulary_Resource_hgnc_vocabulary_x-uniprot-inverse_hgnc_vocabulary_Resource
http://biordf.org/cgi-bin/SADI/OpenLifeData2SADI/SADI/hgnc/hgnc_vocabulary_Resource_hgnc_vocabulary_x-omim_omim_vocabulary_Gene
http://biordf.org/cgi-bin/SADI/OpenLifeData2SADI/SADI/omim/omim_vocabulary_Gene_omim_vocabulary_article_pubmed_vocabulary_PubMedRecord


PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sadi: <http://sadiframework.org/ontologies/predicates.owl#>
PREFIX lsrn: <http://purl.oclc.org/SADI/LSRN/>

SELECT ?protein ?label ?KEGG
WHERE { 
?protein rdf:type lsrn:UniProt_Record . 
?protein sadi:isEncodedBy ?KEGG . 
?protein ?prot2hgnc ?hgnc . 
?hgnc ?hgnc2omim ?omim . 
?omim ?omim2pubmed ?pubmed . 
?pubmed rdfs:label ?label . 
FILTER (regex (?label, 'brain'))
}

workflow: datasets etc


Edit file dataset datatype to RDF if using the client

To reproduce the workflow ... 

Tools can also be found at the toolshed workflow can also be found at the toolshed

NOTE: 

tab2rdf is a "fork" of the tab2rdf tool from http://toolshed.g2.bx.psu.edu/view/sem4j/sparql_tools 

tab2rdf is a Galaxy tool that can convert tab files (3 columns) to RDF.

This version adds option for the user to define no base URI, ie all the entities of the tab file have their own URI. For example, one can add triples like this:

http://myurl.com#entity http://other_url_p http://foaf.com/my_friend









