# dstu4163 — збірка прикладів, шаблонів і документації
#   make                 усе (LuaLaTeX)
#   make ENGINE=xelatex  усе через XeLaTeX
#   make install         клас і документація у TEXMFHOME
#   make clean | dist

ENGINE     ?= lualatex
LATEXMK    := latexmk -$(ENGINE) -interaction=nonstopmode -halt-on-error
TEXMFHOME  := $(shell kpsewhich -var-value TEXMFHOME)
INSTALLDIR := $(TEXMFHOME)/tex/latex/dstu4163
DOCDIR     := $(TEXMFHOME)/doc/latex/dstu4163

.PHONY: all examples templates doc install uninstall clean dist

all: doc

examples:
	cd examples && $(LATEXMK) *.tex

templates:
	cd templates && $(LATEXMK) *.tex

doc: examples templates
	cd doc && $(LATEXMK) dstu4163-doc.tex

install:
	mkdir -p "$(INSTALLDIR)" "$(DOCDIR)"
	cp dstu4163.cls "$(INSTALLDIR)/"
	cp doc/dstu4163-doc.pdf README.md "$(DOCDIR)/"
	@echo "dstu4163.cls -> $(INSTALLDIR)"
	@echo "documentation -> $(DOCDIR)  (texdoc dstu4163-doc)"

uninstall:
	rm -rf "$(INSTALLDIR)" "$(DOCDIR)"

clean:
	for d in examples templates doc; do (cd $$d && latexmk -c); done

dist: clean
	rm -rf build dstu4163.zip
	mkdir -p build/dstu4163
	cp -R dstu4163.cls README.md LICENSE Makefile doc templates examples build/dstu4163/
	cd build && zip -qr ../dstu4163.zip dstu4163
	rm -rf build
	@echo "dstu4163.zip"
