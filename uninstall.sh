#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "[*] This script must be run as root"
   exit 1
fi

rmmod acer-control
modprobe acer_wmi