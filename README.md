# SADI-Docker-Galaxy
A Docker image containing SADI client and associated tools that can be run in Galaxy

Comparison with old SADI-Galaxy-Docker, "hence the name"



# INSTRUCTIONS

git clone latest galaxy

git clone SADI-Docker Galaxy and add the tools manually 

tool_conf.xml:

```
    <section name="SADI services" id="SADI">
		<tool file="SADI/sadi_generic.xml"/>
		<tool file="SADI/RDFSyntaxConverter.xml"/>
		<tool file="SADI/mergeRDFgraphs.xml"/>
		<tool file="SADI/SPARQLGalaxy.xml"/>
		<tool file="SADI/rapper.xml"/>
		<tool file="SADI/tab2rdf.xml"/>
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
	  <param id="docker_sudo">false</param>
	  <param id="docker_net">bridge</param>
        </destination>
    </destinations>
</job_conf>

```

pull docker image

run installed workflow

Edit file dataset datatype to RDF

NOTE: 

tab2rdf is a "fork" of the tab2rdf tool from http://toolshed.g2.bx.psu.edu/view/sem4j/sparql_tools 

tab2rdf is a Galaxy tool that can convert tab files (3 columns) to RDF.

This version adds option for the user to define no base URI, ie all the entities of the tab file have their own URI. For example, one can add triples like this:

http://myurl.com#entity http://other_url_p http://foaf.com/my_friend









