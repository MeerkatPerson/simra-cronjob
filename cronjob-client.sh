#!/bin/sh

cd /home/meerkat/SimRa

git clone git@github.com:simra-project/simra-project.github.io.git

cd simra-project.github.io

bash ../count-uploads.sh

mv ../rideData.json ./statsboard/rideData.json

mv ../profileData.json ./statsboard/profileData.json

git add ./statsboard/data.json

CURRDATE=`date +"%d-%b-%Y"`

git commit -m "update data file $CURRDATE"

git push

cd ..

yes | rm -r simra-project.github.io

 #¯\_(ツ)_/¯