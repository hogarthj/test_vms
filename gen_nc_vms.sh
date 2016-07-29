#!/usr/bin/env bash

if [[ "$1" != "" ]]
then
    dist=$1
else
    dist="f24"
fi

for web in httpd nginx
  do 
    for db in mysql postgres
      do 
        if [[ ${dist} =~ f[[:digit:]]|raw ]]
        then
            groups="\"fedora\", \"nextcloud\", \"${web}\", \"${db}\""
        else
            groups="\"nextcloud\", \"${web}\", \"${db}\""
        fi
        vmclone ${dist}-nc-${web}-${db}
        virsh desc ${dist}-nc-${web}-${db} "{\"groups\": [${groups}]}"
        virsh start ${dist}-nc-${web}-${db}
    done
done 
