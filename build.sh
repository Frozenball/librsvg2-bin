#!/bin/bash
set -e
dockerID=$(docker create $(docker build -q .))
docker cp $dockerID:/target .
filename=$((cd target && ls) | sed -E 's/.deb/_without_gtk.deb/g')
cp target/*.deb $filename
docker rm $dockerID
rm -rf target
echo Build $filename
