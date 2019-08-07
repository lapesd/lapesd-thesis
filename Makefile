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

all: imgs main.robust.pdf

imgs: $(pdfs)

.PHONY: all imgs clean

clean: 
	rm -fr *.64 main-logo.pdf _minted-* *.aux *.bbl *.blg *.brf *.out *.synctex.gz *.log main.pdf main.robust.pdf *.idx *.ilg *.ind *.lof *.lot *.lol *.loalgorithm *.glsdefs *.xdy *.toc *.acn *.glo *.ist *.prv _region*  *~ auto imgs/*.tmp.pdf {imgs,plots}/*-eps-converted-to.pdf; 


# directly convert a SVG to PDF. The SVG's contents will be cropped to the page
imgs/%.pdf: imgs/%.svg
	$(INKS) -z -C -A="$$(pwd)/$@" "$$(pwd)/$<"

#Possible bug: inkscape -z -D -i gSlide1 -A=out.pdf in.svg
#Workaround: generate a pdf of the whole drawing (-D, beyond page borders); get bottom:left:width:height of object; convert px to PostScript pts; crop from the pdf
#Quirk: inkscape -Y has top-left corner of page at origin
define svg2pdf
	$(INKS) -z -D -A=$(3).tmp.pdf $(1).svg
	PTS=$$($(PDFINFO) $(3).tmp.pdf | grep 'Page size' | sed 's/[^0-9]*\([0-9]*\.[0-9]*\)[^0-9].*/\1/'); \
	IW=$$($(INKS) -z --query-width $(1).svg); \
	FAC=$$(echo "scale=3; 100 * $$PTS / $$IW" | bc); \
	X=$$(awk "BEGIN {printf \"%.3f\", $$FAC * $$($(INKS) -z -I $(2) -X $(1).svg)}"); \
	Y=$$(awk "BEGIN {printf \"%.3f\", $$FAC * (-1)*($$($(INKS) -z -I $(2) -Y $(1).svg))}"); \
	W=$$(awk "BEGIN {printf \"%.3f\", $$FAC * $$($(INKS) -z -I $(2) -W $(1).svg)}"); \
	H=$$(awk "BEGIN {printf \"%.3f\", $$FAC * $$($(INKS) -z -I $(2) -H $(1).svg)}"); \
	$(PODOFOBOX) $(3).tmp.pdf $(3).pdf media $$X $$Y $$W $$H
	rm $(3).tmp.pdf
endef

main.aux: $(srcs) $(pdfs) $(plotspdfs)
	$(LTX) main.tex; $(LTX) main.tex || true

# Create index file
main.ilg: main.aux $(srcs)
	$(MAKEINDEX) main.idx

main.blg: main.aux $(srcs)
	$(BIBTEX) main.aux

main.pdf: $(srcs) main.aux main.blg main.ilg
	$(LTX) main.tex; \
	$(LTX) main.tex || true

# Converts main.pdf to PDF version 1.4 and embedd all fonts
# This is required by IEEE (this is done by PDF Xpress) and Elsevier journals
main.robust.pdf: main.pdf
	gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dEmbedAllFonts=true -sOutputFile="$@" -f "$<" 
