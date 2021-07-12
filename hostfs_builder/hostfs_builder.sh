#!/bin/ash


# Step 2 - Network config
echo -ne '# Configure Loopback\nauto lo\niface lo inet loopback\nauto enp0s11\n\tiface enp0s11 inet static\n\taddress 192.168.100.2\n\tnetmask 255.255.255.0\n\tgateway 192.168.100.1' > /etc/network/interfaces
/etc/init.d/S40network restart

# Step 3 - add authorized_keys 
mkdir /root/.ssh
chmod 700 /root/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAxMFkam6dnJH06jE+LdDfbvb1+8ChITqXS0xIqtG5XVhGivJgnf+RTg1Eu8QcuvgBDCxR1/HSM8rTP7L1J0M+7mwx/+c0fi34ZvTs3mAsNcqM3oNsz27URsgfRMAvZT0Eo9h9LScXtcCluBTz6B1oY23nCXLLg63X8+DnrP3Z5pTX9gDM8qUZHFWQxHQIbJTKeHjqCDf6u3vhPyJVsRzzkq74KMKy2Va8nQcfoT3OVkdthugHdeYB0QxObTRXq0sgTtXv+HUJ7dJ2IGIaFbEIo/hxmGinh51VYlXcK9/YVBpVqO7Y+DdM62pvR5ltZtM6YBJYNsL72vKHMttj6n0u1w== krafty@kraftyness
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDaUuP1BN5TyoYUmUl0GHe/MUt3X4aFLRcA/RTAa52P19scqWK4Ev9SOEfvE+Jy2c/bqxENd4REj3DK7xO9jLWMN1AgAF2pI3XMbncEZ9XexBRQlpvrYiDbq8r/Jy3fq4vL79MJjBvLMEBA+Fv3uSuzaLAAvgBj2uMGNogsELx41jJEU4ZhaNKR5swTFfORlFAUWKDY8+X3YeU9MN+5hY71HrjiwtmnGyVTuG1efieRVvUE2IOw2fmLRQwErFyAwaaQ+EmzNdgSjG5QOG1y7WyxbmgxDUAHwAR408wtBVXihunFYhaF5PPqY2POKflHizQ4310eCQ57humSm4jjS51R armx@armx" > /root/.ssh/authorized_keys
chmod 400 /root/.ssh/authorized_keys


# Step 4 - create profile.d/armx.sh

cat > /etc/profile.d/armx.sh << EOF
#!/bin/bash
#
# ARM-X Device Launcher
# 
export ARMX=\$(cat /proc/cmdline | sed 's/.*ARMX=\([A-Za-z0-9]*\)/\1/g')
export ARMXDESC=\$(cat /armx/devices | grep \$ARMX | sed 's/.*,\([^,]*\)\$/\1/')
export ROOTFS="/armx/\${ARMX}/\$(cat /armx/\${ARMX}/config | grep rootfs | cut -d'=' -f2)"

# Need to set xterm-color else dialog doesn't like it
export TERM=xterm-color

# check if ARM-X device is already started
fundialog=\${fundialog=dialog}

x=\`\$fundialog --stdout --clear --no-cancel \\
   --backtitle "ARM-X - The Versatile ARM IoT Device Emulator" \\
   --menu "\$ARMX Launcher" 0 0 0 \\
   0 "ARM-X HOSTFS shell (default)" \\
   1 "Start \$ARMXDESC" \\
   2 "Enter \$ARMXDESC CONSOLE (exec /bin/sh)"\`

clear
if [ \$x -eq 1 ]
then
   if [ -r /tmp/armxstarted ]
   then
      echo "** \$ARMXDESC already started."
      echo "If you really know what you are doing,"
      echo "then rm -f /tmp/armxstarted"
      echo "and try this option again."
      echo "You have been warned!"
   else
      echo "Starting \$ARMXDESC"
      cd /armx/\$ARMX/
      ./run-init
      exit
   fi
fi

if [ \$x -eq 2 ]
then
   echo "Entering \$ARMXDESC CONSOLE (/bin/sh)"
   cd /armx/\$ARMX/
   ./run-binsh
  exit
fi

export PS1="ARM-X HOSTFS [\$ARMX]:\w> "
EOF


chmod 700 /etc/profile.d/armx.sh


# Step 5 - add NFS share to /etc/fstab
mkdir /armx
echo -ne '\n192.168.100.1:/armx\t/armx\tnfs\tintr,nolock,noauto\t0\t0\n' >> /etc/fstab

# Step 6 - periodic network check and restart

cat > /root/test-eth0.sh << EOF
#!/bin/sh
status=`/sbin/ifconfig enp0s11 | grep '192.168.100.2'`
address=`/sbin/ifconfig enp0s11 | grep 'UP'`
if [ "\$status" = "" ] || [ "\$address" = "" ]
then
   echo "`date`: enp0s11 down, bringing it up again" >> /tmp/enp0s11.log
   echo "`date`: enp0s11 down, bringing it up again" > /dev/console
   /sbin/ifconfig enp0s11 up
   /sbin/ifconfig enp0s11 192.168.100.2 netmask 255.255.255.0 up
fi
EOF
chmod 700 /root/test-eth0.sh

mkdir /etc/crontabs
cat > /etc/crontabs/root << EOF
* * * * * /root/test-eth0.sh >/dev/null 2>&1
* * * * * sleep 10; /root/test-eth0.sh >/dev/null 2>&1
* * * * * sleep 20; /root/test-eth0.sh >/dev/null 2>&1
* * * * * sleep 30; /root/test-eth0.sh >/dev/null 2>&1
* * * * * sleep 40; /root/test-eth0.sh >/dev/null 2>&1
* * * * * sleep 50; /root/test-eth0.sh >/dev/null 2>&1
EOF

#Step 8
mount /armx

# Step 9 -  copy gdbserver 9.1 static 
#TODO Copy the binary to /usr/sbin/gdbserver 
chmod 700 /usr/sbin/gdbserver

# Step 10 - optional: change /etc/issue
echo "Welcome to MIPS-X v0.0" > /etc/issue

#Step 11
cat > /etc/init.d/S60armx << EOF
#!/bin/sh
#
# Starts ARM-X
#

start() {
 	echo -n "Starting ARM-X "
	mount /armx
	echo "OK"
}
stop() {
	echo -n "Stopping ARM-X "
	rm -f /tmp/armxstarted
	umount -fl /armx
	/sbin/halt
}

case "\$1" in
  start)
  	start
	;;
  stop)
  	stop
	;;
  *)
	echo "Usage: \$0 {start|stop}"
	exit 1
esac

exit \$?
EOF
chmod 755 /etc/init.d/S60armx

#Step 12
sed -i "s/#Port 22/Port 22222/" /etc/ssh/sshd_config
service ssh restart

echo 'DROPBEAR_ARGS="-p 22222"' > /etc/default/dropbear
