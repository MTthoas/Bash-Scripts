#!/bin/bash
sum=0
unset a1 a2 a3

file=()
unset a1 a2 a3

function push {
    local arr_name=$1
    shift
    if [[ $(declare -p "$arr_name" 2>&1) != "declare -a "* ]]
    then
        declare -g -a "$arr_name"
    fi
    declare -n array=$arr_name
    array+=($@)
}

# get all users
getent passwd | while IFS=: read -r name password uid gid gecos home shell; do


    # only users that own their home directory
    if [ -d "$home" ] && [ "$(stat -c %u "$home")" = "$uid" ]; then

        # only users that have a shell, and a shell is not equal to /bin/false or /usr/sbin/nologin
        if [ ! -z "$shell" ] && [ "$shell" != "/bin/false" ] && [ "$shell" != "/usr/sbin/nologin" ]; then
            #echo "$name's home directory is $home using shell $shell"
            #result=$(du -s -B1 /home/$name/)
            result=$(du -csh /home/$name/)

            text=$result

            # Set space as the delimiter
            IFS='/'

            # Read the split words into an array
            # based on space delimiter
            read -ra newarr <<< "$text"

            string=$newarr
            if [[ "$name" != "root" ]]; then
              echo "$name : $string "
              #array[oui]="text"
              push "${file%%.*}" "$name"
              #declare -A $array([oui]='non')
              #echo "$name"
              #sum=$(($sum + $string))
              #echo "somme : $sum"
            fi
        fi
    fi
done

#array[fruit]='mango'
#echo ${array[fruit]}
#for i in "${!array[@]}"
#do
  #echo "key  : $i"
  #echo "value: ${array[$i]}"
#done

for key in "${!file[@]}"; do echo $key; done
 echo "${!file[@]}"

#for key in "${!array[@]}"; do
  #echo "$key => ${array[$key]}";
#done
#echo "Taille total en bytes : $sum"
