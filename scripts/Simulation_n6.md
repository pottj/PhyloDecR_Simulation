
<!-- Simulation_n6.md is generated from Simulation_n6.Rmd. Please edit that file -->

# Introduction

<!-- badges: start -->
<!-- badges: end -->

I want to run a simulation for n=6 taxa. There are 15 possible
quadruples with n=6 taxa, and I want to test all possible combinations
for k out of 15 quadruples for phylogenetic decisiveness.

For each random set of quadruples, I test both the
4-way-partition-property (**4WPP**, truth) and Fischers algorithm
(**FAlg**, test).

# Initialize

I use a file names *mySourceFile.R* that contains all relevant R
packages and user-/server-specific path to the R library. If using this
code, you must make all the necessary changes within the template source
file.

``` r
rm(list = ls())
time0<-Sys.time()

source("../mySourceFile.R")
source("../helperFunctions/mySimulationFunction_exact.R")
```

# Get input data

In *myTab\_n6*, there are all possible Four-way-partitions (4WP) given
n=6 taxa.

In *quadruple\_data*, there are all possible quadruples given n=6 taxa.

``` r
test1 = createInput(fn="../testData/S6_Decisive.txt",sepSym = "_")
#> Input contains 10 trees with 6 different taxa. The biggest tree has 4 taxa.
quadruple_data = test1$data
quadruple_data[,status:=NA]
max_quad = dim(quadruple_data)[1]-1

load("../partitions/partitions_n6.RData")
```

# Test loop with 100 repeats

To test my simulation loop, I run it with only 100 repeats (should be
rather fast).

``` r
dumTab2 = foreach(j=1:max_quad)%do%{
  # j=10
  message("\nWorking on n=6, k=",j," & rep = 100 ... ")
  time1 = Sys.time()
  myTest = mySimulationFunction_exact(number_taxa = 6, 
                                number_quads = j,
                                repeats = 100,
                                data1 = quadruple_data,
                                data2 = myTab_n6,
                                verbose = T)
  time2 = Sys.time()
  x0 = as.numeric(round(difftime(time2,time1,units = "mins"),3))
  message("       Total time for n=6, k=",j," & rep = 100: " ,round(difftime(time2,time1,units = "mins"),3)," minutes")
  
  x1 = myTest$check3 == "CHECK 3 NOT OK - NOT PHYLOGENETICALLY DECISIVE" & 
    myTest$FWPP == "NOT PHYLOGENETICALLY DECISIVE"
  x1 = sum(x1)
  x2 = myTest$FischersAlg == "PHYLOGENETICALLY DECISIVE" & 
    myTest$FWPP == "PHYLOGENETICALLY DECISIVE"
  x2 = sum(x2)
  x3 = myTest$FWPP == "NOT PHYLOGENETICALLY DECISIVE"
  x3 = sum(x3)
  x4 = myTest$FWPP == "PHYLOGENETICALLY DECISIVE"
  x4 = sum(x4)
  
  message("       There were ",x1," of ",x3," sets identified by my initial check as not decisive (",round(x1/x3,4)*100,"%)")
  message("       There were ",x2," of ",x4," sets identified by Fischers algorith as decisive (",round(x2/x4,4)*100,"%)")
  
  res = data.table(k = j,
                   time = x0,
                   NR_check3_neg = x1,
                   NR_FAlg_pos = x2,
                   NR_NotPhyloDec = x3,
                   NR_PhyloDec = x4)
  res
}
#> 
#> Working on n=6, k=1 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Testing all combination only once ...
#>        Working on 15 repeats of 15 combinations
#>        Total time for n=6, k=1 & rep = 100: 0.054 minutes
#>        There were 15 of 15 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=6, k=2 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 105 combinations
#>        Total time for n=6, k=2 & rep = 100: 0.321 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=6, k=3 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 455 combinations
#>        Total time for n=6, k=3 & rep = 100: 0.301 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=6, k=4 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 1365 combinations
#>        Total time for n=6, k=4 & rep = 100: 0.302 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=6, k=5 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 3003 combinations
#>        Total time for n=6, k=5 & rep = 100: 0.307 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=6, k=6 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 5005 combinations
#>        Total time for n=6, k=6 & rep = 100: 0.339 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=6, k=7 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 6435 combinations
#>        Total time for n=6, k=7 & rep = 100: 0.366 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=6, k=8 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 6435 combinations
#>        Total time for n=6, k=8 & rep = 100: 0.403 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=6, k=9 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 5005 combinations
#>        Total time for n=6, k=9 & rep = 100: 0.44 minutes
#>        There were 96 of 96 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 4 sets identified by Fischers algorith as decisive (0%)
#> 
#> Working on n=6, k=10 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 3003 combinations
#>        Total time for n=6, k=10 & rep = 100: 0.393 minutes
#>        There were 55 of 58 sets identified by my initial check as not decisive (94.83%)
#>        There were 40 of 42 sets identified by Fischers algorith as decisive (95.24%)
#> 
#> Working on n=6, k=11 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 1365 combinations
#>        Total time for n=6, k=11 & rep = 100: 0.343 minutes
#>        There were 19 of 24 sets identified by my initial check as not decisive (79.17%)
#>        There were 76 of 76 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=6, k=12 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 455 combinations
#>        Total time for n=6, k=12 & rep = 100: 0.273 minutes
#>        There were 0 of 7 sets identified by my initial check as not decisive (0%)
#>        There were 93 of 93 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=6, k=13 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Working on 100 repeats of 105 combinations
#>        Total time for n=6, k=13 & rep = 100: 0.244 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=6, k=14 & rep = 100 ...
#>        Input data matches to given taxa size
#>        Testing all combination only once ...
#>        Working on 15 repeats of 15 combinations
#>        Total time for n=6, k=14 & rep = 100: 0.039 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 15 of 15 sets identified by Fischers algorith as decisive (100%)
dumTab2 = rbindlist(dumTab2)
dumTab2[,negRate := NR_check3_neg/NR_NotPhyloDec]
dumTab2[,posRate := NR_FAlg_pos/NR_PhyloDec]
dumTab2[NR_PhyloDec==0,posRate := NA]
dumTab2[NR_NotPhyloDec==0,negRate := NA]
dumTab2[NR_PhyloDec>0,]
#>     k  time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec   negRate
#> 1:  9 0.440            96           0             96           4 1.0000000
#> 2: 10 0.393            55          40             58          42 0.9482759
#> 3: 11 0.343            19          76             24          76 0.7916667
#> 4: 12 0.273             0          93              7          93 0.0000000
#> 5: 13 0.244             0         100              0         100        NA
#> 6: 14 0.039             0          15              0          15        NA
#>     posRate
#> 1: 0.000000
#> 2: 0.952381
#> 3: 1.000000
#> 4: 1.000000
#> 5: 1.000000
#> 6: 1.000000
```

