#!/bin/sh

# Softlayer requires changing the vSAN broadcast domain
esxcli vsan network ipv4 set -i vmk0 -d 224.0.0.220 -u 224.0.0.221
