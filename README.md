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









