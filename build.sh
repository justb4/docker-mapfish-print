#!/bin/bash
#
# Build MapFish Print3 Docker image with options

sudo docker build --build-arg IMAGE_TIMEZONE="Europe/Amsterdam" --build-arg TOMCAT_EXTRAS=false  --build-arg MFPRINT_APPS=false -t kadaster/print:3.7 .
