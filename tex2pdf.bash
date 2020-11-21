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
#
#
#  Para facilitar:          sudo cp tex2pdf.bash /bin/tex2pdf && sudo chmod 755 /bin/tex2pdf
#  Para compilar um .tex:   tex2pdf <NomeDoArquivo.tex>


NOME=$(basename $1 .tex)

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
EOF
}


# ###
# Funcao que compila o arquivo .tex
# ###

function tex (){
   pdflatex -shell-escape --interaction=nonstopmode ${NOME}.tex
   pdflatex -shell-escape --interaction=nonstopmode ${NOME}.tex

   bibtex ${NOME}
   pdflatex -shell-escape --interaction=nonstopmode ${NOME}.tex
   bibtex ${NOME}

   makeindex ${NOME}.glo -s ${NOME}.ist -t ${NOME}.glg -o ${NOME}.gls
   makeindex -s ${NOME}.ist -t ${NOME}.nlg -o ${NOME}.ntn ${NOME}.not

   pdflatex -shell-escape --interaction=nonstopmode ${NOME}.tex
   bibtex ${NOME}
   makeindex ${NOME}.glo -s ${NOME}.ist -t ${NOME}.glg -o ${NOME}.gls
   makeindex -s ${NOME}.ist -t ${NOME}.nlg -o ${NOME}.ntn ${NOME}.not

   pdflatex -shell-escape --interaction=nonstopmode ${NOME}.tex
   pdflatex -shell-escape --interaction=nonstopmode ${NOME}.tex
   pdflatex -shell-escape --interaction=nonstopmode ${NOME}.tex
}


# Verificar se o compilador LaTeX estah instalado

if ! command -v pdflatex > /dev/null 2>&1; then
   exit 1
fi

if ! [ -e ${NOME}.tex ]; then
   exit 1
fi

# ###
# Verificar argumentos passados ao script
# ###

# Ajuda
for arg in "$@"; do
   if [ "$arg" == "-h" ] || [ "$arg" == "help" ] || [ "$arg" == "--help" ]; then
      usage
      exit 0
   fi
done

# Saida do compilador
if [ "$1" == "-v" ] || [ "$2" == "-v" ]; then
   # Compilar com saida
   tex $@
else
   # Compilar sem saida (stdout e stderr em /dev/null)
   tex $@ > /dev/null 2>&1
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
