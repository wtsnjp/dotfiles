#!/usr/bin/perl
# %O: options
# %D: destination ﬁle (e.g., the name of the postscript ﬁle when converting a dvi ﬁle to postscript).
# %S: source file (e.g., the name of the dvi ﬁle when converting a dvi ﬁle to ps).
$latex = "platex -synctex=1 -interaction=nonstopmode %O %S";
$bibtex = "pbibtex";
$dvipdf = "dvipdfmx %O -o %D %S";
# $pdf_previewer = "open -a Skim.app %S";
# $pdf_update_method = 4;
# $pdf_update_command = "open -a Skim.app %S; sleep 0.5; open -a iTerm.app";
$makeindex = "makeindex";
# dvi => pdf
$pdf_mode = 3;
# Equivalent to the -pv option.
# $preview_mode = 1;
#$out_dir = "./out";
$clean_ext = 'synctex.gz synctex.gz(busy) run.xml tex.bak bbl bcf fdb_latexmk run tdo %R-blx.bib'
