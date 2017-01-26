#!/bin/sh

# Softlayer requires changing the vSAN broadcast domain
esxcli vsan network ipv4 set -i vmk0 -d 224.0.0.220 -u 224.0.0.221

# Rename local data store
vim-cmd hostsvc/datastore/rename datastore1 "$(hostname -s)-local"
