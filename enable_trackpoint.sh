#!/bin/sh

sudo sh -c "echo -n none > /sys/devices/platform/i8042/serio1/drvctl"
sudo sh -c "echo -n reconnect > /sys/devices/platform/i8042/serio1/drvctl"
#sudo rmmod psmouse
sudo modprobe psmouse
sleep 3
synclient TapButton1=0 TapButton2=0 TapButton3=0
#synclient TapButton2=0
#synclient TapButton3=0
