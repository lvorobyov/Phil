TARGET = report.pdf
TEX = pdftex
LATEX ?= pdflatex
ADOCS = $(wildcard *.adoc)
LATEXOPT = -draftmode -shell-escape

all: ${TARGET}

%.aux: %.tex preamble.fmt
	${LATEX} -draftmode -shell-escape "&preamble $<"

%.bbl: %.aux links.bib
	bibtex8 -B -c utf8cyrillic.csf $<

%.pdf: %.tex intro.tex concl.tex glossary.tex 1.tex 2.tex 3.tex preamble.fmt %.bbl
	${LATEX} -shell-escape "&preamble $<"
	${LATEX} -shell-escape "&preamble $<"

%.fmt: %.tex
	${TEX} -shell-escape -ini -jobname="preamble" "&${LATEX} $^\dump" "$<"

report.tex: report.adoc links.bib
	ad2tex.pl $< > $@.bak
	perl -lpe 'BEGIN{print "\\begin{document}"} END{print "\n\\end{document}"}' < $@.bak > $@
	rm $@.bak

%.tex: %.adoc
	ad2tex.pl $< > $@

%.bib: %.txt
	txt2bib.pl $<
	tpage --eval_perl -post_chomp /usr/bin/site_perl/bibtex.tt > $@

