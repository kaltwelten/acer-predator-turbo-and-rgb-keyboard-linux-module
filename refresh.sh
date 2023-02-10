#!/bin/bash
rmmod acer-control
make
insmod src/acer_control.ko
dmesg | tail -n 30
