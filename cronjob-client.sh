#!/bin/sh

cd /home/meerkat/SimRa/SimRa/Berlin/Rides

git clone git@github.com:simra-project/simra-project.github.io.git

cd simra-project.github.io

mv ../data.json ./statsboard/data.json

git add ./statsboard/data.json

CURRDATE=`date +"%d-%b-%Y"`

git commit -m "update data file $CURRDATE"

git push

cd ..

yes | rm -r simra-project.github.io
