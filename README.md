# SADI-Docker-Galaxy
A Docker image containing SADI client and associated tools that can be run in Galaxy

Docker: no dependnecies, no installation

Comparison with old SADI-Galaxy-Docker, "hence the name"



# INSTRUCTIONS

git clone latest galaxy

git clone SADI-Docker Galaxy and add the tools manually 

tool_conf.xml:

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
or install through tool shed

change the galaxy configuration so that it can run docker iamges

job_conf.xml:

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

(look at job_conf.xml.sample_Advanced for more options)

pull docker image

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

NOTE: 

tab2rdf is a "fork" of the tab2rdf tool from http://toolshed.g2.bx.psu.edu/view/sem4j/sparql_tools 

tab2rdf is a Galaxy tool that can convert tab files (3 columns) to RDF.

This version adds option for the user to define no base URI, ie all the entities of the tab file have their own URI. For example, one can add triples like this:

http://myurl.com#entity http://other_url_p http://foaf.com/my_friend