# Loop with 10,000 repeats

I use for n=6 still the exact test, as the maximal combination number is
6435 &lt; 10000.

``` r
registerDoMC(cores=5)

dumTab3 = foreach(j=1:max_quad)%dopar%{
  # j=10
  message("\nWorking on n=6, k=",j," & rep = max 10,000 ... ")
  time1 = Sys.time()
  myTest = mySimulationFunction_exact(number_taxa = 6, 
                                number_quads = j,
                                repeats = 10000,
                                data1 = quadruple_data,
                                data2 = myTab_n6,
                                verbose = F)
  
  time2 = Sys.time()
  x0 = as.numeric(round(difftime(time2,time1,units = "mins"),3))
  message("       Total time for n=6, k=",j," & rep = 100: " ,round(difftime(time2,time1,units = "mins"),3)," minutes")
  
  outfn = paste0("../results/SimulationResults_n6_k",j,"_rep10000.RData")
  save(myTest,file = outfn)
  
  x1 = myTest$check3 == "CHECK 3 NOT OK - NOT PHYLOGENETICALLY DECISIVE" & 
    myTest$FWPP == "NOT PHYLOGENETICALLY DECISIVE"
  x1 = sum(x1)
  x2 = myTest$FischersAlg == "PHYLOGENETICALLY DECISIVE" & 
    myTest$FWPP == "PHYLOGENETICALLY DECISIVE"
  x2 = sum(x2)
  x3 = myTest$FWPP == "NOT PHYLOGENETICALLY DECISIVE"
  x3 = sum(x3)
  x4 = myTest$FWPP == "PHYLOGENETICALLY DECISIVE"
  x4 = sum(x4)
  
  message("       There were ",x1," of ",x3," sets identified by my initial check as not decisive (",round(x1/x3,4)*100,"%)")
  message("       There were ",x2," of ",x4," sets identified by Fischers algorith as decisive (",round(x2/x4,4)*100,"%)")
  
  res = data.table(k = j,
                   time = x0,
                   NR_check3_neg = x1,
                   NR_FAlg_pos = x2,
                   NR_NotPhyloDec = x3,
                   NR_PhyloDec = x4)
  res
}
SimulationResults_n6 = rbindlist(dumTab3)

SimulationResults_n6[,negRate := NR_check3_neg/NR_NotPhyloDec]
SimulationResults_n6[,posRate := NR_FAlg_pos/NR_PhyloDec]
SimulationResults_n6[NR_PhyloDec==0,posRate := NA]
SimulationResults_n6[NR_NotPhyloDec==0,negRate := NA]
save(SimulationResults_n6, file = "../results/SimulationResults_n6.RData")

SimulationResults_n6[NR_PhyloDec>0,]
#>     k   time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec   negRate
#> 1:  9 22.202          4575           0           4585         420 0.9978190
#> 2: 10 12.131          1575        1296           1635        1368 0.9633028
#> 3: 11  4.762           225        1080            285        1080 0.7894737
#> 4: 12  1.349             0         435             20         435 0.0000000
#> 5: 13  0.259             0         105              0         105        NA
#> 6: 14  0.037             0          15              0          15        NA
#>      posRate
#> 1: 0.0000000
#> 2: 0.9473684
#> 3: 1.0000000
#> 4: 1.0000000
#> 5: 1.0000000
#> 6: 1.0000000
```

