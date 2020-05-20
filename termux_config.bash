#!/data/data/com.termux/files/usr/bin/bash

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

if ! [ -x $HOME/.bashrc ]; then
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
cat > $PREFIX/etc/ssh/ssh_config <<- EOM
Port 22
EOM

if [ -a $PREFIX/etc/ssh/sshd_config ]; then
   rm $PREFIX/etc/ssh/sshd_config
fi
cat > $PREFIX/etc/ssh/sshd_config <<- EOM
Port 2225
EOM

echo " "
echo "Configure sua senha"
passwd

echo "Pronto!!"
