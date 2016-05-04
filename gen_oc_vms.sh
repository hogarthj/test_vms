#!/usr/bin/env bash

for web in httpd nginx
  do 
    for db in mysql postgres
      do 
        vmclone f24-oc-${web}-${db}
        virsh desc f24-oc-${web}-${db} "{\"groups\": [\"fedora\", \"owncloud\", \"${web}\", \"${db}\"]}"
        virsh start f24-oc-${web}-${db}
    done
done 
