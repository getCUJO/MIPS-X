# MIPS-X Firmware Emulation Framework, on top of ARM-X

Steps to start:
1. ARM-X install instructions are here: docs/install-armx-kali.md

For MIPS-X
1. join the EMINENT/debian_squeeze_mipsel_standard.qcow2.tar.gz.aa - ad files, and untar it
2. untar EMINENT/rootfs.tar.gz as root! into EMINENT/rootfs
3. I had issues with the provided static qemu-system-mipsel-5.1.0 , but the qemu-system-mipsel installed on the system worked like a charm for me
4. run/launcher should work now
5. login as root/root


Notes:
Poor man's DNS server: sudo socat UDP4-RECVFROM:53,fork UDP4-SENDTO:192.168.123.1:53
