DATA FILES FOR TRILOBITE GROWTH PROJECTS

+[growth-koninckii-min.txt](growth-koninckii-min.txt)

Comprises length data for specimens of the trilobite <i>Aulacopleura koninckii</i>. Thoracic tergites are numbered from anterior to posterior.  All lengths are in millimeters. NA = not applicable (i.e. specimen did not have that thoracic tergite). Total body length may be calculated by summing across all sclerites for each specimen. Column headers are in the format expected by the par.est.R script as follows:

"morphotype" = number of thoracic tergites in trunk

"CEL" = length of cephalon

"TS1" = length of thoracic tergite 1

"TS2" = length of thoracic tergite 2

...

...

"TS22" = length of thoracic tergite 22

"PYL" = length of pygidium

Used in \[Hopkins MJ (2020)](https://paleorxiv.org/zt642/)\

Modified from supplementary tables associated with: \[Hughes NC, Hong PS, Hou JB and Fusco G (2017)](https://www.frontiersin.org/articles/10.3389/fevo.2017.00037/full)\

Distributed under a CC-BY license.

+[Elrathia-kingii-length.txt](Elrathia-kingii-length.txt)

Comprises length data for 228 specimens of the trilobite Elrathia kingii. Thoracic tergites are numbered from anterior to posterior; values are averaged as described in the methods.  All lengths are in millimeters. NA = not applicable (i.e. specimen did not have that thoracic tergite). Total body length may be calculated by summing across all sclerites for each specimen. Catalog numbers are used as row names. Column headers are in the format expected by the par.est.R script as follows:

"morphotype" = number of thoracic tergites in trunk

"CEL" = length of cephalon

"TS1" = length of thoracic tergite 1

"TS2" = length of thoracic tergite 2

...

...

"TS13" = length of thoracic tergite 13

"PYL" = length of pygidium

To run the par.est.R script on this dataset:
x <- read.table('Elrathia-kingii-length.txt', header = TRUE)
source ('par.est.R')
par.est.x <- par.est(x)
