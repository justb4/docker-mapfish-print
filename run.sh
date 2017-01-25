#!/bin/bash
#
# Run MapFish Print3 Docker image with options

NAME="print"
IMAGE="kadaster/print:3.7"

LOG="/var/log/"
TC_LOG="${LOG}/tomcat-print"

# Define the mappings for local dirs, ports for container
VOL_MAP_LOGS="-v ${TC_LOG}:/usr/local/tomcat/logs"
VOL_MAP="${VOL_MAP_LOGS}"

# If we need to expose 8080 from host, but we use Apache AJP
# PORT_MAP="-p 8080:8080"
PORT_MAP="-p 8080:8080"

# Stop and remove possibly old containers
sudo docker stop ${NAME} > /dev/null 2>&1
sudo docker rm ${NAME} > /dev/null 2>&1

# Finally run
sudo docker run --name ${NAME} ${PORT_MAP} ${VOL_MAP} -d -t ${IMAGE}


# When running: get into container with bash
# sudo docker exec -it print  bash

