# docker-mfprint

Docker image and tools for MapFish Print (currently v3).
Initially this Docker image is provided for the [Dutch Kadaster](http://www.kadaster.nl)
but may be useful in other applications.

## Building

With the script [build.sh](build.sh) the Docker image can be build
from the [Dockerfile](Dockerfile) but this is not really necessary as
you may use your own ``docker build`` commandline.

### Build Options

The files under the  [config](config) dir are automatically integrated in the Docker image as follows:

- [config/tomcat/setenv.sh](config/tomcat/setenv.sh): Tomcat options like for memory, proxies etc
- [config/webapp/print-apps](config/webapp/print-apps): your own custom templates to be integrated in the MFP Demo app
- [config/webapp/WEB-INF/web.xml](config/webapp/WEB-INF/web.xml): override web.xml for Tomcat MFP .war
- [config/webapp/index.html](config/webapp/index.html): override index.html, the demo

## Running

The is a [run.sh](run.sh) script but you may use the Docker image in any context like
using Docker-compose etc.

## Credits

Kartoza team: https://github.com/kartoza for providing good examples of Dockerfiles for FOSS geospatial Java .war's.

TT Fonts addition: https://github.com/panosoft/docker-prince-server/blob/master/Dockerfile

