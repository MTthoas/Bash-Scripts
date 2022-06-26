#!/bin/bash
sum=0
echo "somme : $sum"
# get all users
getent passwd | while IFS=: read -r name password uid gid gecos home shell; do

    # only users that own their home directory
    if [ -d "$home" ] && [ "$(stat -c %u "$home")" = "$uid" ]; then

        # only users that have a shell, and a shell is not equal to /bin/false or /usr/sbin/nologin
        if [ ! -z "$shell" ] && [ "$shell" != "/bin/false" ] && [ "$shell" != "/usr/sbin/nologin" ]; then
            #echo "$name's home directory is $home using shell $shell"
            result=$(du -s -B1 /home/$name/)

            text=$result

            # Set space as the delimiter
            IFS='/'

            # Read the split words into an array
            # based on space delimiter
            read -ra newarr <<< "$text"

            string=$newarr
            if [[ "$name" != "root" ]]; then
              #echo "$name : $string "

              sum=$(($sum + $string))
              #echo "somme : $sum"
            fi
        fi
    fi
done

echo "Taille total en bytes : $sum"
