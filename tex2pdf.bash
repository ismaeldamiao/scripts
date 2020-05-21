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


function tex (){
 pdflatex -shell-escape --interaction=nonstopmode $1
 pdflatex -shell-escape --interaction=nonstopmode $1
 bibtex $(basename $1 .tex)
 pdflatex -shell-escape --interaction=nonstopmode $1
 bibtex $(basename $1 .tex)
 makeindex $(basename $1 .tex).glo -s $(basename $1 .tex).ist -t $(basename $1 .tex).glg -o $(basename $1 .tex).gls
 makeindex -s $(basename $1 .tex).ist -t $(basename $1 .tex).nlg -o $(basename $1 .tex).ntn $(basename $1 .tex).not
 
 pdflatex -shell-escape --interaction=nonstopmode $1
 bibtex $(basename $1 .tex)
 makeindex $(basename $1 .tex).glo -s $(basename $1 .tex).ist -t $(basename $1 .tex).glg -o $(basename $1 .tex).gls
 makeindex -s $(basename $1 .tex).ist -t $(basename $1 .tex).nlg -o $(basename $1 .tex).ntn $(basename $1 .tex).not
 
 pdflatex -shell-escape --interaction=nonstopmode $1
 pdflatex -shell-escape --interaction=nonstopmode $1
 pdflatex -shell-escape --interaction=nonstopmode $1
 [ -e $(basename $1 .tex).pdf ] && xdg-open $(basename $1 .tex).pdf&   
}
tex $@
rm *.dvi *.gz *.dvi *.bak *.bbl *.blg *.log *.aux *.toc *.lof *.lot
