#!/bin/bash

for i in $( cat users.txt ); do

if [ $(id -u) -ne 0 ]; then
    echo "Only root may add a user to the system."
    exit 2
else
    IFS=':'
    read -ra ARR <<< "$i"

    for (( n=0; n < ${#ARR[*]}; n++ ))  
    do  
    if [[ $n = 1 ]]; then

    len=${#ARR[@]}
    nom="${ARR[1]}"
    prenom="${ARR[2]}"

        egrep "^$ARR[1]" /etc/passwd >/dev/null
        if [ $? -eq 0 ]; then
            echo "$ARR[1]exists!"
            exit 15
        else

            min=2;
            max=$(($len-2))

            between=$(($max-$min))

            for (( n=0; n < $between; n++ ))  
            do  

            echo "test"

            done 

            [ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
        fi
    fi
    done  
fi
done