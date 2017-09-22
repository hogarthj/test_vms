#!/usr/bin/env bash

if [[ "$1" != "" ]]
then
    dist=$1
else
    dist="f27"
fi

for web in httpd nginx
  do
    for db in mysql postgres
      do
        vmclone ${dist}-oc-${web}-${db}
        if [[ ${dist} =~ f([[:digit:]]|raw) ]]
        then
            vmrole ${dist}-oc-${web}-${db} fedora owncloud ${web} ${db}
        else
            vmrole ${dist}-oc-${web}-${db} owncloud ${web} ${db}
        fi
        virsh start ${dist}-oc-${web}-${db}
    done
done
