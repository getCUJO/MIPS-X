#!/bin/sh
status=`/sbin/ifconfig eth0 | grep '192.168.100.2'`
address=`/sbin/ifconfig eth0 | grep 'UP'`
if [ "$status" = "" ] || [ "$address" = "" ]
then
   echo "`date`: eth0 down, bringing it up again" >> /tmp/eth0.log
   echo "`date`: eth0 down, bringing it up again" > /dev/console
   /sbin/ifconfig eth0 up
   /sbin/ifconfig eth0 192.168.100.2 netmask 255.255.255.0 up
fi
