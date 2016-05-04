#!/usr/bin/env bash

virsh list --all | awk '$2 ~ /f24-oc-/ {print $2}'| while read line; do vmkill $line ; done
