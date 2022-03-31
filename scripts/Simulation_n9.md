
<!-- Simulation_n9.md is generated from Simulation_n9.Rmd. Please edit that file -->

# Introduction

<!-- badges: start -->

<!-- badges: end -->

I want to run a simulation for n=9 taxa. There are 126 possible
quadruples with n=9 taxa, and I want to test all possible combinations
for k out of 126 quadruples for phylogenetic decisiveness.

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

In *myTab\_n9*, there are all possible Four-way-partitions (4WP) given
n=9 taxa.

In *quadruple\_data*, there are all possible quadruples given n=9 taxa.

``` r
test1 = createInput(fn="../testData/S9_Decisive.txt",sepSym = "_")
#> Input contains 7 trees with 9 different taxa. The biggest tree has 8 taxa.
quadruple_data = test1$data
quadruple_data[,status:=NA]
max_quad = dim(quadruple_data)[1]-1

load("../partitions/partitions_n9.RData")
```

# Test loop with 100 repeats

To test my simulation loop, I run it with only 100 repeats (should be
rather fast).

``` r
time3 = Sys.time()
dumTab2 = foreach(j=1:max_quad)%do%{
  # j=10
  message("\nWorking on n=9, k=",j," & rep = 100 ... ")
  time1 = Sys.time()
  myTest = mySimulationFunction(number_taxa = 9, 
                                number_quads = j,
                                repeats = 100,
                                data1 = quadruple_data,
                                data2 = myTab_n9,
                                verbose = F)
  time2 = Sys.time()
  x0 = as.numeric(round(difftime(time2,time1,units = "mins"),3))
  message("       Total time for n=9, k=",j," & rep = 100: " ,round(difftime(time2,time1,units = "mins"),3)," minutes")
  
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
#> Working on n=9, k=1 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 126 combinations
#>        Total time for n=9, k=1 & rep = 100: 0.906 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=2 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 7875 combinations
#>        Total time for n=9, k=2 & rep = 100: 1.055 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=3 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 325500 combinations
#>        Total time for n=9, k=3 & rep = 100: 1.207 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=4 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 10009125 combinations
#>        Total time for n=9, k=4 & rep = 100: 1.324 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=5 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 244222650 combinations
#>        Total time for n=9, k=5 & rep = 100: 1.425 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=6 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4925156775 combinations
#>        Total time for n=9, k=6 & rep = 100: 1.523 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=7 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 84431259000 combinations
#>        Total time for n=9, k=7 & rep = 100: 1.608 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=8 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1255914977625 combinations
#>        Total time for n=9, k=8 & rep = 100: 1.691 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=9 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 16466440817750 combinations
#>        Total time for n=9, k=9 & rep = 100: 1.758 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=10 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 192657357567675 combinations
#>        Total time for n=9, k=10 & rep = 100: 1.838 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=11 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2031659407077300 combinations
#>        Total time for n=9, k=11 & rep = 100: 1.948 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=12 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 19470069317824128 combinations
#>        Total time for n=9, k=12 & rep = 100: 1.963 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=13 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 170737530940919296 combinations
#>        Total time for n=9, k=13 & rep = 100: 2.016 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=14 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1378095785451705600 combinations
#>        Total time for n=9, k=14 & rep = 100: 2.112 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=15 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 10289781864706068480 combinations
#>        Total time for n=9, k=15 & rep = 100: 2.154 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=16 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 71385361686398353408 combinations
#>        Total time for n=9, k=16 & rep = 100: 2.216 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=17 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.61905281500225e+20 combinations
#>        Total time for n=9, k=17 & rep = 100: 2.249 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=18 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.79709309352914e+21 combinations
#>        Total time for n=9, k=18 & rep = 100: 2.341 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=19 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.58992660053235e+22 combinations
#>        Total time for n=9, k=19 & rep = 100: 2.389 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=20 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 8.50610731284808e+22 combinations
#>        Total time for n=9, k=20 & rep = 100: 2.592 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=21 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.29355892934236e+23 combinations
#>        Total time for n=9, k=21 & rep = 100: 2.57 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=22 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.0491985799134e+24 combinations
#>        Total time for n=9, k=22 & rep = 100: 2.672 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=23 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 9.26594140482581e+24 combinations
#>        Total time for n=9, k=23 & rep = 100: 2.813 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=24 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 3.97663318623775e+25 combinations
#>        Total time for n=9, k=24 & rep = 100: 2.996 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=25 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.622466339985e+26 combinations
#>        Total time for n=9, k=25 & rep = 100: 2.93 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=26 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6.30265770532635e+26 combinations
#>        Total time for n=9, k=26 & rep = 100: 3.092 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=27 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.33431766863939e+27 combinations
#>        Total time for n=9, k=27 & rep = 100: 3.233 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=28 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 8.25348032840355e+27 combinations
#>        Total time for n=9, k=28 & rep = 100: 3.343 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=29 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.78910714546051e+28 combinations
#>        Total time for n=9, k=29 & rep = 100: 3.443 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=30 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 9.01811310365565e+28 combinations
#>        Total time for n=9, k=30 & rep = 100: 3.556 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=31 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.79270599339011e+29 combinations
#>        Total time for n=9, k=31 & rep = 100: 3.871 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=32 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 8.29084591787702e+29 combinations
#>        Total time for n=9, k=32 & rep = 100: 3.933 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=33 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.36163489781951e+30 combinations
#>        Total time for n=9, k=33 & rep = 100: 3.904 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=34 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6.4597660440357e+30 combinations
#>        Total time for n=9, k=34 & rep = 100: 4.05 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=35 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.69799564586081e+31 combinations
#>        Total time for n=9, k=35 & rep = 100: 4.265 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=36 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.29215566037039e+31 combinations
#>        Total time for n=9, k=36 & rep = 100: 4.494 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=37 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.04403786333334e+32 combinations
#>        Total time for n=9, k=37 & rep = 100: 4.368 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=38 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.44524657464913e+32 combinations
#>        Total time for n=9, k=38 & rep = 100: 4.588 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=39 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 5.51747945049032e+32 combinations
#>        Total time for n=9, k=39 & rep = 100: 4.722 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=40 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.20005178048167e+33 combinations
#>        Total time for n=9, k=40 & rep = 100: 5.01 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=41 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.51718178344935e+33 combinations
#>        Total time for n=9, k=41 & rep = 100: 5.028 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=42 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 5.09429646650455e+33 combinations
#>        Total time for n=9, k=42 & rep = 100: 5.214 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=43 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 9.95164891131125e+33 combinations
#>        Total time for n=9, k=43 & rep = 100: 5.282 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=44 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.87724286281556e+34 combinations
#>        Total time for n=9, k=44 & rep = 100: 5.504 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=45 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 3.42075366113052e+34 combinations
#>        Total time for n=9, k=45 & rep = 100: 5.825 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=46 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6.02350101199075e+34 combinations
#>        Total time for n=9, k=46 & rep = 100: 6.005 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=47 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.02527676799842e+35 combinations
#>        Total time for n=9, k=47 & rep = 100: 6.129 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=48 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.68743468066407e+35 combinations
#>        Total time for n=9, k=48 & rep = 100: 6.141 minutes
#>        There were 99 of 100 sets identified by my initial check as not decisive (99%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=49 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.68612051207747e+35 combinations
#>        Total time for n=9, k=49 & rep = 100: 6.257 minutes
#>        There were 98 of 100 sets identified by my initial check as not decisive (98%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=50 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.13662558859935e+35 combinations
#>        Total time for n=9, k=50 & rep = 100: 6.303 minutes
#>        There were 96 of 100 sets identified by my initial check as not decisive (96%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=51 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6.16438323006961e+35 combinations
#>        Total time for n=9, k=51 & rep = 100: 6.388 minutes
#>        There were 94 of 100 sets identified by my initial check as not decisive (94%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=52 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 8.890937351062e+35 combinations
#>        Total time for n=9, k=52 & rep = 100: 6.385 minutes
#>        There were 91 of 99 sets identified by my initial check as not decisive (91.92%)
#>        There were 0 of 1 sets identified by Fischers algorith as decisive (0%)
#> 
#> Working on n=9, k=53 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.24137615845016e+36 combinations
#>        Total time for n=9, k=53 & rep = 100: 6.405 minutes
#>        There were 87 of 99 sets identified by my initial check as not decisive (87.88%)
#>        There were 0 of 1 sets identified by Fischers algorith as decisive (0%)
#> 
#> Working on n=9, k=54 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.67815665864561e+36 combinations
#>        Total time for n=9, k=54 & rep = 100: 6.509 minutes
#>        There were 74 of 100 sets identified by my initial check as not decisive (74%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=55 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.19685962586328e+36 combinations
#>        Total time for n=9, k=55 & rep = 100: 6.394 minutes
#>        There were 80 of 100 sets identified by my initial check as not decisive (80%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=9, k=56 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.78530416850525e+36 combinations
#>        Total time for n=9, k=56 & rep = 100: 6.377 minutes
#>        There were 62 of 99 sets identified by my initial check as not decisive (62.63%)
#>        There were 0 of 1 sets identified by Fischers algorith as decisive (0%)
#> 
#> Working on n=9, k=57 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 3.42054897886612e+36 combinations
#>        Total time for n=9, k=57 & rep = 100: 6.189 minutes
#>        There were 60 of 93 sets identified by my initial check as not decisive (64.52%)
#>        There were 1 of 7 sets identified by Fischers algorith as decisive (14.29%)
#> 
#> Working on n=9, k=58 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.06927378520275e+36 combinations
#>        Total time for n=9, k=58 & rep = 100: 6.028 minutes
#>        There were 54 of 96 sets identified by my initial check as not decisive (56.25%)
#>        There were 0 of 4 sets identified by Fischers algorith as decisive (0%)
#> 
#> Working on n=9, k=59 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.69001046430148e+36 combinations
#>        Total time for n=9, k=59 & rep = 100: 5.771 minutes
#>        There were 46 of 94 sets identified by my initial check as not decisive (48.94%)
#>        There were 2 of 6 sets identified by Fischers algorith as decisive (33.33%)
#> 
#> Working on n=9, k=60 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 5.23717835180331e+36 combinations
#>        Total time for n=9, k=60 & rep = 100: 5.716 minutes
#>        There were 39 of 92 sets identified by my initial check as not decisive (42.39%)
#>        There were 4 of 8 sets identified by Fischers algorith as decisive (50%)
#> 
#> Working on n=9, k=61 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 5.66645526588558e+36 combinations
#>        Total time for n=9, k=61 & rep = 100: 5.452 minutes
#>        There were 40 of 90 sets identified by my initial check as not decisive (44.44%)
#>        There were 5 of 10 sets identified by Fischers algorith as decisive (50%)
#> 
#> Working on n=9, k=62 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 5.94063858520265e+36 combinations
#>        Total time for n=9, k=62 & rep = 100: 5.296 minutes
#>        There were 24 of 80 sets identified by my initial check as not decisive (30%)
#>        There were 14 of 20 sets identified by Fischers algorith as decisive (70%)
#> 
#> Working on n=9, k=63 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6.03493443576138e+36 combinations
#>        Total time for n=9, k=63 & rep = 100: 5.254 minutes
#>        There were 29 of 82 sets identified by my initial check as not decisive (35.37%)
#>        There were 13 of 18 sets identified by Fischers algorith as decisive (72.22%)
#> 
#> Working on n=9, k=64 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 5.94063858520265e+36 combinations
#>        Total time for n=9, k=64 & rep = 100: 5.133 minutes
#>        There were 24 of 80 sets identified by my initial check as not decisive (30%)
#>        There were 15 of 20 sets identified by Fischers algorith as decisive (75%)
#> 
#> Working on n=9, k=65 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 5.66645526588558e+36 combinations
#>        Total time for n=9, k=65 & rep = 100: 4.97 minutes
#>        There were 20 of 74 sets identified by my initial check as not decisive (27.03%)
#>        There were 24 of 26 sets identified by Fischers algorith as decisive (92.31%)
#> 
#> Working on n=9, k=66 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 5.23717835180331e+36 combinations
#>        Total time for n=9, k=66 & rep = 100: 4.85 minutes
#>        There were 16 of 64 sets identified by my initial check as not decisive (25%)
#>        There were 33 of 36 sets identified by Fischers algorith as decisive (91.67%)
#> 
#> Working on n=9, k=67 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.69001046430148e+36 combinations
#>        Total time for n=9, k=67 & rep = 100: 4.846 minutes
#>        There were 8 of 59 sets identified by my initial check as not decisive (13.56%)
#>        There were 38 of 41 sets identified by Fischers algorith as decisive (92.68%)
#> 
#> Working on n=9, k=68 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.06927378520275e+36 combinations
#>        Total time for n=9, k=68 & rep = 100: 4.76 minutes
#>        There were 9 of 59 sets identified by my initial check as not decisive (15.25%)
#>        There were 37 of 41 sets identified by Fischers algorith as decisive (90.24%)
#> 
#> Working on n=9, k=69 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 3.42054897886612e+36 combinations
#>        Total time for n=9, k=69 & rep = 100: 4.747 minutes
#>        There were 8 of 60 sets identified by my initial check as not decisive (13.33%)
#>        There were 39 of 40 sets identified by Fischers algorith as decisive (97.5%)
#> 
#> Working on n=9, k=70 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.78530416850525e+36 combinations
#>        Total time for n=9, k=70 & rep = 100: 4.693 minutes
#>        There were 9 of 65 sets identified by my initial check as not decisive (13.85%)
#>        There were 34 of 35 sets identified by Fischers algorith as decisive (97.14%)
#> 
#> Working on n=9, k=71 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.19685962586328e+36 combinations
#>        Total time for n=9, k=71 & rep = 100: 4.604 minutes
#>        There were 3 of 49 sets identified by my initial check as not decisive (6.12%)
#>        There were 48 of 51 sets identified by Fischers algorith as decisive (94.12%)
#> 
#> Working on n=9, k=72 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.67815665864561e+36 combinations
#>        Total time for n=9, k=72 & rep = 100: 4.572 minutes
#>        There were 2 of 44 sets identified by my initial check as not decisive (4.55%)
#>        There were 55 of 56 sets identified by Fischers algorith as decisive (98.21%)
#> 
#> Working on n=9, k=73 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.24137615845016e+36 combinations
#>        Total time for n=9, k=73 & rep = 100: 4.587 minutes
#>        There were 1 of 47 sets identified by my initial check as not decisive (2.13%)
#>        There were 53 of 53 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=74 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 8.890937351062e+35 combinations
#>        Total time for n=9, k=74 & rep = 100: 4.867 minutes
#>        There were 1 of 32 sets identified by my initial check as not decisive (3.12%)
#>        There were 68 of 68 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=75 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6.16438323006961e+35 combinations
#>        Total time for n=9, k=75 & rep = 100: 4.428 minutes
#>        There were 2 of 29 sets identified by my initial check as not decisive (6.9%)
#>        There were 70 of 71 sets identified by Fischers algorith as decisive (98.59%)
#> 
#> Working on n=9, k=76 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.13662558859935e+35 combinations
#>        Total time for n=9, k=76 & rep = 100: 4.419 minutes
#>        There were 2 of 34 sets identified by my initial check as not decisive (5.88%)
#>        There were 66 of 66 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=77 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.68612051207747e+35 combinations
#>        Total time for n=9, k=77 & rep = 100: 4.367 minutes
#>        There were 1 of 15 sets identified by my initial check as not decisive (6.67%)
#>        There were 84 of 85 sets identified by Fischers algorith as decisive (98.82%)
#> 
#> Working on n=9, k=78 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.68743468066407e+35 combinations
#>        Total time for n=9, k=78 & rep = 100: 4.403 minutes
#>        There were 1 of 25 sets identified by my initial check as not decisive (4%)
#>        There were 75 of 75 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=79 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.02527676799842e+35 combinations
#>        Total time for n=9, k=79 & rep = 100: 4.381 minutes
#>        There were 0 of 17 sets identified by my initial check as not decisive (0%)
#>        There were 83 of 83 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=80 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6.02350101199075e+34 combinations
#>        Total time for n=9, k=80 & rep = 100: 4.368 minutes
#>        There were 1 of 18 sets identified by my initial check as not decisive (5.56%)
#>        There were 81 of 82 sets identified by Fischers algorith as decisive (98.78%)
#> 
#> Working on n=9, k=81 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 3.42075366113052e+34 combinations
#>        Total time for n=9, k=81 & rep = 100: 4.349 minutes
#>        There were 0 of 8 sets identified by my initial check as not decisive (0%)
#>        There were 92 of 92 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=82 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.87724286281556e+34 combinations
#>        Total time for n=9, k=82 & rep = 100: 4.361 minutes
#>        There were 1 of 9 sets identified by my initial check as not decisive (11.11%)
#>        There were 90 of 91 sets identified by Fischers algorith as decisive (98.9%)
#> 
#> Working on n=9, k=83 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 9.95164891131125e+33 combinations
#>        Total time for n=9, k=83 & rep = 100: 4.34 minutes
#>        There were 0 of 6 sets identified by my initial check as not decisive (0%)
#>        There were 94 of 94 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=84 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 5.09429646650455e+33 combinations
#>        Total time for n=9, k=84 & rep = 100: 4.383 minutes
#>        There were 0 of 11 sets identified by my initial check as not decisive (0%)
#>        There were 89 of 89 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=85 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.51718178344935e+33 combinations
#>        Total time for n=9, k=85 & rep = 100: 4.399 minutes
#>        There were 0 of 8 sets identified by my initial check as not decisive (0%)
#>        There were 92 of 92 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=86 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.20005178048167e+33 combinations
#>        Total time for n=9, k=86 & rep = 100: 4.403 minutes
#>        There were 0 of 9 sets identified by my initial check as not decisive (0%)
#>        There were 91 of 91 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=87 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 5.51747945049032e+32 combinations
#>        Total time for n=9, k=87 & rep = 100: 4.434 minutes
#>        There were 0 of 7 sets identified by my initial check as not decisive (0%)
#>        There were 92 of 93 sets identified by Fischers algorith as decisive (98.92%)
#> 
#> Working on n=9, k=88 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.44524657464913e+32 combinations
#>        Total time for n=9, k=88 & rep = 100: 4.429 minutes
#>        There were 0 of 8 sets identified by my initial check as not decisive (0%)
#>        There were 92 of 92 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=89 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.04403786333334e+32 combinations
#>        Total time for n=9, k=89 & rep = 100: 4.421 minutes
#>        There were 0 of 3 sets identified by my initial check as not decisive (0%)
#>        There were 97 of 97 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=90 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.29215566037039e+31 combinations
#>        Total time for n=9, k=90 & rep = 100: 4.459 minutes
#>        There were 0 of 3 sets identified by my initial check as not decisive (0%)
#>        There were 97 of 97 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=91 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.69799564586081e+31 combinations
#>        Total time for n=9, k=91 & rep = 100: 4.473 minutes
#>        There were 0 of 6 sets identified by my initial check as not decisive (0%)
#>        There were 94 of 94 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=92 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6.4597660440357e+30 combinations
#>        Total time for n=9, k=92 & rep = 100: 4.482 minutes
#>        There were 0 of 3 sets identified by my initial check as not decisive (0%)
#>        There were 97 of 97 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=93 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.36163489781951e+30 combinations
#>        Total time for n=9, k=93 & rep = 100: 4.502 minutes
#>        There were 0 of 1 sets identified by my initial check as not decisive (0%)
#>        There were 99 of 99 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=94 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 8.29084591787702e+29 combinations
#>        Total time for n=9, k=94 & rep = 100: 4.529 minutes
#>        There were 0 of 5 sets identified by my initial check as not decisive (0%)
#>        There were 95 of 95 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=95 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.79270599339011e+29 combinations
#>        Total time for n=9, k=95 & rep = 100: 4.548 minutes
#>        There were 0 of 3 sets identified by my initial check as not decisive (0%)
#>        There were 97 of 97 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=96 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 9.01811310365565e+28 combinations
#>        Total time for n=9, k=96 & rep = 100: 4.577 minutes
#>        There were 0 of 1 sets identified by my initial check as not decisive (0%)
#>        There were 99 of 99 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=97 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.78910714546051e+28 combinations
#>        Total time for n=9, k=97 & rep = 100: 4.587 minutes
#>        There were 0 of 1 sets identified by my initial check as not decisive (0%)
#>        There were 99 of 99 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=98 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 8.25348032840355e+27 combinations
#>        Total time for n=9, k=98 & rep = 100: 4.623 minutes
#>        There were 0 of 1 sets identified by my initial check as not decisive (0%)
#>        There were 99 of 99 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=99 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.33431766863939e+27 combinations
#>        Total time for n=9, k=99 & rep = 100: 4.64 minutes
#>        There were 0 of 2 sets identified by my initial check as not decisive (0%)
#>        There were 98 of 98 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=100 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6.30265770532635e+26 combinations
#>        Total time for n=9, k=100 & rep = 100: 4.67 minutes
#>        There were 0 of 1 sets identified by my initial check as not decisive (0%)
#>        There were 99 of 99 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=101 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.622466339985e+26 combinations
#>        Total time for n=9, k=101 & rep = 100: 4.67 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=102 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 3.97663318623775e+25 combinations
#>        Total time for n=9, k=102 & rep = 100: 4.7 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=103 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 9.26594140482581e+24 combinations
#>        Total time for n=9, k=103 & rep = 100: 4.738 minutes
#>        There were 0 of 1 sets identified by my initial check as not decisive (0%)
#>        There were 99 of 99 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=104 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.0491985799134e+24 combinations
#>        Total time for n=9, k=104 & rep = 100: 4.736 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=105 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.29355892934236e+23 combinations
#>        Total time for n=9, k=105 & rep = 100: 4.763 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=106 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 8.50610731284808e+22 combinations
#>        Total time for n=9, k=106 & rep = 100: 4.792 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=107 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.58992660053235e+22 combinations
#>        Total time for n=9, k=107 & rep = 100: 4.818 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=108 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2.79709309352914e+21 combinations
#>        Total time for n=9, k=108 & rep = 100: 4.83 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=109 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4.61905281500225e+20 combinations
#>        Total time for n=9, k=109 & rep = 100: 4.848 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=110 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 71385361686398353408 combinations
#>        Total time for n=9, k=110 & rep = 100: 4.898 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=111 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 10289781864706068480 combinations
#>        Total time for n=9, k=111 & rep = 100: 4.9 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=112 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1378095785451705600 combinations
#>        Total time for n=9, k=112 & rep = 100: 4.933 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=113 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 170737530940919296 combinations
#>        Total time for n=9, k=113 & rep = 100: 4.958 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=114 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 19470069317824128 combinations
#>        Total time for n=9, k=114 & rep = 100: 5.028 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=115 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2031659407077300 combinations
#>        Total time for n=9, k=115 & rep = 100: 5.019 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=116 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 192657357567675 combinations
#>        Total time for n=9, k=116 & rep = 100: 5.055 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=117 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 16466440817750 combinations
#>        Total time for n=9, k=117 & rep = 100: 5.067 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=118 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1255914977625 combinations
#>        Total time for n=9, k=118 & rep = 100: 5.101 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=119 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 84431259000 combinations
#>        Total time for n=9, k=119 & rep = 100: 5.133 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=120 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 4925156775 combinations
#>        Total time for n=9, k=120 & rep = 100: 5.154 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=121 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 244222650 combinations
#>        Total time for n=9, k=121 & rep = 100: 5.187 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=122 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 10009125 combinations
#>        Total time for n=9, k=122 & rep = 100: 5.578 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=123 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 325500 combinations
#>        Total time for n=9, k=123 & rep = 100: 5.254 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=124 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 7875 combinations
#>        Total time for n=9, k=124 & rep = 100: 5.28 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=9, k=125 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 126 combinations
#>        Total time for n=9, k=125 & rep = 100: 5.303 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
dumTab2 = rbindlist(dumTab2)
message("\nTIME for test loop: " ,round(difftime(Sys.time(),time3,units = "hours"),3)," hours")
#> 
#> TIME for test loop: 8.99 hours

dumTab2[,negRate := NR_check3_neg/NR_NotPhyloDec]
dumTab2[,posRate := NR_FAlg_pos/NR_PhyloDec]
dumTab2[NR_PhyloDec==0,posRate := NA]
dumTab2[NR_NotPhyloDec==0,negRate := NA]
dumTab2[NR_PhyloDec>0,]
#>       k  time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec    negRate
#>  1:  52 6.385            91           0             99           1 0.91919192
#>  2:  53 6.405            87           0             99           1 0.87878788
#>  3:  56 6.377            62           0             99           1 0.62626263
#>  4:  57 6.189            60           1             93           7 0.64516129
#>  5:  58 6.028            54           0             96           4 0.56250000
#>  6:  59 5.771            46           2             94           6 0.48936170
#>  7:  60 5.716            39           4             92           8 0.42391304
#>  8:  61 5.452            40           5             90          10 0.44444444
#>  9:  62 5.296            24          14             80          20 0.30000000
#> 10:  63 5.254            29          13             82          18 0.35365854
#> 11:  64 5.133            24          15             80          20 0.30000000
#> 12:  65 4.970            20          24             74          26 0.27027027
#> 13:  66 4.850            16          33             64          36 0.25000000
#> 14:  67 4.846             8          38             59          41 0.13559322
#> 15:  68 4.760             9          37             59          41 0.15254237
#> 16:  69 4.747             8          39             60          40 0.13333333
#> 17:  70 4.693             9          34             65          35 0.13846154
#> 18:  71 4.604             3          48             49          51 0.06122449
#> 19:  72 4.572             2          55             44          56 0.04545455
#> 20:  73 4.587             1          53             47          53 0.02127660
#> 21:  74 4.867             1          68             32          68 0.03125000
#> 22:  75 4.428             2          70             29          71 0.06896552
#> 23:  76 4.419             2          66             34          66 0.05882353
#> 24:  77 4.367             1          84             15          85 0.06666667
#> 25:  78 4.403             1          75             25          75 0.04000000
#> 26:  79 4.381             0          83             17          83 0.00000000
#> 27:  80 4.368             1          81             18          82 0.05555556
#> 28:  81 4.349             0          92              8          92 0.00000000
#> 29:  82 4.361             1          90              9          91 0.11111111
#> 30:  83 4.340             0          94              6          94 0.00000000
#> 31:  84 4.383             0          89             11          89 0.00000000
#> 32:  85 4.399             0          92              8          92 0.00000000
#> 33:  86 4.403             0          91              9          91 0.00000000
#> 34:  87 4.434             0          92              7          93 0.00000000
#> 35:  88 4.429             0          92              8          92 0.00000000
#> 36:  89 4.421             0          97              3          97 0.00000000
#> 37:  90 4.459             0          97              3          97 0.00000000
#> 38:  91 4.473             0          94              6          94 0.00000000
#> 39:  92 4.482             0          97              3          97 0.00000000
#> 40:  93 4.502             0          99              1          99 0.00000000
#> 41:  94 4.529             0          95              5          95 0.00000000
#> 42:  95 4.548             0          97              3          97 0.00000000
#> 43:  96 4.577             0          99              1          99 0.00000000
#> 44:  97 4.587             0          99              1          99 0.00000000
#> 45:  98 4.623             0          99              1          99 0.00000000
#> 46:  99 4.640             0          98              2          98 0.00000000
#> 47: 100 4.670             0          99              1          99 0.00000000
#> 48: 101 4.670             0         100              0         100         NA
#> 49: 102 4.700             0         100              0         100         NA
#> 50: 103 4.738             0          99              1          99 0.00000000
#> 51: 104 4.736             0         100              0         100         NA
#> 52: 105 4.763             0         100              0         100         NA
#> 53: 106 4.792             0         100              0         100         NA
#> 54: 107 4.818             0         100              0         100         NA
#> 55: 108 4.830             0         100              0         100         NA
#> 56: 109 4.848             0         100              0         100         NA
#> 57: 110 4.898             0         100              0         100         NA
#> 58: 111 4.900             0         100              0         100         NA
#> 59: 112 4.933             0         100              0         100         NA
#> 60: 113 4.958             0         100              0         100         NA
#> 61: 114 5.028             0         100              0         100         NA
#> 62: 115 5.019             0         100              0         100         NA
#> 63: 116 5.055             0         100              0         100         NA
#> 64: 117 5.067             0         100              0         100         NA
#> 65: 118 5.101             0         100              0         100         NA
#> 66: 119 5.133             0         100              0         100         NA
#> 67: 120 5.154             0         100              0         100         NA
#> 68: 121 5.187             0         100              0         100         NA
#> 69: 122 5.578             0         100              0         100         NA
#> 70: 123 5.254             0         100              0         100         NA
#> 71: 124 5.280             0         100              0         100         NA
#> 72: 125 5.303             0         100              0         100         NA
#>       k  time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec    negRate
#>       posRate
#>  1: 0.0000000
#>  2: 0.0000000
#>  3: 0.0000000
#>  4: 0.1428571
#>  5: 0.0000000
#>  6: 0.3333333
#>  7: 0.5000000
#>  8: 0.5000000
#>  9: 0.7000000
#> 10: 0.7222222
#> 11: 0.7500000
#> 12: 0.9230769
#> 13: 0.9166667
#> 14: 0.9268293
#> 15: 0.9024390
#> 16: 0.9750000
#> 17: 0.9714286
#> 18: 0.9411765
#> 19: 0.9821429
#> 20: 1.0000000
#> 21: 1.0000000
#> 22: 0.9859155
#> 23: 1.0000000
#> 24: 0.9882353
#> 25: 1.0000000
#> 26: 1.0000000
#> 27: 0.9878049
#> 28: 1.0000000
#> 29: 0.9890110
#> 30: 1.0000000
#> 31: 1.0000000
#> 32: 1.0000000
#> 33: 1.0000000
#> 34: 0.9892473
#> 35: 1.0000000
#> 36: 1.0000000
#> 37: 1.0000000
#> 38: 1.0000000
#> 39: 1.0000000
#> 40: 1.0000000
#> 41: 1.0000000
#> 42: 1.0000000
#> 43: 1.0000000
#> 44: 1.0000000
#> 45: 1.0000000
#> 46: 1.0000000
#> 47: 1.0000000
#> 48: 1.0000000
#> 49: 1.0000000
#> 50: 1.0000000
#> 51: 1.0000000
#> 52: 1.0000000
#> 53: 1.0000000
#> 54: 1.0000000
#> 55: 1.0000000
#> 56: 1.0000000
#> 57: 1.0000000
#> 58: 1.0000000
#> 59: 1.0000000
#> 60: 1.0000000
#> 61: 1.0000000
#> 62: 1.0000000
#> 63: 1.0000000
#> 64: 1.0000000
#> 65: 1.0000000
#> 66: 1.0000000
#> 67: 1.0000000
#> 68: 1.0000000
#> 69: 1.0000000
#> 70: 1.0000000
#> 71: 1.0000000
#> 72: 1.0000000
#>       posRate
```

