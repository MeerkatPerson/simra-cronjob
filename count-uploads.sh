#!/bin/bash

# Create an array containing all relevant regions
declare -a regions
regions=("Augsburg" "Berlin" "Bern" "Bielefeld" "Düsseldorf" "Eichwalde" "Hannover" "Leipzig" "München" "Pforzheim" "Ruhrgebiet" "Stuttgart" "Wuppertal")
regLen=${#regions[@]}

# Loop through the array
for k in "${!regions[@]}"; do 

  cd /home/meerkat/SimRa/SimRa/${regions[$k]}/Rides

  firstFileRides=`ls VM* -r --sort=time | head -n 1`
  lastFileRides=`ls VM*  -r --sort=time | tail -n 1`
  currDateRides=`date -r $firstFileRides "+%Y-%m-%d"`
  endDateRides=`date -r $lastFileRides "+%Y-%m-%d"`

  rideArr=();

  while [ "$currDateRides" != $(date -I -d "$endDateRides + 1 day") ]; do 
    nRides=$(date -I -d "$currDateRides + 1 day")
    countRides=$(find . -type f -newermt $currDateRides ! -newermt $nRides | wc -l)
    rideArr=("${rideArr[@]}" $currDateRides $countRides)
    currDateRides=$nRides
    # echo $currDate
  done
    varsRides=(${rideArr[@]})
    lenRides=${#rideArr[@]}

  # **********************************************************
  # (2) Aggregate profile data for region 

  cd /home/meerkat/SimRa/SimRa/${regions[$k]}/Profiles

  firstFileProfiles=`ls VM* -r --sort=time | head -n 1`
  lastFileProfiles=`ls VM*  -r --sort=time | tail -n 1`
  currDateProfiles=`date -r $firstFileProfiles "+%Y-%m-%d"`
  endDateProfiles=`date -r $lastFileProfiles "+%Y-%m-%d"`

  profileArr=();

  while [ "$currDateProfiles" != $(date -I -d "$endDateProfiles + 1 day") ]; do 
    nProfiles=$(date -I -d "$currDateProfiles + 1 day")
    countProfiles=$(find . -type f -newermt $currDateProfiles ! -newermt $nProfiles | wc -l)
    profileArr=("${profileArr[@]}" $currDateProfiles $countProfiles)
    currDateProfiles=$nProfiles
    # echo $currDate
  done
    varsProfiles=(${profileArr[@]})
    lenProfiles=${#profileArr[@]}

  # **********************************************************
  # (3) Write to file

  cd /home/meerkat/SimRa

  # a) write rideData

  if [ $k -eq 0 ] ; then
    printf "{\n \"${regions[$k]}\": [\n" > rideData.json
  else
    printf "\n \"${regions[$k]}\": [\n" >> rideData.json
  fi

  for (( i=0; i<lenRides; i+=2 ))
  do
      printf "    { \"Date\": \"${varsRides[i]}\",\n" >> rideData.json
      printf "      \"Files\": ${varsRides[i+1]} }" >> rideData.json
      if [ $i -lt $((lenRides-2)) ] ; then
          printf ",\n" >> rideData.json
      fi
  done

  if [ $k -eq $((regLen - 1)) ] ; then
    printf "\n ] \n }" >> rideData.json
  else 
    printf "\n ]," >> rideData.json
  fi

  # b) write rideData

  if [ $k -eq 0 ] ; then
    printf "{\n \"${regions[$k]}\": [\n" > profileData.json
  else
    printf "\n \"${regions[$k]}\": [\n" >> profileData.json
  fi

  for (( i=0; i<lenProfiles; i+=2 ))
  do
      printf "    { \"Date\": \"${varsProfiles[i]}\",\n" >> profileData.json
      printf "      \"Files\": ${varsProfiles[i+1]} }" >> profileData.json
      if [ $i -lt $((lenProfiles-2)) ] ; then
          printf ",\n" >> profileData.json
      fi
  done

  if [ $k -eq $((regLen - 1)) ] ; then
    printf "\n ] \n }" >> profileData.json
  else 
    printf "\n ]," >> profileData.json
  fi

done

