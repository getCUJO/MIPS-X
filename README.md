# MIPS-X Firmware Emulation Framework, on top of ARM-X

Note: As ARM-X moved to Docker architecture, please also check the MIPS-X branch on https://github.com/therealsaumil/armx/tree/mipsx for the real deal. 

This repo is based on the old (pre June 2021) ARM-X.
This repo uses old Debian based large hostfs and intentionally old kernels. 
A smaller, buildroot based hostfs can be found in the MIPS-X branch. 

## MIPS-X quick start guide: 
1. join the hostfs/debian_squeeze_mipsel_standard.qcow2.tar.gz.aa - ad files, and untar it
```
cat debian_squeeze_mips_standard.qcow2.tar.gz.* > debian_squeeze_mips_standard.qcow2.tar.gz
cat debian_squeeze_mipsel_standard.qcow2.tar.gz.* > debian_squeeze_mipsel_standard.qcow2.tar.gz

tar -zxvf debian_squeeze_mips_standard.qcow2.tar.gz
tar -zxvf debian_squeeze_mipsel_standard.qcow2.tar.gz
```

If you want to use your own hostfs - e.g. built by buildroot, check https://github.com/getCUJO/MIPS-X/tree/main/hostfs_builder 

2. use /armx/run/launcher 
3. username is root, password is empty

Authors: Patrick Ross @VillageIDIOTLab, Zoltan Balazs @zh4ck
