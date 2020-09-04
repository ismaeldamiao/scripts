#!/data/data/com.termux/files/usr/bin/bash

# Por Ismael Damião
# Site: https://ismaeldamiao.github.io/
# E-mail: ismaellxd@gmail.com
# Última alteração: 4 de setembro de 2020

# Baixando arquivos

if ! wget -O - https://cctools.info/public.key | apt-key add -; then
   echo ""
   echo "Precisas instalar o pacote gnupg"
   echo "apt install -y gnupg"
   exit 1
fi

echo "deb https://cctools.info termux cctools" > $PREFIX/etc/apt/sources.list.d/cctools.list
apt update
apt install -y gcc-cctools

# verificar versão do sdk (__ANDROID_API__)
arch="$(dpkg --print-architecture)"
sdk="$(getprop ro.build.version.sdk)"

if [ "$sdk" < "12" ]; then sdk="9"; fi
if [ "$sdk" == "25" ]; then sdk="24"; fi
if [ "$sdk" > "26" ]; then sdk="26"; fi

apt install ndk-sysroot-cctools-api-${sdk}-${arch}

echo "export \$PREFIX/../cctools-toolchain/bin:\$PATH"\
>> $HOME/.bashrc

export PATH=$PREFIX/../cctools-toolchain/bin:$PATH

exit 0
