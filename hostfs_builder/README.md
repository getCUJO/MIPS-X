This guide is implemented in hostfs_builder.sh 

## This is a manual guide on how you can create your own hostfs for qemu use

# Step 1 - Download or build base hostfs
Create a hostfs with a tool like buildroot https://github.com/getCUJO/MIPS-X/blob/main/hostfs_builder/buildroot_notes.txt
or download a qcow2 from https://people.debian.org/~aurel32/qemu/

# Step 2 - Network config
Boot into the hostfs with qemu and copy from hostfs_builder directory etc/network/interfaces to hostfs in qemu /etc/network/interfaces
and run 
```service networking restart```

Check with ifconfig that eth0 has 192.168.100.2. This is important. If yes, test ping 192.168.100.1

# Step 3 - add authorized_keys 
Copy root/.ssh/authorized_keys to hostfs /root/.ssh/authorized_keys

```chmod 400 authorized_keys```

# Step 4 - create profile.d/armx.sh
Copy from etc/profile.d/armx.sh to hostfs /etc/profile.d/armx.sh
```chmod 700 /etc/profile.d/armx.sh```

# Step 5 - add NFS share to /etc/fstab
```
mkdir /armx
echo "\n192.168.100.1:/armx	/armx		nfs	intr,nolock,noauto	0	0\n" >> /etc/fstab
```

# Step 6 - periodic network check and restart
Copy from hostfs_builder root/test-eth0.sh and etc/crontabs/root 
```chmod 700 /root/test-eth0.sh```

# Step 7 -  Change SSH host key 
Copy from hostfs_builder etc/ssh/ssh_host_dsa_key and etc/ssh/ssh_host_rsa_key

# Step 8 - Automount NFS
Add add to /etc/rc.local before the exit 0 line 
```mount /armx```

# Step 9 -  copy gdbserver 9.1 static 
Download or compile a static gdbserver binary. This guide worked for me: https://wiki.muc.ccc.de/ctf:compile 
Copy the binary to /usr/sbin/gdbserver 
```chmod 700 /usr/sbin/gdbserver```

# Step 10 - optional: change /etc/issue
Add whatever into /etc/issue

# Step 11 - optional: network to add new packages
In order to use the menu from armx, or to add new packages from repo to the hostfs, I found the following way to have a network with proxy in the QEMU:
1. Start a network proxy on your host. Use Burp Suite, or something like https://github.com/inaz2/SimpleHTTPProxy
2. Start socat for DNS forwarding
```sudo socat UDP4-RECVFROM:53,fork UDP4-SENDTO:8.8.8.8:53```
3. Change the nameserver in /etc/resolv.conf to 192.168.100.1 
4. In case you are using a debian qcow2 configure apt to use proxy
```echo 'Acquire::http::Proxy "http://192.168.100.1:8080/";' > /etc/apt/apt.conf.d/proxy.conf```
5. In case you are using a debian qcow2 change the apt repositories. Replace everything http://ftp. and http://security. to http://archive.
6. apt-get should work
```
apt-get --allow-unauthenticated update
apt-get --allow-unauthenticated install dialog mc
```

# Step 11 - make it compliant with latest ARM-X
Change the SSHD port from 22 to 22222 in /etc/sshd_config
The restart with 
```
service ssh restart
```


