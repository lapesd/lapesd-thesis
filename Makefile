# Shell expansions were written for bash, they might work with other shells, but
# settings this will avoid needless suffering
SHELL=/bin/bash

# Control which programs to use
PDFLATEX=pdflatex
BIBTEX=bibtex
MAKEINDEX=makeindex
LTX=$(PDFLATEX) -shell-escape -interaction=nonstopmode
XINDY=xindy
INKS=inkscape
GIT=git
PDFINFO=pdfinfo
PODOFOBOX=podofobox
GNUPLOT=gnuplot

srcs=$(wildcard *.tex) $(wildcard *.bib)
svgs=$(wildcard imgs/*.svg)
pdfs=$(svgs:.svg=.pdf)

basename:=$(shell (grep -rE '\\documentclass.*lapesd-thesis' | cut -d : -f 1 | grep -E '.tex$$' | xargs -n 1 bash -c 'echo $$(echo $$@ | wc -c):$$@' a | sed -E 's/^([0-9]):/00\1:/' | sed -E 's/^([0-9][0-9]):/0\1:/' | sort -u | head -n 1 | sed -E 's/^[0-9]+:(.*).tex$$/\1/g' > basename.make.log && test "$$(cat basename.make.log)" != "001:" && cat basename.make.log && rm -f basename.make.log)  || echo main)

RED=$(shell tput sgr0 ; tput setab 1 ; tput setaf 7)
YELLOW=$(shell tput sgr0 ; tput setab 3 ; tput setaf 0)
DIM=$(shell tput sgr0 ; tput dim)
BOLD=$(shell tput bold)
NORM=$(shell tput sgr0)

###################################################
# phony targets                                   #
###################################################

all: imgs $(basename).pdfa.pdf

imgs: $(pdfs)

.PHONY: all imgs clean

# Avoid deletion by make (chained pattern rules)
.SECONDARY: $(basename).aux $(basename).blg $(basename).ilg $(basename).pdf

clean:
	rm -fr *.64 main-logo.pdf _minted-* *.aux *.bbl *.blg *.brf *.out *.synctex.gz *.log "$(basename).pdf" "$(basename).pdfa.pdf" *.idx *.ilg *.ind *.lof *.lot *.lol *.loalgorithm *.glsdefs *.xdy *.toc *.acn *.glo *.ist *.prv *.fls *.fdb_latexmk _region*  *~ auto imgs/*.tmp.pdf {imgs,plots}/*-eps-converted-to.pdf;


###################################################
# SVG -> PDF conversion                           #
###################################################

INKS_VER:=$(shell (inkscape --version 2>&1 | grep -E 'Inkscape [1-9]' &>/dev/null) && echo 1 || echo 0)
INKSCAPE=$(INKS) $(if $(subst 0,,$(INKS_VER)),,-z)
define inkscape2pdf
	$(INKSCAPE) $(3) $(if $(subst 0,,$(INKS_VER)),--export-filename,-A)=$(2) $(1)
endef

# directly convert a SVG to PDF. The SVG's contents will be cropped to the page
imgs/%.pdf: imgs/%.svg
	$(call inkscape2pdf,"$$(pwd)/$<","$$(pwd)/$@",-C)

#Possible bug: inkscape -z -D -i gSlide1 -A=out.pdf in.svg
#Workaround: generate a pdf of the whole drawing (-D, beyond page borders); get bottom:left:width:height of object; convert px to PostScript pts; crop from the pdf
#Quirk: inkscape -Y has top-left corner of page at origin
define svg2pdf
	$(call inkscape2pdf,$(1).svg,$(3).tmp.pdf,--export-area-drawing)
	PTS=$$($(PDFINFO) $(3).tmp.pdf | grep 'Page size' | sed 's/[^0-9]*\([0-9]*\.[0-9]*\)[^0-9].*/\1/'); \
	IW=$$($(INKSCAPE) --query-width $(1).svg); \
	FAC=$$(echo "scale=3; 100 * $$PTS / $$IW" | bc); \
	X=$$(awk "BEGIN {printf \"%.3f\", $$FAC * $$($(INKSCAPE) -I $(2) -X $(1).svg)}"); \
	Y=$$(awk "BEGIN {printf \"%.3f\", $$FAC * (-1)*($$($(INKSCAPE) -I $(2) -Y $(1).svg))}"); \
	W=$$(awk "BEGIN {printf \"%.3f\", $$FAC * $$($(INKSCAPE) -I $(2) -W $(1).svg)}"); \
	H=$$(awk "BEGIN {printf \"%.3f\", $$FAC * $$($(INKSCAPE) -I $(2) -H $(1).svg)}"); \
	$(PODOFOBOX) $(3).tmp.pdf $(3).pdf media $$X $$Y $$W $$H
	rm $(3).tmp.pdf
endef


###################################################
# main targets                                    #
###################################################

%.aux: %.tex $(srcs) $(pdfs) $(plotspdfs)
	@for i in 1 2 3; do \
		echo '$(LTX) "$<" &>/dev/null' ; \
		($(LTX) "$<" 2>&1 | grep 'Label(s) may have changed' | &>/dev/null) || break; \
	done; true

# Create index file
%.ilg: %.aux
	@if [ ! -f "$*.idx" ]; then \
		echo "$*.idx $(YELLOW)missing$(NORM), will skip makeindex"; \
		touch -f "$@"; \
	else \
		echo $(MAKEINDEX) "$*.idx" "$(DIM)"; \
		$(MAKEINDEX) "$*.idx" &>"$*.idx.make.log"; RET=$$? ;\
		sed -E 's/(^| 0|[Nn][Oo])( +)[Ww](arnings?)/\1\2x\3/' <"$*.idx.make.log" \
			| sed -E 's/[Ww]arnings?/$(YELLOW)\0$(DIM)/'  \
			| sed -E 's/[Ee]rrors?/$(RED)\0$(DIM)/' \
			| sed -E 's/xarning/warning/'; echo "$(NORM)"; \
		rm -f "$*.idx.make.log" ; \
		test "$$RET" == 0 ;\
	fi

%.blg: %.aux
	@if [ ! -f "$<" ]; then \
		echo "$< $(RED)missing$(NORM), will skip bibtex"; \
		touch "$@"; \
	else \
		echo $(BIBTEX) "$<" "$(DIM)"; \
		$(BIBTEX) "$<" &> "$@.make.log"; RET=$$? ;\
		sed -E 's/[Ww]arning/$(YELLOW)\0$(DIM)/' <"$@.make.log" \
			| sed -E 's/[Ee]rror/$(RED)\0$(DIM)/'; echo "$(NORM)" ;\
		rm -f "$@.make.log" ;\
		test "$$RET" == 0; \
	fi


%.pdf: %.tex %.aux %.blg %.ilg
	@ RET=0; \
  for i in 1 2 3 4; do \
		echo '$(LTX) "$<" ' ; \
		$(LTX) "$<" &> "$@.make.log" ; RET=$$?; \
		grep 'Label(s) may have changed' "$@.make.log" &>/dev/null || break ; \
	done; \
	WARNS=$$(grep -i warning "$@.make.log" | wc -l); \
	echo -n "$(DIM)" ; sed -E 's/[Ww]arning/$(YELLOW)\0$(DIM)/' <"$@.make.log" \
		| sed -E 's/^! Undefined control sequence/$(RED)\0$(DIM)/' ;\
		echo "$(NORM)" ; \
	rm -f "$@.make.log" ; \
	test "$$RET" == 0 || echo "$(PDFLATEX) $(RED)failed$(NORM) with code $$RET (see the log above)"; \
	test "$$WARNS" == 0 || echo "$(PDFLATEX) spewed $$WARNS $(YELLOW)warnings$(NORM)"; \
	test "$$RET" == 0


###################################################
# PDF/A                                           #
###################################################

PDFA_URL="https://github.com/alexishuf/pdfa-gs-converter/releases/download/v0.2/pdfa-gs-converter.sh"
PDFA=pdfa-gs-converter

#pdfda-gs-converter may be in different places depending on how lapesd-thesis is used:
# - we are a clone or copy of lapesd-thesis
# - lapesd-thesis is a subdir/submodule
# - someone just copied the class and the Makefile: download pdfa-gs-converter
#   - if download fails, assume it is on $PATH and hope for the best
#
# In the first two cases, it may also happen that the pdfa-gs-converter
# submodule was not pulled or that it was somehow lost. In such scenarios,
# testing continues until pdfa-gs-converter.sh is downloaded
%.pdfa.pdf: %.pdf
	@ PDFA_CMD=$$( \
		(test -d $(PDFA) && make -C $(PDFA) all &>/dev/null && echo $(PDFA)/$(PDFA).sh) ||\
		(test -d lapesd-thesis/$(PDFA) && make -C lapesd-thesis/$(PDFA) &>/dev/null &&\
			echo lapesd-thesis/$(PDFA)/$(PDFA).sh) ||\
		((test -f $(PDFA).sh || curl -Lo $(PDFA).sh $(PDFA_URL)) && echo bash ./$(PDFA).sh) ||\
		(echo $(PDFA).sh)\
	); \
	echo $$PDFA_CMD "$<" "$@" "$(DIM)"; \
	$$PDFA_CMD "$<" "$@" 2>&1\
		| grep -v "nnotation set to non-printing" \
		| grep -v "annotation will not be present in output file" ;\
	echo "$(NORM)"
