#!/bin/bash
#
# ARM-X Device Launcher
# 
export ARMX=$(cat /proc/cmdline | sed 's/.*ARMX=\([A-Za-z0-9]*\)/\1/g')
export ARMXDESC=$(cat /armx/devices | grep $ARMX | sed 's/.*,\([^,]*\)$/\1/')
export ROOTFS="/armx/${ARMX}/$(cat /armx/${ARMX}/config | grep rootfs | cut -d'=' -f2)"

# Need to set xterm-color else dialog doesn't like it
export TERM=xterm-color

# check if ARM-X device is already started
fundialog=${fundialog=dialog}

x=`$fundialog --stdout --clear --no-cancel \
   --backtitle "ARM-X - The Versatile ARM IoT Device Emulator" \
   --menu "$ARMX Launcher" 0 0 0 \
   0 "ARM-X HOSTFS shell (default)" \
   1 "Start $ARMXDESC" \
   2 "Enter $ARMXDESC CONSOLE (exec /bin/sh)"`

clear
if [ $x -eq 1 ]
then
   if [ -r /tmp/armxstarted ]
   then
      echo "** $ARMXDESC already started."
      echo "If you really know what you are doing,"
      echo "then rm -f /tmp/armxstarted"
      echo "and try this option again."
      echo "You have been warned!"
   else
      echo "Starting $ARMXDESC"
      cd /armx/$ARMX/
      ./run-init
      exit
   fi
fi

if [ $x -eq 2 ]
then
   echo "Entering $ARMXDESC CONSOLE (/bin/sh)"
   cd /armx/$ARMX/
   ./run-binsh
  exit
fi

export PS1="ARM-X HOSTFS [$ARMX]:\w> "

