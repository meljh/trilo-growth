INFO ABOUT DATA:

1) data/growth-koninckii-min.txt is modified from supplementary tables associated with:

Hughes NC, Hong PS, Hou JB and Fusco G (2017) The Development of the Silurian Trilobite Aulacopleura koninckii Reconstructed by Applying Inferred Growth and Segmentation Dynamics: A Case Study in Paleo-Evo-Devo. Front. Ecol. Evol. 5:37. doi: 10.3389/fevo.2017.00037

and distributed under a CC-BY license.

It is used in H

2) The empirical data file "Elrathia-kingii-length.txt" comprises length data for 228 specimens of the trilobite Elrathia kingii. Thoracic tergites are numbered from anterior to posterior; values are averaged as described in the methods.  All lengths are in millimeters. NA = not applicable (i.e. specimen did not have that thoracic tergite). Total body length may be calculated by summing across all sclerites for each specimen. Catalog numbers are used as row names. Column headers are in the format expected by the par.est.R script as follows:

"morphotype" = number of thoracic tergites in trunk
"CEL" = length of cephalon
"TS1" = length of thoracic tergite 1
"TS2" = length of thoracic tergite 2
"TS3" = length of thoracic tergite 3
"TS4" = length of thoracic tergite 4
"TS5" = length of thoracic tergite 5
"TS6" = length of thoracic tergite 6
"TS7" = length of thoracic tergite 7
"TS8" = length of thoracic tergite 8
"TS9" = length of thoracic tergite 9
"TS10" = length of thoracic tergite 10
"TS11" = length of thoracic tergite 11
"TS12" = length of thoracic tergite 12
"TS13" = length of thoracic tergite 13
"PYL" = length of pygidium

To run the par.est.R script on this dataset:
x <- read.table('Elrathia-kingii-length.txt', header = TRUE)
source ('par.est.R')
par.est.x <- par.est(x)
