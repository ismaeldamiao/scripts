#!/data/data/com.termux/files/usr/bin/bash

# Por Ismael Damião
# Site: https://ismaeldamiao.github.io/
# E-mail: ismaellxd@gmail.com
# Última alteração: 20 de junho de 2020

# Use:
# wget -q https://github.com/ismaeldamiao/scripts/raw/master/termux_config.bash && bash termux_config.bash

clear
echo "Baixando arquivos pré-configurados"

if ! [ -x $PREFIX/bin/screenfetch ]; then
   wget -qO $PREFIX/bin/screenfetch https://git.io/vaHfR
   chmod 755 $PREFIX/bin/screenfetch
fi

if ! [ -a $HOME/.bashrc ]; then
   wget -qO $HOME/.bashrc \
   https://raw.githubusercontent.com/ismaeldamiao/scripts/master/.bashrc
fi

echo "Instalado pacotes uteis"

apt update
apt upgrade --with-new-pkgs -y
apt install -y \
proot wget openssh nano htop coreutils gnuplot ncurses-utils

clear
termux-setup-storage
echo "Escrevendo scripts e configurando ssh"

if ! [ -a $HOME/.termux/termux.properties ]; then
   
   cat > $HOME/.termux/termux.properties <<EOF
extra-keys = [ \
 ['ESC','|','/','HOME','UP','END','-','DEL'], \
 ['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','+','BKSP'] \
]

# Open a new terminal with ctrl + t (volume down + t)
shortcut.create-session = ctrl + t

# Go one session down with (for example) ctrl + 2
shortcut.next-session = ctrl + 2

# Go one session up with (for example) ctrl + 1
shortcut.previous-session = ctrl + 1

# Rename a session with (for example) ctrl + n
shortcut.rename-session = ctrl + n


# Ignore bell character (vibrate,beep,ignore)
bell-character=ignore

# Send the Escape key.
back-key=back
EOF
fi

termux-reload-settings

if [ -a $PREFIX/etc/ssh_config ]; then rm $PREFIX/etc/ssh/ssh_config; fi
echo "Host *" >> $PREFIX/etc/ssh/ssh_config
echo "   Port 22" >> $PREFIX/etc/ssh/ssh_config

if [ -a $PREFIX/etc/ssh/sshd_config ]; then rm $PREFIX/etc/ssh/sshd_config; fi
echo "Port 2225" >> $PREFIX/etc/ssh/sshd_config

if [ -a $PREFIX/etc/motd ]; then mv $PREFIX/etc/motd $PREFIX/etc/motd.bak; fi

echo " "
echo "Configure sua senha"
passwd

echo "Pronto!!"
