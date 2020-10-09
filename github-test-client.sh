#!/bin/sh

git clone git@github.com:MeerkatPerson/bash-shenanigans.git

cd bash-shenanigans

printf "\n #¯\_(ツ)_/¯" >> cronjob-client.sh

git add ./cronjob-client.sh

CURRDATE=`date +"%d-%b-%Y"`

git commit -m "test github from EC2 $CURRDATE"

git push

cd ..

yes | rm -r bash-shenanigans
