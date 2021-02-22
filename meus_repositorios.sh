#!/bin/bash

# Testado no Ubuntu Minimal e no termux
# wget -q https://github.com/ismaeldamiao/scripts/raw/master/meus_repositorios.sh && bash meus_repositorios.sh
# Ultima alteracao em: 22 de fevereiro de 2021

FILE=meus_repositorios.list

if [ "${PREFIX}" == "/data/data/com.termux/files/usr" ]; then
   apt install -y gnupg ca-certificates wget root-repo x11-repo
   FILE=${PREFIX}/etc/apt/sources.list.d/${FILE}

   # ###
   # CC Tools
   # ###

   echo "# CC Tools" > ${FILE}
   wget -qO - https://cctools.info/public.key | apt-key add -
   echo "deb https://cctools.info termux cctools" > ${FILE}
   echo " "

else
   if [ "${EUID}" -ne 0 ]; then
      echo "Por favor execute como super usuario:"
      echo "sudo ${0}"
      exit 1
   fi

   apt -y install ca-certificates wget curl net-tools gnupg
   FILE=/etc/apt/sources.list.d/${FILE}
   cd /tmp

   # ###
   # Linux mint
   # ###

   echo "# Linux Mint" > ${FILE}
   echo "deb http://packages.linuxmint.com/ ulyssa main upstream import backport" > ${FILE}
   wget -q "http://packages.linuxmint.com/pool/main/l/linuxmint-keyring/linuxmint-keyring_2016.05.26_all.deb"
   dpkg -i linuxmint-keyring_2016.05.26_all.deb
   echo " "

   # ###
   # Openvpn
   # ###

   echo "# Openvpn" > ${FILE}
   wget -qO - https://as-repository.openvpn.net/as-repo-public.gpg | apt-key add -
   echo "deb http://as-repository.openvpn.net/as/debian buster main" > ${FILE}
   echo " "

   # ###
   # RetroArch
   # ###

   add-apt-repository ppa:libretro/stable

   # ###
   # Java Script
   # ###

   curl -fsSL https://deb.nodesource.com/setup_15.x | bash -

fi

apt update

exit 0
