#############################
# this is a template source file
# please change all paths accordingly
#############################

#############################
# R library and R packages
#############################
.libPaths("/PATH/TO/RLibrary/VERSION_4.x/") 
.libPaths()

suppressPackageStartupMessages(library(data.table))
setDTthreads(1)
suppressPackageStartupMessages(library(foreach))
suppressPackageStartupMessages(library(doMC))
suppressPackageStartupMessages(library(ggplot2))

# install.packages("../../PhyloDecR_0.0.0.9007.tar.gz", repos = NULL, type = "source")
library(PhyloDecR)