# Loop with 10,000 repeats

``` r
time4 = Sys.time()

registerDoMC(cores=10)

dumTab3 = foreach(j=1:max_quad)%dopar%{
  # j=10
  message("\nWorking on n=9, k=",j," & rep = max 10,000 ... ")
  time1 = Sys.time()
  myTest = mySimulationFunction(number_taxa = 9, 
                                number_quads = j,
                                repeats = 10000,
                                data1 = quadruple_data,
                                data2 = myTab_n9,
                                verbose = F)
  
  time2 = Sys.time()
  x0 = as.numeric(round(difftime(time2,time1,units = "mins"),3))
  message("       Total time for n=9, k=",j," & rep = 100: " ,round(difftime(time2,time1,units = "mins"),3)," minutes")
  
  outfn = paste0("../results/SimulationResults_n9_k",j,"_rep10000.RData")
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
SimulationResults_n9 = rbindlist(dumTab3)
message("\nTIME for simulation loop: " ,round(difftime(Sys.time(),time4,units = "hours"),3)," hours")
#> 
#> TIME for simulation loop: 94.483 hours

SimulationResults_n9[,negRate := NR_check3_neg/NR_NotPhyloDec]
SimulationResults_n9[,posRate := NR_FAlg_pos/NR_PhyloDec]
SimulationResults_n9[NR_PhyloDec==0,posRate := NA]
SimulationResults_n9[NR_NotPhyloDec==0,negRate := NA]
save(SimulationResults_n9, file = "../results/SimulationResults_n9.RData")

SimulationResults_n9[NR_PhyloDec>0,]
#>       k    time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec
#>  1:  48 616.291          9918           0           9999           1
#>  2:  49 628.194          9809           0           9998           2
#>  3:  50 639.739          9647           0           9998           2
#>  4:  51 642.008          9370           0           9991           9
#>  5:  52 647.685          9040           0           9986          14
#>  6:  53 647.660          8593           0           9947          53
#>  7:  54 648.140          8082           0           9915          85
#>  8:  55 644.100          7437           0           9899         101
#>  9:  56 630.087          6813          10           9804         196
#> 10:  57 613.553          6151          42           9666         334
#> 11:  58 595.369          5370         113           9511         489
#> 12:  59 576.077          4815         265           9320         680
#> 13:  60 563.377          4058         437           9125         875
#> 14:  61 542.724          3483         744           8785        1215
#> 15:  62 533.176          2976        1040           8523        1477
#> 16:  63 519.982          2379        1482           8077        1923
#> 17:  64 512.586          1981        1975           7615        2385
#> 18:  65 499.403          1582        2367           7281        2719
#> 19:  66 492.584          1301        2897           6799        3201
#> 20:  67 488.626          1055        3381           6342        3658
#> 21:  68 479.794           867        3831           5960        4040
#> 22:  69 473.119           641        4407           5431        4569
#> 23:  70 469.162           480        4851           4989        5011
#> 24:  71 462.217           400        5392           4488        5512
#> 25:  72 459.110           257        5734           4184        5816
#> 26:  73 455.893           201        6239           3699        6301
#> 27:  74 453.329           153        6568           3377        6623
#> 28:  75 452.773           129        6918           3041        6959
#> 29:  76 450.404            81        7291           2678        7322
#> 30:  77 448.174            55        7651           2322        7678
#> 31:  78 446.969            49        7898           2085        7915
#> 32:  79 446.126            42        8132           1857        8143
#> 33:  80 445.331            22        8413           1577        8423
#> 34:  81 442.455            19        8624           1369        8631
#> 35:  82 442.229             6        8769           1230        8770
#> 36:  83 443.064             6        8938           1061        8939
#> 37:  84 443.102             4        9167            832        9168
#> 38:  85 444.782             3        9225            773        9227
#> 39:  86 445.224             1        9300            699        9301
#> 40:  87 447.520             1        9458            540        9460
#> 41:  88 448.282             0        9521            478        9522
#> 42:  89 449.686             0        9613            387        9613
#> 43:  90 451.656             0        9629            371        9629
#> 44:  91 453.444             0        9704            295        9705
#> 45:  92 455.326             0        9778            222        9778
#> 46:  93 457.013             0        9800            200        9800
#> 47:  94 458.339             0        9848            152        9848
#> 48:  95 460.408             0        9867            133        9867
#> 49:  96 462.429             0        9913             87        9913
#> 50:  97 466.100             0        9921             79        9921
#> 51:  98 468.195             0        9939             61        9939
#> 52:  99 470.440             0        9935             65        9935
#> 53: 100 472.533             0        9963             37        9963
#> 54: 101 473.611             0        9968             32        9968
#> 55: 102 473.926             0        9990             10        9990
#> 56: 103 477.041             0        9979             21        9979
#> 57: 104 478.335             0        9993              7        9993
#> 58: 105 481.726             0        9989             11        9989
#> 59: 106 483.260             0        9994              6        9994
#> 60: 107 486.202             0        9996              4        9996
#> 61: 108 489.006             0        9997              3        9997
#> 62: 109 489.380             0        9999              1        9999
#> 63: 110 494.618             0        9998              2        9998
#> 64: 111 495.871             0       10000              0       10000
#> 65: 112 498.165             0        9999              1        9999
#> 66: 113 500.323             0        9999              1        9999
#> 67: 114 503.896             0       10000              0       10000
#> 68: 115 506.987             0       10000              0       10000
#> 69: 116 509.488             0       10000              0       10000
#> 70: 117 511.976             0       10000              0       10000
#> 71: 118 514.680             0       10000              0       10000
#> 72: 119 517.789             0       10000              0       10000
#> 73: 120 521.258             0       10000              0       10000
#> 74: 121 524.245             0       10000              0       10000
#> 75: 122 528.026             0       10000              0       10000
#> 76: 123 535.033             0       10000              0       10000
#> 77: 124 533.570             0       10000              0       10000
#> 78: 125 534.810             0       10000              0       10000
#>       k    time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec
#>         negRate    posRate
#>  1: 0.991899190 0.00000000
#>  2: 0.981096219 0.00000000
#>  3: 0.964892979 0.00000000
#>  4: 0.937844060 0.00000000
#>  5: 0.905267374 0.00000000
#>  6: 0.863878556 0.00000000
#>  7: 0.815128593 0.00000000
#>  8: 0.751288009 0.00000000
#>  9: 0.694920441 0.05102041
#> 10: 0.636354231 0.12574850
#> 11: 0.564609400 0.23108384
#> 12: 0.516630901 0.38970588
#> 13: 0.444712329 0.49942857
#> 14: 0.396471258 0.61234568
#> 15: 0.349172826 0.70412999
#> 16: 0.294540052 0.77067083
#> 17: 0.260144452 0.82809224
#> 18: 0.217277846 0.87054064
#> 19: 0.191351669 0.90502968
#> 20: 0.166351309 0.92427556
#> 21: 0.145469799 0.94826733
#> 22: 0.118026146 0.96454366
#> 23: 0.096211666 0.96807025
#> 24: 0.089126560 0.97822932
#> 25: 0.061424474 0.98590096
#> 26: 0.054339011 0.99016029
#> 27: 0.045306485 0.99169561
#> 28: 0.042420256 0.99410835
#> 29: 0.030246453 0.99576618
#> 30: 0.023686477 0.99648346
#> 31: 0.023501199 0.99785218
#> 32: 0.022617124 0.99864915
#> 33: 0.013950539 0.99881277
#> 34: 0.013878744 0.99918897
#> 35: 0.004878049 0.99988597
#> 36: 0.005655042 0.99988813
#> 37: 0.004807692 0.99989092
#> 38: 0.003880983 0.99978324
#> 39: 0.001430615 0.99989248
#> 40: 0.001851852 0.99978858
#> 41: 0.000000000 0.99989498
#> 42: 0.000000000 1.00000000
#> 43: 0.000000000 1.00000000
#> 44: 0.000000000 0.99989696
#> 45: 0.000000000 1.00000000
#> 46: 0.000000000 1.00000000
#> 47: 0.000000000 1.00000000
#> 48: 0.000000000 1.00000000
#> 49: 0.000000000 1.00000000
#> 50: 0.000000000 1.00000000
#> 51: 0.000000000 1.00000000
#> 52: 0.000000000 1.00000000
#> 53: 0.000000000 1.00000000
#> 54: 0.000000000 1.00000000
#> 55: 0.000000000 1.00000000
#> 56: 0.000000000 1.00000000
#> 57: 0.000000000 1.00000000
#> 58: 0.000000000 1.00000000
#> 59: 0.000000000 1.00000000
#> 60: 0.000000000 1.00000000
#> 61: 0.000000000 1.00000000
#> 62: 0.000000000 1.00000000
#> 63: 0.000000000 1.00000000
#> 64:          NA 1.00000000
#> 65: 0.000000000 1.00000000
#> 66: 0.000000000 1.00000000
#> 67:          NA 1.00000000
#> 68:          NA 1.00000000
#> 69:          NA 1.00000000
#> 70:          NA 1.00000000
#> 71:          NA 1.00000000
#> 72:          NA 1.00000000
#> 73:          NA 1.00000000
#> 74:          NA 1.00000000
#> 75:          NA 1.00000000
#> 76:          NA 1.00000000
#> 77:          NA 1.00000000
#> 78:          NA 1.00000000
#>         negRate    posRate
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
#>  [5] evaluate_0.14    rlang_0.4.12     stringi_1.7.6    tools_4.1.0     
#>  [9] stringr_1.4.0    xfun_0.29        yaml_2.2.1       fastmap_1.1.0   
#> [13] compiler_4.1.0   htmltools_0.5.2  knitr_1.37
message("\nTOTAL TIME : " ,round(difftime(Sys.time(),time0,units = "hours"),3)," hours")
#> 
#> TOTAL TIME : 103.473 hours
```
