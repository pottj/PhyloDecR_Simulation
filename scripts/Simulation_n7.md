
<!-- Simulation_n7.md is generated from Simulation_n7.Rmd. Please edit that file -->

# Introduction

<!-- badges: start -->

<!-- badges: end -->

I want to run a simulation for n=7 taxa. There are 35 possible
quadruples with n=7 taxa, and I want to test all possible combinations
for k out of 35 quadruples for phylogenetic decisiveness.

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
source("../helperFunctions/mySimulationFunction.R")
```

# Get input data

In *myTab\_n7*, there are all possible Four-way-partitions (4WP) given
n=7 taxa.

In *quadruple\_data*, there are all possible quadruples given n=7 taxa.

``` r
test1 = createInput(fn="../testData/S7_Decisive.txt",sepSym = "_")
#> Input contains 14 trees with 7 different taxa. The biggest tree has 4 taxa.
quadruple_data = test1$data
quadruple_data[,status:=NA]
max_quad = dim(quadruple_data)[1]-1

load("../partitions/partitions_n7.RData")
```

# Test loop with 100 repeats

To test my simulation loop, I run it with only 100 repeats (should be
rather fast).

``` r
dumTab2 = foreach(j=1:max_quad)%do%{
  # j=10
  message("\nWorking on n=7, k=",j," & rep = 100 ... ")
  time1 = Sys.time()
  myTest = mySimulationFunction(number_taxa = 7, 
                                number_quads = j,
                                repeats = 100,
                                data1 = quadruple_data,
                                data2 = myTab_n7,
                                verbose = F)
  time2 = Sys.time()
  x0 = as.numeric(round(difftime(time2,time1,units = "mins"),3))
  message("       Total time for n=7, k=",j," & rep = 100: " ,round(difftime(time2,time1,units = "mins"),3)," minutes")
  
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
#> Working on n=7, k=1 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 35 combinations
#>        Total time for n=7, k=1 & rep = 100: 0.412 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=2 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 595 combinations
#>        Total time for n=7, k=2 & rep = 100: 0.448 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=3 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6545 combinations
#>        Total time for n=7, k=3 & rep = 100: 0.482 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=4 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 52360 combinations
#>        Total time for n=7, k=4 & rep = 100: 0.502 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=5 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 324632 combinations
#>        Total time for n=7, k=5 & rep = 100: 0.517 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=6 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1623160 combinations
#>        Total time for n=7, k=6 & rep = 100: 0.51 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=7 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6724520 combinations
#>        Total time for n=7, k=7 & rep = 100: 0.522 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=8 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 23535820 combinations
#>        Total time for n=7, k=8 & rep = 100: 0.536 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=9 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 70607460 combinations
#>        Total time for n=7, k=9 & rep = 100: 0.599 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=10 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 183579396 combinations
#>        Total time for n=7, k=10 & rep = 100: 0.581 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=11 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 417225900 combinations
#>        Total time for n=7, k=11 & rep = 100: 0.667 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=12 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 834451800 combinations
#>        Total time for n=7, k=12 & rep = 100: 0.689 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=13 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1476337800 combinations
#>        Total time for n=7, k=13 & rep = 100: 0.73 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=14 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2319959400 combinations
#>        Total time for n=7, k=14 & rep = 100: 0.78 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=15 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 3247943160 combinations
#>        Total time for n=7, k=15 & rep = 100: 0.826 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=16 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4059928950 combinations
#>        Total time for n=7, k=16 & rep = 100: 0.879 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=7, k=17 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4537567650 combinations
#>        Total time for n=7, k=17 & rep = 100: 0.925 minutes
#>        There were 98 of 99 sets identified by my initial check as not decisive (98.99%)
#>        There were 0 of 1 sets identified by Fischers algorith as decisive (0%)
#> 
#> Working on n=7, k=18 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4537567650 combinations
#>        Total time for n=7, k=18 & rep = 100: 0.961 minutes
#>        There were 94 of 99 sets identified by my initial check as not decisive (94.95%)
#>        There were 0 of 1 sets identified by Fischers algorith as decisive (0%)
#> 
#> Working on n=7, k=19 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4059928950 combinations
#>        Total time for n=7, k=19 & rep = 100: 0.924 minutes
#>        There were 85 of 95 sets identified by my initial check as not decisive (89.47%)
#>        There were 0 of 5 sets identified by Fischers algorith as decisive (0%)
#> 
#> Working on n=7, k=20 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 3247943160 combinations
#>        Total time for n=7, k=20 & rep = 100: 0.891 minutes
#>        There were 63 of 80 sets identified by my initial check as not decisive (78.75%)
#>        There were 13 of 20 sets identified by Fischers algorith as decisive (65%)
#> 
#> Working on n=7, k=21 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2319959400 combinations
#>        Total time for n=7, k=21 & rep = 100: 0.801 minutes
#>        There were 53 of 67 sets identified by my initial check as not decisive (79.1%)
#>        There were 22 of 33 sets identified by Fischers algorith as decisive (66.67%)
#> 
#> Working on n=7, k=22 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1476337800 combinations
#>        Total time for n=7, k=22 & rep = 100: 0.738 minutes
#>        There were 30 of 61 sets identified by my initial check as not decisive (49.18%)
#>        There were 37 of 39 sets identified by Fischers algorith as decisive (94.87%)
#> 
#> Working on n=7, k=23 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 834451800 combinations
#>        Total time for n=7, k=23 & rep = 100: 0.665 minutes
#>        There were 14 of 29 sets identified by my initial check as not decisive (48.28%)
#>        There were 69 of 71 sets identified by Fischers algorith as decisive (97.18%)
#> 
#> Working on n=7, k=24 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 417225900 combinations
#>        Total time for n=7, k=24 & rep = 100: 0.605 minutes
#>        There were 9 of 31 sets identified by my initial check as not decisive (29.03%)
#>        There were 69 of 69 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=7, k=25 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 183579396 combinations
#>        Total time for n=7, k=25 & rep = 100: 0.538 minutes
#>        There were 2 of 11 sets identified by my initial check as not decisive (18.18%)
#>        There were 88 of 89 sets identified by Fischers algorith as decisive (98.88%)
#> 
#> Working on n=7, k=26 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 70607460 combinations
#>        Total time for n=7, k=26 & rep = 100: 0.507 minutes
#>        There were 1 of 6 sets identified by my initial check as not decisive (16.67%)
#>        There were 94 of 94 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=7, k=27 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 23535820 combinations
#>        Total time for n=7, k=27 & rep = 100: 0.47 minutes
#>        There were 0 of 2 sets identified by my initial check as not decisive (0%)
#>        There were 98 of 98 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=7, k=28 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6724520 combinations
#>        Total time for n=7, k=28 & rep = 100: 0.44 minutes
#>        There were 0 of 3 sets identified by my initial check as not decisive (0%)
#>        There were 97 of 97 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=7, k=29 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1623160 combinations
#>        Total time for n=7, k=29 & rep = 100: 0.409 minutes
#>        There were 0 of 2 sets identified by my initial check as not decisive (0%)
#>        There were 98 of 98 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=7, k=30 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 324632 combinations
#>        Total time for n=7, k=30 & rep = 100: 0.379 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=7, k=31 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 52360 combinations
#>        Total time for n=7, k=31 & rep = 100: 0.363 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=7, k=32 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6545 combinations
#>        Total time for n=7, k=32 & rep = 100: 0.349 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=7, k=33 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 595 combinations
#>        Total time for n=7, k=33 & rep = 100: 0.343 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=7, k=34 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 35 combinations
#>        Total time for n=7, k=34 & rep = 100: 0.34 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
dumTab2 = rbindlist(dumTab2)
dumTab2[,negRate := NR_check3_neg/NR_NotPhyloDec]
dumTab2[,posRate := NR_FAlg_pos/NR_PhyloDec]
dumTab2[NR_PhyloDec==0,posRate := NA]
dumTab2[NR_NotPhyloDec==0,negRate := NA]
dumTab2[NR_PhyloDec>0,]
#>      k  time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec   negRate
#>  1: 17 0.925            98           0             99           1 0.9898990
#>  2: 18 0.961            94           0             99           1 0.9494949
#>  3: 19 0.924            85           0             95           5 0.8947368
#>  4: 20 0.891            63          13             80          20 0.7875000
#>  5: 21 0.801            53          22             67          33 0.7910448
#>  6: 22 0.738            30          37             61          39 0.4918033
#>  7: 23 0.665            14          69             29          71 0.4827586
#>  8: 24 0.605             9          69             31          69 0.2903226
#>  9: 25 0.538             2          88             11          89 0.1818182
#> 10: 26 0.507             1          94              6          94 0.1666667
#> 11: 27 0.470             0          98              2          98 0.0000000
#> 12: 28 0.440             0          97              3          97 0.0000000
#> 13: 29 0.409             0          98              2          98 0.0000000
#> 14: 30 0.379             0         100              0         100        NA
#> 15: 31 0.363             0         100              0         100        NA
#> 16: 32 0.349             0         100              0         100        NA
#> 17: 33 0.343             0         100              0         100        NA
#> 18: 34 0.340             0         100              0         100        NA
#>       posRate
#>  1: 0.0000000
#>  2: 0.0000000
#>  3: 0.0000000
#>  4: 0.6500000
#>  5: 0.6666667
#>  6: 0.9487179
#>  7: 0.9718310
#>  8: 1.0000000
#>  9: 0.9887640
#> 10: 1.0000000
#> 11: 1.0000000
#> 12: 1.0000000
#> 13: 1.0000000
#> 14: 1.0000000
#> 15: 1.0000000
#> 16: 1.0000000
#> 17: 1.0000000
#> 18: 1.0000000
```

# Loop with 10,000 repeats

``` r

registerDoMC(cores=5)

dumTab3 = foreach(j=1:max_quad)%dopar%{
  # j=10
  message("\nWorking on n=7, k=",j," & rep = max 10,000 ... ")
  time1 = Sys.time()
  myTest = mySimulationFunction(number_taxa = 7, 
                                number_quads = j,
                                repeats = 10000,
                                data1 = quadruple_data,
                                data2 = myTab_n7,
                                verbose = F)
  
  time2 = Sys.time()
  x0 = as.numeric(round(difftime(time2,time1,units = "mins"),3))
  message("       Total time for n=7, k=",j," & rep = 100: " ,round(difftime(time2,time1,units = "mins"),3)," minutes")
  
  outfn = paste0("../results/SimulationResults_n7_k",j,"_rep10000.RData")
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
SimulationResults_n7 = rbindlist(dumTab3)

SimulationResults_n7[,negRate := NR_check3_neg/NR_NotPhyloDec]
SimulationResults_n7[,posRate := NR_FAlg_pos/NR_PhyloDec]
SimulationResults_n7[NR_PhyloDec==0,posRate := NA]
SimulationResults_n7[NR_NotPhyloDec==0,negRate := NA]
save(SimulationResults_n7, file = "../results/SimulationResults_n7.RData")

SimulationResults_n7[NR_PhyloDec>0,]
#>      k    time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec     negRate
#>  1: 16  95.693          9991           0           9999           1 0.999199920
#>  2: 17  99.746          9890           0           9975          25 0.991478697
#>  3: 18 101.977          9468           0           9864         136 0.959854015
#>  4: 19 101.470          8214           0           9301         699 0.883130846
#>  5: 20  95.408          6689         883           8352        1648 0.800886015
#>  6: 21  88.207          4658        2554           6776        3224 0.687426210
#>  7: 22  80.135          2902        4429           5176        4824 0.560664606
#>  8: 23  71.571          1624        6019           3767        6233 0.431112291
#>  9: 24  64.471           775        7434           2484        7516 0.311996779
#> 10: 25  59.546           328        8385           1603        8397 0.204616344
#> 11: 26  53.908            88        9114            881        9119 0.099886493
#> 12: 27  50.366            40        9501            498        9502 0.080321285
#> 13: 28  46.615             2        9734            266        9734 0.007518797
#> 14: 29  43.302             0        9901             99        9901 0.000000000
#> 15: 30  40.138             0        9964             36        9964 0.000000000
#> 16: 31  37.670             0        9996              4        9996 0.000000000
#> 17: 32  36.275             0       10000              0       10000          NA
#> 18: 33  35.989             0       10000              0       10000          NA
#> 19: 34  35.732             0       10000              0       10000          NA
#>       posRate
#>  1: 0.0000000
#>  2: 0.0000000
#>  3: 0.0000000
#>  4: 0.0000000
#>  5: 0.5358010
#>  6: 0.7921836
#>  7: 0.9181177
#>  8: 0.9656666
#>  9: 0.9890899
#> 10: 0.9985709
#> 11: 0.9994517
#> 12: 0.9998948
#> 13: 1.0000000
#> 14: 1.0000000
#> 15: 1.0000000
#> 16: 1.0000000
#> 17: 1.0000000
#> 18: 1.0000000
#> 19: 1.0000000
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
#> [1] PhyloDecR_0.0.0.9007 doMC_1.3.7           iterators_1.0.13    
#> [4] foreach_1.5.1        data.table_1.14.2    rmarkdown_2.11      
#> [7] here_1.0.1          
#> 
#> loaded via a namespace (and not attached):
#>  [1] codetools_0.2-18 digest_0.6.29    rprojroot_2.0.2  magrittr_2.0.1  
#>  [5] evaluate_0.14    highr_0.9        rlang_0.4.12     stringi_1.7.6   
#>  [9] tools_4.1.0      stringr_1.4.0    xfun_0.29        yaml_2.2.1      
#> [13] fastmap_1.1.0    compiler_4.1.0   htmltools_0.5.2  knitr_1.37
message("\nTOTAL TIME : " ,round(difftime(Sys.time(),time0,units = "mins"),3)," minutes")
#> 
#> TOTAL TIME : 464.952 minutes
```
