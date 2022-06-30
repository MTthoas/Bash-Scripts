#! /bin/bash
# awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd

# Pour chaque utilisateur humain (non système)
array=()
for user in $(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd); do

    homedir=$(getent passwd "$user" | cut -d ":" -f 6)
    size=$(du -sb0 "$homedir" | awk '{print $1}')
    if [ "$size" -ge 999999999 ]; then
        formattedsize="$((size / (1024 * 1024 * 1024)))Go, $((size % (1024 * 1024 * 1024) / (1024 * 1024)))Mo, $((size % (1024 * 1024) / 1024))Ko et $((size % 1024))octets"
    elif [ "$size" -ge 999999 ]; then
        formattedsize="$((size % (1024 * 1024 * 1024) / (1024 * 1024)))Mo, $((size % (1024 * 1024) / 1024))Ko et $((size % 1024))octets"
    elif [ "$size" -ge 999 ]; then
        formattedsize="$((size % (1024 * 1024) / 1024))Ko et $((size % 1024))octets"
    else
        formattedsize="$size octets"
    fi
    array=("${array[@]}" "${size};${formattedsize};${user}")
done

printf "\n\n"

printf "\n\n"

new_array=("${array[1]}")

array_copy=("${array[@]}")

len=${#array_copy[*]}


sorted="false"
while [ $sorted == "false" ]; do
    sorted="true"
    for ((i = 1; i < ${len}; i = (($i + 2)))); do
        firstvalue=$(echo "${array_copy[$i]}" | cut -d";" -f1)
        secondvalue=$(echo "${array_copy[$i + 1]}" | cut -d";" -f1)
        if [ "$firstvalue" -lt "$secondvalue" ]; then
            tmp="${array_copy[$i]}"
            array_copy[$i]="${array_copy[$i + 1]}"
            array_copy[$i + 1]="$tmp"
            sorted="false"
        fi
    done

    for ((i = 0; i < ${len}; i = (($i + 2)))); do
        firstvalue=$(echo "${array_copy[$i]}" | cut -d";" -f1)
        secondvalue=$(echo "${array_copy[$i + 1]}" | cut -d";" -f1)
        if [ "$firstvalue" -lt "$secondvalue" ]; then
            tmp="${array_copy[$i]}"
            array_copy[$i]="${array_copy[$i + 1]}"
            array_copy[$i + 1]="$tmp"
            sorted="false"
        fi
    done

done
printf "\n\n"

# printf "Apres le tri pair/impair\n"

for ((i = 0; i < ${len}; i++)); do

    array_copy[i]=$(echo "${array_copy[i]}" | awk -F";" '{print $3" utilise "$2""}')
done
sudo touch /home/human_user_space.txt
sudo chmod 777 /home/human_user_space.txt
sudo printf "%s\n" "${array_copy[@]}" >/home/human_user_space.txt

#
