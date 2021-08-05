# MIPS-X Firmware Emulation Framework, on top of ARM-X

Note: As ARM-X moved to Docker architecture, please also check the MIPS-X branch on https://github.com/therealsaumil/armx for the real deal. 

Steps to start:
1. ARM-X install instructions on Kali are here: docs/install-armx-kali.md

For MIPS-X
1. join the hostfs/debian_squeeze_mipsel_standard.qcow2.tar.gz.aa - ad files, and untar it
```
cat debian_squeeze_mips_standard.qcow2.tar.gz.* > debian_squeeze_mips_standard.qcow2.tar.gz
cat debian_squeeze_mipsel_standard.qcow2.tar.gz.* > debian_squeeze_mipsel_standard.qcow2.tar.gz

tar -zxvf debian_squeeze_mips_standard.qcow2.tar.gz
tar -zxvf debian_squeeze_mipsel_standard.qcow2.tar.gz
```

If you want to use your own hostfs - e.g. built by buildroot, check https://github.com/getCUJO/MIPS-X/tree/main/hostfs_builder 

3. run/launcher should work now
4. username is root, password is empty

Authors: Patrick Ross @VillageIDIOTLab, Zoltan Balazs @zh4ck
