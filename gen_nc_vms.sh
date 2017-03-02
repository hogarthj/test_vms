#!/usr/bin/env bash

if [[ "$1" != "" ]]
then
    dist=$1
else
    dist="f25"
fi

for web in httpd nginx
  do
    for db in mysql postgres
      do
        vmclone ${dist}-nc-${web}-${db}
        if [[ ${dist} =~ f[[:digit:]]|raw ]]
        then
            vmrole ${dist}-nc-${web}-${db} fedora nextcloud ${web} ${db}
        else
            vmrole ${dist}-nc-${web}-${db} nextcloud ${web} ${db}
        fi
        virsh start ${dist}-nc-${web}-${db}
    done
done
