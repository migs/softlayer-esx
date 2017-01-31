#!/bin/sh

# Rename local data store
vim-cmd hostsvc/datastore/rename datastore1 "$(hostname -s)-local"

# Enable vMotion on vmk0
vim-cmd hostsvc/vmotion/vnic_set vmk0

# Enable vSAN on vmk0
# Softlayer requires a specific broadcast domain for the vSAN interface
esxcli vsan network ipv4 add -i vmk0 -d 224.0.0.220 -u 224.0.0.221

# Create a backup of install related log files
mkdir "/vmfs/volumes/$(hostname -s)-local/firstboot-logs/"
cp /var/log/hostd.log  "/vmfs/volumes/$(hostname -s)-local/firstboot-logs/firstboot-hostd.log"
cp /var/log/esxi_install.log "/vmfs/volumes/$(hostname -s)-local/firstboot-logs/firstboot-esxi_install.log"

# Install StorCLI
#esxcli software vib install -v https://raw.githubusercontent.com/migs/softlayer-esx/master/binaries/vmware-esx-storcli-1.21.06.vib

# Nuke current RAID settings, and put the proper ones in place:
#/opt/lsi/storcli/storcli /c0/v1 del
#/opt/lsi/storcli/storcli /c0/v2 del
#/opt/lsi/storcli/storcli /c0/v3 del
#/opt/lsi/storcli/storcli /c0/v4 del
#/opt/lsi/storcli/storcli /c0/v5 del
#/opt/lsi/storcli/storcli /c0 add vd type=raid0 name=VSAN-SSD drive=8:2 nora wt direct strip=256
#/opt/lsi/storcli/storcli /c0 add vd type=raid0 name=VSAN drive=8:3 ra wt direct strip=256
#/opt/lsi/storcli/storcli /c0 add vd type=raid0 name=VSAN drive=8:4 ra wt direct strip=256
#/opt/lsi/storcli/storcli /c0 add vd type=raid0 name=VSAN drive=8:5 ra wt direct strip=256
#/opt/lsi/storcli/storcli /c0 add vd type=raid0 name=VSAN drive=8:6 ra wt direct strip=256

# Force the SSD to be correctly marked as an SSD
# This will error if the disks have not been re-initialised from a previous install. The error can be ignored.
# esxcli storage nmp satp rule add -s VMW_SATP_LOCAL -d `esxcli storage core path list -p vmhba3:C2:T1:L0 | grep Device: | awk '{print $2}'` -o enable_ssd
