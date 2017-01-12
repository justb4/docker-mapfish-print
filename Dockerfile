#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
# Inspired by and thanks to: https://github.com/kartoza/docker-geoserver/blob/master/Dockerfile

FROM tomcat:8-jre7

MAINTAINER Just van den Broecke<just@justobjects.nl>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl

RUN apt-get -y update

ARG IMAGE_TIMEZONE="Europe/Amsterdam"
# set time right adn configure timezone and locale
RUN echo "$IMAGE_TIMEZONE" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata

#-------------Application Specific Stuff ----------------------------------------------------


ENV MFP_VER "3.7-SNAPSHOT"
ENV MFP_SNAP_VER "3.7-20161005.141549-2"
ENV MFP_WAR https://oss.sonatype.org/content/repositories/snapshots/org/mapfish/print/print-servlet/$MFP_VER/print-servlet-$MFP_SNAP_VER.war

# Set JAVA_HOME to /usr/lib/jvm/default-java and link it to OpenJDK installation
RUN ln -s /usr/lib/jvm/java-7-openjdk-amd64 /usr/lib/jvm/default-java
ENV JAVA_HOME /usr/lib/jvm/default-java

#Add JAI and ImageIO for great speedy speed.
WORKDIR /tmp
RUN wget http://download.java.net/media/jai/builds/release/1_1_3/jai-1_1_3-lib-linux-amd64.tar.gz && \
    wget http://download.java.net/media/jai-imageio/builds/release/1.1/jai_imageio-1_1-lib-linux-amd64.tar.gz && \
    gunzip -c jai-1_1_3-lib-linux-amd64.tar.gz | tar xf - && \
    gunzip -c jai_imageio-1_1-lib-linux-amd64.tar.gz | tar xf - && \
    mv /tmp/jai-1_1_3/lib/*.jar $JAVA_HOME/jre/lib/ext/ && \
    mv /tmp/jai-1_1_3/lib/*.so $JAVA_HOME/jre/lib/amd64/ && \
    mv /tmp/jai_imageio-1_1/lib/*.jar $JAVA_HOME/jre/lib/ext/ && \
    mv /tmp/jai_imageio-1_1/lib/*.so $JAVA_HOME/jre/lib/amd64/ && \
    rm /tmp/jai-1_1_3-lib-linux-amd64.tar.gz && \
    rm -r /tmp/jai-1_1_3 && \
    rm /tmp/jai_imageio-1_1-lib-linux-amd64.tar.gz && \
    rm -r /tmp/jai_imageio-1_1

# Add MS Fonts
# Install fonts
# NOTE: must enable contrib apt repository for msttcorefonts
# NOTE: must remove bitmap-fonts.conf due to fontconfig bug
# See https://github.com/panosoft/docker-prince-server/blob/master/Dockerfile
RUN sed -i 's/$/ contrib/' /etc/apt/sources.list \
  && apt-get update && apt-get install --assume-yes \
    fontconfig \
    msttcorefonts \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* \
  && rm /etc/fonts/conf.d/10-scale-bitmap-fonts.conf

# Optionally keep Tomcat manager, docs, and examples, but best is to remove
ENV TC_DEPLOY_DIR $CATALINA_HOME/webapps
ENV TC_BIN_DIR $CATALINA_HOME/bin
ENV MFP_DEPLOY_DIR $TC_DEPLOY_DIR/ROOT

ARG TOMCAT_EXTRAS=false
RUN if [ "$TOMCAT_EXTRAS" = false ]; then \
    rm -rf $TC_DEPLOY_DIR/ROOT && \
    rm -rf $TC_DEPLOY_DIR/docs && \
    rm -rf $TC_DEPLOY_DIR/examples && \
    rm -rf $TC_DEPLOY_DIR/host-manager && \
    rm -rf $TC_DEPLOY_DIR/manager; \
  fi;

# Get the MFP .war
RUN wget $MFP_WAR -O /tmp/print.war

# Unzip in deploy dir e.g. /usr/local/tomcat8/webapps/print
RUN unzip /tmp/print.war -d $MFP_DEPLOY_DIR \
    && rm /tmp/print.war

# Eigen bestanden toevoegen
ADD config /tmp/config

# Copy configuration for Tomcat
RUN cp /tmp/config/tomcat/setenv.sh $TC_BIN_DIR

# Copy webapp config en eigen print-apps
RUN cp -rf /tmp/config/webapp/* $MFP_DEPLOY_DIR
