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

# Mensagem de ajuda
usage(){
cat << EOF
Script para compilar arquivos .tex escritos em LaTeX

Use $0 [arg]
arg:
    [-h] [help]               Ver esta menssagem
    [NomeArquivo.tex]         Para compilar
    [-v] [NomeArquivo.tex]    Para compilar e ver a saida dos comandos
EOF
}

# Funcao que compila o .tex
function tex (){
   pdflatex -shell-escape --interaction=nonstopmode $1
   pdflatex -shell-escape --interaction=nonstopmode $1

   bibtex ${NOME}
   pdflatex -shell-escape --interaction=nonstopmode $1
   bibtex ${NOME}

   makeindex ${NOME}.glo -s ${NOME}.ist -t ${NOME}.glg -o ${NOME}.gls
   makeindex -s ${NOME}.ist -t ${NOME}.nlg -o ${NOME}.ntn ${NOME}.not

   pdflatex -shell-escape --interaction=nonstopmode $1
   bibtex ${NOME}
   makeindex ${NOME}.glo -s ${NOME}.ist -t ${NOME}.glg -o ${NOME}.gls
   makeindex -s ${NOME}.ist -t ${NOME}.nlg -o ${NOME}.ntn ${NOME}.not

   pdflatex -shell-escape --interaction=nonstopmode $1
   pdflatex -shell-escape --interaction=nonstopmode $1
   pdflatex -shell-escape --interaction=nonstopmode $1
   
   res=0
}

# Verificar argumentos passados ao script
for arg in "$@"; do
   # Ajuda
   if [ "$arg" == "-h" ] || [ "$arg" == "help" ] || [ "$arg" == "--help" ]; then
      usage
      exit 0
   fi
   # Saida do compilador
   if [ "$arg" == "-v" ]; then V="TRUE"; fi
done

NOME=$(basename $1 .tex)
if [ "$V" == "TRUE" ]; then
   # Compilar com saida
   tex $@
else
   # Compilar sem saida
   tex $@ > out.log 2> /dev/null
fi

rm *.dvi *.gz *.dvi *.bak *.bbl *.blg *.aux *.toc\
*.lof *.lot > out.log 2> /dev/null
rm *.log

if [ "$PREFIX" == "/data/data/com.termux/files/usr" ]; then
   [ -e ${NOME}.pdf ] && termux-open ${NOME}.pdf &
else
   [ -e ${NOME}.pdf ] && xdg-open ${NOME}.pdf &
   #[ -e ${NOME}.pdf ] && xreader ${NOME}.pdf &
fi
