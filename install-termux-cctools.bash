#!/data/data/com.termux/files/usr/bin/bash

# Por Ismael Damião
# Site: https://ismaeldamiao.github.io/
# E-mail: ismaellxd@gmail.com
# Última alteração: 12 de agosto 2020

arch="$(dpkg --print-architecture)"
cctoolshttp="http://cctools.info/downloads/termux"

# Baixando arquivos

wget -q \
"${cctoolshttp}/${arch}/binutils-cctools_2.34_${arch}.deb"
if [ "$?" != "0" ]; then exit 1; fi

wget -q \
"${cctoolshttp}/${arch}/gcc-cctools_10.1.0_${arch}.deb"
if [ "$?" != "0" ]; then exit 1; fi

# verificar versão do sdk (__ANDROID_API__)
sdk="$(getprop ro.build.version.sdk)"
if [ "$sdk" < "12" ]; then sdk="9"; fi
if [ "$sdk" == "25" ]; then sdk="24"; fi
if [ "$sdk" > "26" ]; then sdk="26"; fi

wget -q \
"${cctoolshttp}/${arch}/ndk-sysroot-cctools-api-${sdk}-${arch}_1.0r15c_all.deb"
if [ "$?" != "0" ]; then exit 1; fi

# instalando clang
dpkg -i "binutils-cctools_2.34_${arch}.deb"
if [ "$?" != "0" ]; then exit 1; fi
dpkg -i "gcc-cctools_10.1.0_${arch}.deb"
if [ "$?" != "0" ]; then exit 1; fi
dpkg -i "ndk-sysroot-cctools-api-${sdk}-${arch}_1.0r15c_all.deb"
if [ "$?" != "0" ]; then exit 1; fi

echo "export PATH=/data/data/com.termux/files/cctools-toolchain/bin:\$PATH"\
>> $HOME/.bashrc

exit 0