# Session Info

``` r
sessionInfo()
#> R version 4.1.0 (2021-05-18)
#> Platform: x86_64-suse-linux-gnu (64-bit)
#> Running under: openSUSE Leap 15.3
#> 
#> Matrix products: default
#> BLAS:   /usr/lib64/R/lib/libRblas.so
#> LAPACK: /usr/lib64/R/lib/libRlapack.so
#> 
#> locale:
#>  [1] LC_CTYPE=de_DE.UTF-8       LC_NUMERIC=C              
#>  [3] LC_TIME=de_DE.UTF-8        LC_COLLATE=de_DE.UTF-8    
#>  [5] LC_MONETARY=de_DE.UTF-8    LC_MESSAGES=de_DE.UTF-8   
#>  [7] LC_PAPER=de_DE.UTF-8       LC_NAME=C                 
#>  [9] LC_ADDRESS=C               LC_TELEPHONE=C            
#> [11] LC_MEASUREMENT=de_DE.UTF-8 LC_IDENTIFICATION=C       
#> 
#> attached base packages:
#> [1] parallel  stats     graphics  grDevices utils     datasets  methods  
#> [8] base     
#> 
#> other attached packages:
#> [1] PhyloDecR_0.0.0.9007 ggplot2_3.3.5        doMC_1.3.7          
#> [4] iterators_1.0.13     foreach_1.5.1        data.table_1.14.2   
#> 
#> loaded via a namespace (and not attached):
#>  [1] compiler_4.1.0   pillar_1.6.4     tools_4.1.0      digest_0.6.29   
#>  [5] evaluate_0.14    lifecycle_1.0.1  tibble_3.1.6     gtable_0.3.0    
#>  [9] pkgconfig_2.0.3  rlang_0.4.12     DBI_1.1.2        yaml_2.2.1      
#> [13] xfun_0.29        fastmap_1.1.0    withr_2.4.3      stringr_1.4.0   
#> [17] dplyr_1.0.7      knitr_1.37       generics_0.1.1   vctrs_0.3.8     
#> [21] grid_4.1.0       tidyselect_1.1.1 glue_1.6.0       R6_2.5.1        
#> [25] fansi_1.0.0      rmarkdown_2.11   purrr_0.3.4      magrittr_2.0.1  
#> [29] scales_1.1.1     codetools_0.2-18 ellipsis_0.3.2   htmltools_0.5.2 
#> [33] assertthat_0.2.1 colorspace_2.0-2 utf8_1.2.2       stringi_1.7.6   
#> [37] munsell_0.5.0    crayon_1.4.2
message("\nTOTAL TIME : " ,round(difftime(Sys.time(),time0,units = "mins"),3)," minutes")
#> 
#> TOTAL TIME : 32.581 minutes
```
