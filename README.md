# docker-mapfish-print (formerly docker-mfprint)

Docker image and tools for MapFish Print (currently v3).
Initially this Docker image is provided for the [Dutch Kadaster](http://www.kadaster.nl)
but may be useful in other applications.
See my repo [docker-mapfish-print2](https://github.com/justb4/docker-mapfish-print2) for 
a MapFish Print version 2 legacy Docker Image.

## Log4J 

This project does **not** use LogJ (nor v1 nor v2)! It uses [Logback](http://logback.qos.ch/).

## Building

With the script [build.sh](build.sh) the Docker image can be build
from the [Dockerfile](Dockerfile) but this is not really necessary as
you may use your own ``docker build`` commandline.

Build argumments with values if not passed to build:

- **IMAGE_TIMEZONE** - timezone of Docker image, default ``"Europe/Amsterdam"``
- **TOMCAT_EXTRAS** - include Tomcat docs, examples etc? Best to leave out, default ``false``
- **MFPRINT_APPS** - include Standard MFP print-apps (examples)? default ``true``

### Build Options

The files under the  [config](config) dir are automatically integrated in the Docker image as follows:

- [config/tomcat/*](config/tomcat): override any files in the standard Tomcat install (see below)
- [config/tomcat/bin/setenv.sh](config/tomcat/bin/setenv.sh): Tomcat options like for memory, proxies etc
- [config/tomcat/conf/server.xml](config/tomcat/bin/setenv.sh): server settings like port (default 8080) and threads
- [config/webapp/print-apps](config/webapp/print-apps): your own custom templates to be integrated in the MFP webapp
- [config/webapp/WEB-INF/web.xml](config/webapp/WEB-INF/web.xml): override web.xml for Tomcat MFP .war
- [config/webapp/index.html](config/webapp/index.html): override index.html, the demo page

## Running

The is a [run.sh](run.sh) script but you may use the Docker image in any context like
using Docker-compose etc.

## Credits

* Kartoza team: https://github.com/kartoza for providing good examples of Dockerfiles for FOSS geospatial Java .war's.
* TT Fonts addition: https://github.com/panosoft/docker-prince-server/blob/master/Dockerfile
* [CampToCamp](https://www.camptocamp.com/) for developing MapFish Print and many other useful FOSS Geospatial software

