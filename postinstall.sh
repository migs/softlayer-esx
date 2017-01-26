#!/bin/sh

# Rename local data store
vim-cmd hostsvc/datastore/rename datastore1 "$(hostname -s)-local"

# Enable vMotion
vim-cmd hostsvc/vmotion/vnic_set vmk0

# Softlayer requires changing the vSAN broadcast domain
esxcli vsan network ipv4 set -i vmk0 -d 224.0.0.220 -u 224.0.0.221

# Create a backup of install related log files
cp /var/log/hostd.log  "/vmfs/volumes/$(hostname -s)-local/logs/firstboot-hostd.log"
cp /var/log/esxi_install.log "/vmfs/volumes/$(hostname -s)-local/logs/firstboot-esxi_install.log"
