SRC = demo.tex
PDF = demo.pdf
AUX = demo.aux
TEXC := xelatex
TEXC_OPTS += -shell-escape
TEXMFHOME = $(shell kpsewhich -var-value=TEXMFHOME)
INSTALL_DIR = $(TEXMFHOME)/tex/latex/guposter
LOGO = UoG_keyline.pdf

.PHONY: clean install

all: $(PDF)

$(AUX):
	$(TEXC) $(TEXC_OPTS) $(SRC)

$(PDF): guposter.cls $(AUX) $(SRC) $(LOGO)
	$(TEXC) $(TEXC_OPTS) $(SRC)

$(LOGO):
	./download_logo.sh

clean:
	@rm -f $(PDF)
	@git clean -xf

install: $(LOGO)
	mkdir -p $(INSTALL_DIR)
	cp *.sty $(INSTALL_DIR)
