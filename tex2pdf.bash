#!/bin/bash
# tex2pdf
# função: Executar os comandos latex, bibtex e makeindex de forma simplificada
# autor: Ricardo Brito do Nascimento britodfbr<at>incolume.com.br
#
#
#  Editado por: Ismael Felipe Ferreira dos Santos
#               Instituto de Fisica,
#               Universidade Federal de Alagoas
#  E-mail: ismaellxd@gmail.com
#  Mudificacoes: Gerar graficos com GNUPlot na saida LaTex de forma correta
#                e nome mais sugestivo
#  Ultima alteracao em 16/01/2021
#
#  Para facilitar:          sudo cp tex2pdf.bash /bin/tex2pdf && sudo chmod 755 /bin/tex2pdf
#  Para compilar um .tex:   tex2pdf <NomeDoArquivo.tex>

# ###
# Mensagem de ajuda
# ###

usage(){
cat << EOF
Script para compilar arquivos .tex escritos em LaTeX

Use $0 [arg]
arg:
    [-h] [help]               Ver esta menssagem
    [NomeArquivo.tex]         Para compilar
    [NomeArquivo.tex] [-v]    Para compilar e mostrar o stdout e o stderr
    [--update]                Para atualizar este script
EOF
}

# ###
# Atualizar script
# ###

update(){
   if [ "$PREFIX" == "/data/data/com.termux/files/usr" ]; then
      file=$PREFIX/bin/tex2pdf
   else
      file=$HOME/bin/tex2pdf
   fi
   wget -qO $file https://raw.githubusercontent.com/ismaeldamiao/scripts/master/tex2pdf.bash
   chmod 700 $file
}

# ###
# Funcao que compila o arquivo .tex
# ###

function tex(){
   pdflatex -shell-escape --interaction=nonstopmode ${1}.tex
   pdflatex -shell-escape --interaction=nonstopmode ${1}.tex

   bibtex ${1}
   pdflatex -shell-escape --interaction=nonstopmode ${1}.tex
   bibtex ${1}

   makeindex ${1}.glo -s ${NOME}.ist -t ${1}.glg -o ${1}.gls
   makeindex -s ${1}.ist -t ${NOME}.nlg -o ${1}.ntn ${1}.not

   pdflatex -shell-escape --interaction=nonstopmode ${1}.tex
   bibtex ${1}
   makeindex ${1}.glo -s ${1}.ist -t ${1}.glg -o ${1}.gls
   makeindex -s ${1}.ist -t ${1}.nlg -o ${1}.ntn ${1}.not

   pdflatex -shell-escape --interaction=nonstopmode ${1}.tex
   pdflatex -shell-escape --interaction=nonstopmode ${1}.tex
   pdflatex -shell-escape --interaction=nonstopmode ${1}.tex
}

# ###
# Verificar argumentos passados ao script
# ###

# Ajuda
for arg in "$@"; do
   # Menssagem de ajuda
   if [ "$arg" == "-h" ] || [ "$arg" == "help" ] || [ "$arg" == "--help" ]; then
      usage
      exit 0
   elif [[ "$arg" == *".tex" ]]; then
      NOME=$(basename $arg .tex)
   elif [ "$arg" == "--update" ]; then
      update
      exit $?
   elif [ "$arg" == "-v" ]; then
      std="stdout"
   fi
done

# Verificar se o compilador LaTeX estah instalado
command -v pdflatex 1> /dev/null 2>&1 || exit 1
# Verificar se o arquivo .tex existe
[ -e ${NOME}.tex ] || exit 1

# Saida do compilador
if [ "$std" == "stdout" ]; then
   # Compilar com saida
   tex $NOME
else
   # Compilar sem saida (stdout e stderr em /dev/null)
   tex $NOME 1> /dev/null 2>&1
fi

# ###
# Deletar arquivos criados
# ###

rm \
${NOME}.dvi \
${NOME}.gz \
${NOME}.dvi \
${NOME}.bak \
${NOME}.bbl \
${NOME}.blg \
${NOME}.aux \
${NOME}.toc \
${NOME}.lof \
${NOME}.lot \
${NOME}.log > /dev/null 2>&1

# ###
# Abrir pdf
# ###

if [ "$PREFIX" == "/data/data/com.termux/files/usr" ]; then
   [ -e ${NOME}.pdf ] && termux-open ${NOME}.pdf &
else
   [ -e ${NOME}.pdf ] && xdg-open ${NOME}.pdf &
   #[ -e ${NOME}.pdf ] && xreader ${NOME}.pdf &
fi

exit 0
