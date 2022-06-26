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

            for (( i=0; i < $between; i++ ))  
            do  

            # Attraper la 3ème ligne 1 fois
            if [[ $i -eq 0 ]]; then
                
                    if grep -q -E "^${ARR[3]}:" /etc/group
                        then
                            echo ${ARR[3]}
                            sudo useradd -N "${ARR[0]}" -c "${ARR[1]},${ARR[2]}"
                            sudo usermod -a -G "${ARR[3]}" "${ARR[0]}"
                        else
                            echo ${ARR[0]}
                            sudo groupadd "${ARR[3]}" 
                            sudo useradd -N "${ARR[0]}" -c "${ARR[1]},${ARR[2]}"
                            sudo usermod -a -G "${ARR[3]}" "${ARR[0]}"
                    fi

            else

            index=$((3+$i))
            echo ${ARR[$index]}

                if grep -q -E "^${ARR[$index]}:" /etc/group
                then
                    sudo usermod -a -G ${ARR[$index]} "${ARR[0]}"
                    chage -d 0 "${ARR[0]}"
                else
                    sudo groupadd "${ARR[$index]}"
                    sudo usermod -a -G ${ARR[$index]} "${ARR[0]}"
                    chage -d 0 "${ARR[0]}"


                    #for((y=0;y<10;y++))
                    #do

                        #head -c $RANDOM </home/${ARR[0]}> "$RANDOM.txt"

                        #done

                    echo "User has been added to system!"
                fi
               

            fi
            done 

        fi
    fi
    done  
fi
done