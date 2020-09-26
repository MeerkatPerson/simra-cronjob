#!/bin/bash

firstFile=`ls VM* -r --sort=time | head -n 1`
lastFile=`ls VM*  -r --sort=time | tail -n 1`
currDate=`date -r $firstFile "+%Y-%m-%d"`
endDate=`date -r $lastFile "+%Y-%m-%d"`

arr=();

while [ "$currDate" != $(date -I -d "$endDate + 1 day") ]; do 
  n=$(date -I -d "$currDate + 1 day")
  count=$(find . -type f -newermt $currDate ! -newermt $n | wc -l)
  arr=("${arr[@]}" $currDate $count)
  currDate=$n
  # echo $currDate
done
  vars=(${arr[@]})
  len=${#arr[@]}

printf "{\n \"jsonarray\": [\n" > data.json
for (( i=0; i<len; i+=2 ))
do
    printf "    { \"Date\": \"${vars[i]}\",\n" >> data.json
    printf "      \"Files\": ${vars[i+1]} }" >> data.json
    if [ $i -lt $((len-2)) ] ; then
        printf ",\n" >> data.json
    fi
done
printf "\n ] \n }" >> data.json

