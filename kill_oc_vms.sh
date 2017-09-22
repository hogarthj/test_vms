#!/usr/bin/env bash

if [[ "$1" != "" ]]
then
    dist=$1
else
    dist="f27"
fi

vmpat="${dist}-oc-"

virsh list --all | awk -v vmpat=${vmpat} '$2 ~ vmpat {print $2}'| while read line; do vmkill $line ; done
