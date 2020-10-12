# ~/.bashrc: executed by bash for non-login shells.
# Por Ismael Damião
# Blog: http://ismaeldamiao.blogspot.com/
# E-mail: ismaellxd@gmail.com
# Última alteração: 12 de outubro de 2020

# ******************************************************************************
# Comando para Distros Linux e Termux
# ******************************************************************************

HISTCONTROL=ignoreboth # Para ignorar comandos duplicados
HISTSIZE=1000 # Quantidades de comandos que serão lembrados
HISTFILESIZE=2000
shopt -s histappend

# ******************
# aliases
# ******************
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -s'
alias clear='clear && clear'
alias ps='ps arxu'
alias cp='cp -R' # ↓ aliases recursivos
alias rm='rm -R' # Cuidado, perigoso!!
alias mkdir='mkdir -p'
alias scp='scp -rp'
#alias myip='curl ipinfo.io/ip'

# ******************
# Paleta de cores
# ******************
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)

if [ "$PREFIX" == "/data/data/com.termux/files/usr" ]; then
   # ***************************************************************************
   # Comando específicos do Termux
   # ***************************************************************************
   USER='user'
   HOSTNAME='$(getprop ro.product.model)'
   PS1FINAL='\n\$ '
   # Facilitar acesso ao diretório do ubuntu
   UBUNTU=$HOME/ubuntu/ubuntu-fs/root
   # aliases Termux
   alias termux-open='termux-open --chooser'
else
   # ***************************************************************************
   # Comando específicos de Distros Linux
   # ***************************************************************************

   # Execute o screenfetch ou, em caso dele não existir,
   # deixe-o fácil de instalar
   PS1FINAL='\$ '
   DRIVE=/media/felipe/drive
   # aliases distros
   alias sshd='sudo service ssh restart'
fi
# Mude aqui as cores ou outras coisas do PS1, se quiser
# Todos os bytes não imprimíveis devem estar entre \[ \]
if [ "$EUID" -ne 0 ]; then # Quando usuario comum
PS1=\
"\[$(tput bold)\]\
\[$GREEN\]$USER\
\[$WHITE\]@\
\[$GREEN\]$HOSTNAME\
\[$WHITE\]:\[$BLUE\]\w\[$WHITE\]$PS1FINAL\
\[$(tput sgr0)\]"
else # Quando usuario root
PS1=\
"\[$(tput bold)\]\
\[$RED\]$USER\
\[$WHITE\]@\
\[$RED\]$HOSTNAME\
\[$WHITE\]:\[$BLUE\]\w\[$WHITE\]$PS1FINAL\
\[$(tput sgr0)\]"
fi
