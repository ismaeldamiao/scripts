#!/data/data/com.termux/files/usr/bin/bash

# Por Ismael Damião
# Site: https://ismaeldamiao.github.io/
# E-mail: ismaellxd@gmail.com
# Última alteração: 20 de maio de 2020

# Use:
# wget -q https://github.com/ismaeldamiao/scripts/raw/master/termux_config.bash && bash termux_config.bash

clear
echo "Baixando arquivos pré-configurados"

if [ -a $PREFIX/etc/motd ]; then
   mv $PREFIX/etc/motd $PREFIX/etc/motd.bak
fi

if ! [ -x $PREFIX/bin/screenfetch ]; then
   wget -qO $PREFIX/bin/screenfetch https://git.io/vaHfR
   chmod 755 $PREFIX/bin/screenfetch
fi

if ! [ -a $HOME/.bashrc ]; then
   wget -qO $HOME/.bashrc \
   https://raw.githubusercontent.com/ismaeldamiao/scripts/master/.bashrc
fi

echo "Instalado pacotes legais"

apt update
apt upgrade --with-new-pkgs --install-suggests -y
apt install --install-suggests -y \
proot wget openssh nano htop coreutils gnuplot ncurses-utils

clear
echo "Escrevendo scripts e configurando ssh"

if [ -x $PREFIX/bin/update ]; then
   rm $PREFIX/bin/update
fi
cat > $PREFIX/bin/update <<- EOM
#!/data/data/com.termux/files/usr/bin/bash
apt update
apt autoremove --purge -y
apt install --install-suggests -yf
apt upgrade --with-new-pkgs --install-suggests -y
apt dist-upgrade --install-suggests -y
apt autoremove --purge -y
EOM
chmod 755 $PREFIX/bin/update

if [ -a $PREFIX/etc/ssh_config ]; then
   rm $PREFIX/etc/ssh/ssh_config
fi
echo "Host *" >> $PREFIX/etc/ssh/ssh_config
echo "   Port 22" >> $PREFIX/etc/ssh/ssh_config

if [ -a $PREFIX/etc/ssh/sshd_config ]; then
   rm $PREFIX/etc/ssh/sshd_config
fi
echo "Port 2225" >> $PREFIX/etc/ssh/sshd_config

echo " "
echo "Configure sua senha"
passwd

echo "Pronto!!"
