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
          if [[ ${dist} =~ f([[:digit:]]|raw) ]] 
        then
            groups="\"fedora\", \"owncloud\", \"${web}\", \"${db}\""
        else
            groups="\"owncloud\", \"${web}\", \"${db}\""
        fi
        vmclone ${dist}-oc-${web}-${db}
        virsh desc ${dist}-oc-${web}-${db} "{\"groups\": [${groups}]}"
        virsh start ${dist}-oc-${web}-${db}
    done
done 
