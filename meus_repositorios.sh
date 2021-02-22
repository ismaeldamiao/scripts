#!/bin/bash

if [ "$EUID" -ne 0 ]; then
   echo "Por favor execute como super usuario:"
   echo "sudo ${0}"
   exit 1
fi

# ###
# Linux mint
# ###

echo "deb http://packages.linuxmint.com/ tricia main upstream import backport" >> /etc/apt/sources.list.d/mint.list
wget -q "http://packages.linuxmint.com/pool/main/l/linuxmint-keyring/linuxmint-keyring_2016.05.26_all.deb"
dpkg -i linuxmint-keyring_2016.05.26_all.deb
