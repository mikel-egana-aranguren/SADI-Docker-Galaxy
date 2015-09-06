SADI-Docker for Galaxy
======================

About
-----

[SADI](http://sadiframework.org/content/about-sadi/) is a framework to define Semantic Web Services that consume and produce [RDF](http://www.w3.org/standards/techs/rdf), and [SADI-Galaxy](https://github.com/mikel-egana-aranguren/SADI-Galaxy) makes SADI services available in the popular [Galaxy](http://galaxyproject.org/) platform. Thus, SADI-Galaxy is a nice SADI client to invoke SADI services in an environment that Biologists use often, and in which SADI services can interact with other tools and services.

On the other hand, [Docker](http://www.docker.com/whatisdocker/) is a sort of "virtualisation" environment for deploying applications very easily, without configuration or installation of dependencies. Therefore I have created ADI-Docker, a Docker image containing all the necessary SADI tools that can be easily invoked through the Galaxy tools also provided in this repository. Therefore, SADI can be used within Galaxy with a minimal installation (only the Docker image and the Galaxy XML files, see bellow). Even more, the SADI-Docker can be used as a regular Docker image, runing it as a standalone Operating System pre-configured to invoke SADI services.

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

Pull the [SADI-Docker image](https://hub.docker.com/r/mikeleganaaranguren/sadi/):

```
$ docker pull mikeleganaaranguren/sadi:v6
```

Check that it has been succesfully pulled:

```
$  docker images

REPOSITORY                 TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
mikeleganaaranguren/sadi   v6                  0bb03066587d        46 hours ago        580.3 MB
```

Download/clone the latest Galaxy version:

```
git clone https://github.com/galaxyproject/galaxy.git
```

Download/clone this repository and copy the `SADI-Docker` directory to the `tools` directory in your Galaxy installation. You can also install the Galaxy tools from within your Galaxy instance as regular Galaxy tools (https://toolshed.g2.bx.psu.edu/view/mikel-egana-aranguren/sadi_docker/54c48f9ca32b). There are 5 Galaxy tools:

* `SADI-Docker-sadi_client`: a SADI client for synchronous SADI services.
* `SADI-Docker-RDFSyntaxConverter`: a tool to convert between different RDF syntaxes, including production of TSV files.
* `SADI-Docker-mergeRDFgraphs`: a tool to merge different RDF graphs into one.
* `SADI-Docker-SPARQLGalaxy`: a tool to perform SPARQL queries against RDF files.
* `SADI-Docker-rapper`: a tool to convert RDF files.
* `SADI-Docker-tab2rdf`: a tool to produce RDF files from TSV files.

Add a section to config/tool_conf.xml (first copy tool_conf.xml.sample to tool_conf.xml):

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


Change the galaxy configuration so that it can run Docker images as if they were regular tools installed in your system. Add a destination, `docker_local` to your configuration, and make it the default.Copy job_conf.xml.sample_basic to job_conf.xml and add these lines to job_conf.xml (change `docker_memory` to if necessary):

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

(look at job_conf.xml.sample_advanced for more options regarding how Galaxy invokes Docker containers, since there are a lot of options).

Run Galaxy and the tools should appear under `Docker SADI services`. 

Use case
------

In order to test the installation, you can run a pre-defined workflow. Upload the file UniProt_IDs.txt, in `ẁorkflow/`, to your current Galaxy history. Then you can import the workflow in Galaxy in Workflows, Import or Upload Workflow, and choosing the file `workflow/SADI-Docker_use_case.ga` (You can also find the workflow at the tool shed, http://toolshed.g2.bx.psu.edu/view/mikel-egana-aranguren/sadi_docker_workflow/22be3a551998). Then run the workflow, choosing the UniProt_IDs.txt dataset as input.

The workflow finds ... 

The SADI services used in the workflow are:

* http://sadiframework.org/services/getKEGGIDFromUniProt
* http://biordf.org/cgi-bin/SADI/OpenLifeData2SADI/SADI/hgnc/uniprot_vocabulary_Resource_hgnc_vocabulary_x-uniprot-inverse_hgnc_vocabulary_Resource
* http://biordf.org/cgi-bin/SADI/OpenLifeData2SADI/SADI/hgnc/hgnc_vocabulary_Resource_hgnc_vocabulary_x-omim_omim_vocabulary_Gene
* http://biordf.org/cgi-bin/SADI/OpenLifeData2SADI/SADI/omim/omim_vocabulary_Gene_omim_vocabulary_article_pubmed_vocabulary_PubMedRecord

And the SPARQL query to obtain the result:

```
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
```
Note that when using the SADI client, the input dataset's datatypes must be edited, stating that the input is an RDF file.

Notes
-----

This project is a continuation of [SADI-Galaxy-Docker](http://github.com/mikel-egana-aranguren/SADI-Galaxy-Docker), with the inverse approach, hence the name: SADI-Galaxy-Docker was a complete Galaxy server, configured with SADI tools, within a Docker image; SADI-Docker is a Docker image with only SADI tools, and any Galaxy instance can invoke the image.

Tab2rdf is a "fork" of the [tab2rdf](http://toolshed.g2.bx.psu.edu/view/sem4j/sparql_tools). This version adds option for the user to define no base URI, i.e. all the entities of the tab file have their own URI. 








