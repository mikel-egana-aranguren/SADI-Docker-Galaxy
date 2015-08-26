# SADI-Docker-Galaxy
A Docker image containing SADI client and associated tools that can be run in Galaxy

Comparison with old SADI-Galaxy-Docker, "hence the name"



# INSTRUCTIONS

Pull image

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
    <destinations default="local">>
      <destination id="local" runner="local"/>
      <destination id="docker_local" runner="local">
	<param id="docker_enabled">true</param>
	<param id="docker_sudo">false</param>
      </destination>
    </destinations>
</job_conf>

```

tool_conf.xml:

```
    <section name="SADI services" id="SADI">
	<label text="SADI common utilities" id="SADI-common-utilities"/>
		<tool file="SADI/sadi_generic.xml"/>
		<tool file="SADI/RDFSyntaxConverter.xml"/>
		<tool file="SADI/mergeRDFgraphs.xml"/>
	<label text="SADI services" id="SADI-services"/>
		<tool file="SADI/getdbSNPRecordByUniprotID.xml"/>
	<label text="Other necessary tools" id="Other-necessary-tools"/>
		<tool file="sparql_galaxy/SPARQLGalaxy.xml"/>
		<tool file="rdf/rapper.xml"/>
		<tool file="rdf/tab2rdf.xml"/>
  </section>
```

Edit file dataset datatype to RDF









