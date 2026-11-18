# dstu4163 — Ukrainian letters per ДСТУ 4163:2020

Version 1.1, 2026-11-18

`dstu4163` is a LaTeX class for Ukrainian official and business letters. It
lays them out according to ДСТУ 4163:2020 «Уніфікована система
організаційно-розпорядчої документації. Вимоги до оформлення документів».
It supports corner and long letterheads, plain sheets for citizens'
applications, addressees, headings, attachment marks, signatures, executor
details and page numbering. All margins and indents follow the standard.
Empty fields and empty commands print nothing, so one template covers every
letter type.

The full manual, written in Ukrainian, is `doc/dstu4163-doc.pdf`.

## Contents

```
dstu4163.cls                  the class
README.md                     this file
LICENSE                       LPPL 1.3c
Makefile                      build / install / clean / dist
doc/dstu4163-doc.{tex,pdf}    manual (Ukrainian)
templates/lyst-porozhnii.tex  empty template, every field annotated (Ukrainian)
templates/lyst-povnyi.tex     full template, every feature in use
examples/00-…07-*.tex         letterhead form, service, cover and guarantee letters,
                              personal letter, citizen's application, information request
*/latexmkrc                   lets latexmk find the class in the parent folder
```

## Requirements

- TeX Live 2021 or later (MacTeX, MiKTeX) with LuaLaTeX (default) or XeLaTeX.
  pdfLaTeX is not supported.
- `fontspec`, `babel`, `geometry`, `graphicx`, `iftex`, plus the Ukrainian
  hyphenation patterns from `collection-langcyrillic`.
- Times New Roman. If it is missing, the class falls back to Liberation Serif,
  then to TeX Gyre Termes.

## Installation

From a clone of this repository:

```sh
git clone https://github.com/kunchenkodm/dstu4163.git
cd dstu4163
make install     # class -> $TEXMFHOME/tex/latex/dstu4163, manual -> $TEXMFHOME/doc/latex/dstu4163
```

Check with `kpsewhich dstu4163.cls`; open the manual with `texdoc dstu4163-doc`.
Remove with `make uninstall`. Alternatively, put `dstu4163.cls` next to your document.

## Build

```sh
make                  # examples, templates, manual (LuaLaTeX)
make ENGINE=xelatex   # same with XeLaTeX
make clean            # remove auxiliary files
make dist             # dstu4163.zip
```

## Minimal example

```latex
\documentclass[14pt]{dstu4163}
\dstusetup{
  name = {Товариство з обмеженою відповідальністю «Альфа»},
  address = {вул. Хрещатик, 1,\\ м. Київ, 01001}, code = {12345678},
  date = {18.11.2026}, index = {01-12/345},
}
\addressee{Директору ТОВ «Бета»\\ Роману \surname{Зуєву}}
\begin{document}
\heading{Про співпрацю}
\salutation{Шановний пане Романе!}
Текст листа.
\signature{Директор}{Ігор \surname{Шевчук}}
\executor{Мельник Ольга 044 000 00 01}
\end{document}
```

## License

LaTeX Project Public License 1.3c or later
(https://www.latex-project.org/lppl.txt).

This class is not an official edition of the standard. For legally
significant documents, check the official text of ДСТУ 4163:2020 and your
organisation's records-management instruction.

## Changes

- 1.1 (2026-11-18): fictional names in all examples; empty fields and commands drop out; new keys `form`,
  `page-numbers` and `label-*`; blank lines allowed in `\dstusetup`; package
  layout with annotated templates, a Makefile and the manual.
- 1.0 (2026-11-18): first version.
