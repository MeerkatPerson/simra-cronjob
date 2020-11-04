#!/bin/bash

# Create an array containing all relevant regions
declare -a regions
regions=("Augsburg" "Berlin" "Bern" "Bielefeld" "Düsseldorf" "Eichwalde" "Hannover" "Leipzig" "München" "Pforzheim" "Ruhrgebiet" "Stuttgart" "Wuppertal")

# Declare array containing all months (extend as necessary)
declare -a months
months=("Apr-2019" "May-2019" "Jun-2019" "Jul-2019" "Aug-2019" "Sept-2019" "Oct-2019" "Nov-2019" "Dec-2019" "Jan-2020" "Feb-2020" "Mar-2020" "Apr-2020" "May-2020" "Jun-2020" "Jul-2020" "Aug-2020" "Sept-2020" "Oct-2020")

FILE=/home/askarakaya/SimRa/SimRa/total_count.json

printf "{\n " > FILE

# Loop through the array of months

for m in "${!months[@]}"; do 

    count=0

    for k in "${!regions[@]}"; do 

        cd /home/askarakaya/SimRa/SimRa/${regions[$k]}/Rides

        rideCount=$(find VM* -type f -newermt "01-${months[$m]} -1 sec" -and -not -newermt "01-${months[$m]} +1 month -1 sec" | wc -l)

        count=$((count + rideCount))

    done

    printf " \"${months[$m]}\": \"$count\" " > FILE

done

printf "\n }" >> FILE




