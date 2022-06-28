#!/bin/bash

index=0

command=$(sudo find /usr -type f \( -perm -4000 -o -perm -2000 \) -exec ls {} \;)

if [ $(id -u) -ne 0 ]; then
        echo "Only root may add a user to the system."
        exit 2
else


if [ -e listUG.txt ]
then

    for i in ${command[@]}; do

      if grep -q ${i} listUG.txt 
      then
        index=1;
        echo "SAME HISTORY FOR $i /==/ DateTime : $(date -r $i)"
      fi

    done

    if [ $index -eq 0 ]
    then
      echo "Aucune ligne correspondante"
    fi

  else
      echo "Created listUG.txt"
      touch listUG
      echo "$(sudo find /usr -type f \( -perm -4000 -o -perm -2000 \) -exec ls {} \;)" >> listUG.txt
  fi

fi