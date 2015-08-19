# SADI-Docker-Galaxy
A Docker image containing SADI client and associated tools that can be run in Galaxy

Comparison with old SADI-Galaxy-Docker, "hence the name"

# NOTES TO DELETE WHEN RELEASED

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

Base for image (do not use busy box):

```
FROM ubuntu:14.04
MAINTAINER Mikel Egaña Aranguren <mikel.egana.aranguren@gmail.com>

# Install the necessary stuff with apt-get

RUN apt-get update && apt-get install -y git wget vim python python-setuptools raptor2-utils libraptor2-0

apt-get install python-rdflib is not working so use easy_install instead

RUN easy_install rdflib

# SADI does not like OpneJDK so install Java from http://www.duinsoft.nl/packages.php?t=en

RUN wget http://www.duinsoft.nl/pkg/pool/all/update-sun-jre.bin
RUN sh update-sun-jre.bin

# Copy SADI jar

RUN mkdir /sadi
COPY test-io.sh /sadi/
RUN chmod a+x /sadi/test-io.sh
ENV PATH $PATH:/sadi
```

No one expects the Spanish URL sanitizer:


```
<tool id="sadi_generic" name="SADI services generic caller" version="0.0.1">
	<description>Send any input RDF to any SADI service</description>
	
<!-- 	<command>${__tool_data_path__}/shared/errwrap.sh java -Xmx2000M -Xms250M -jar ${__tool_data_path__}/shared/jars/sadi_generic_client.jar $url $input > $output </command> -->

<!--  	errwrap.sh is not working, but for this sort of environment it shouldn't matter, since it is less likely to fail, and even less likely to be debugged -->

        <command>java -jar ${__tool_data_path__}/shared/jars/sadi_generic_client.jar $url $input > $output 2>/dev/null</command>
		
	<inputs>
		<param name="url" type="text" size="250" label="Service URL">
		  <sanitizer sanitize="False"/><!-- Disable sanitizer for URLs with e.g. tilde character -->
		</param>
		<param name="input" type="data" format="rdf" label="RDF input for SADI service"/>	
	</inputs>
	<outputs>
		<data format="rdf" name="output" />
	</outputs>
	<tests>
		<test>
			<param name="url" type="text" size="200" value="http://sadiframework.org/examples/hello" label="Service URL"/>
			<param name="input" type="data" format="rdf" label="hello-input.rdf"/>
			<!--<output name="output" file="test_hello_output.rdf" ftype="rdf"/>-->
			
			<output name="output">
				<assert_contents>
					<is_valid_xml />
					<has_text text="http://sadiframework.org/examples/hello.owl#GreetedIndividual" />
				</assert_contents>
			</output>
		</test>
		<test>
			<param name="url" type="text" size="200" value="http://sadiframework.org/examples/pdb2uniprot" label="Service URL"/>
			<param name="input" type="data" format="rdf" label="pdb2uniprot-input.rdf"/>
<!-- 			<output name="output" file="" ftype="rdf"/> -->

			<output name="output">
				<assert_contents>
					<is_valid_xml />
					<has_text text="http://sadiframework.org/examples/pdb2uniprot.owl#OutputClass" />
				</assert_contents>
			</output>
		</test>
		<test>
			<param name="url" type="text" size="200" value="http://sadiframework.org/examples/uniprotInfo" label="Service URL"/>
			<param name="input" type="data" format="rdf" label="uniprotInfot-input.rdf"/>
<!-- 			<output name="output" file="" ftype="rdf"/> -->

			<output name="output">
				<assert_contents>
					<is_valid_xml />
					<has_text text="http://sadiframework.org/examples/uniprotInfo.owl#AnnotatedUniProtRecord" />
				</assert_contents>
			</output>
		</test>
		<test>
			<param name="url" type="text" size="200" value="http://dev.biordf.net/~kawas/cgi-bin/getdbSNPRecordByUniprotID" label="Service URL"/>
			<param name="input" type="data" format="rdf" label="dbSNPUniprotInput.rdf"/>
<!-- 			<output name="output" file="" ftype="rdf"/> -->

			<output name="output">
				<assert_contents>
					<is_valid_xml />
					<has_text text="http://purl.oclc.org/SADI/LSRN/dbSNP_Identifier" />
				</assert_contents>
			</output>
		</test>
		<test>
			<param name="url" type="text" size="200" value="http://localhost:9090#" label="Service URL"/>
			<param name="input" type="data" format="rdf" label="hello-input-localhost-SADI.rdf"/>
			<output name="output" file="hello-output-localhost-SADI.rdf" ftype="rdf"/>
		</test>
		
		
		
	</tests>
	
	<help>
	  
	  **What it does**
	  
	  Given an RDF input and a SADI service URL, infers whether the RDF complies with the service's input OWL Class and if so executes it, obtaining an ouput RDF from the SADI service. 
	  
	  **About**
	  
	  More information and contact: http://github.com/mikel-egana-aranguren/SADI-Galaxy
	  
	</help>
</tool>
```





