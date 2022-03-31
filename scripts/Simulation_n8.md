
<!-- Simulation_n8.md is generated from Simulation_n8.Rmd. Please edit that file -->

# Introduction

<!-- badges: start -->

<!-- badges: end -->

I want to run a simulation for n=8 taxa. There are 70 possible
quadruples with n=8 taxa, and I want to test all possible combinations
for k out of 70 quadruples for phylogenetic decisiveness.

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

In *myTab\_n8*, there are all possible Four-way-partitions (4WP) given
n=8 taxa.

In *quadruple\_data*, there are all possible quadruples given n=8 taxa.

``` r
test1 = createInput(fn="../testData/S8_Decisive.txt",sepSym = "_")
#> Input contains 28 trees with 8 different taxa. The biggest tree has 4 taxa.
quadruple_data = test1$data
quadruple_data[,status:=NA]
max_quad = dim(quadruple_data)[1]-1

load("../partitions/partitions_n8.RData")
```

# Test loop with 100 repeats

To test my simulation loop, I run it with only 100 repeats (should be
rather fast).

``` r
dumTab2 = foreach(j=1:max_quad)%do%{
  # j=10
  message("\nWorking on n=8, k=",j," & rep = 100 ... ")
  time1 = Sys.time()
  myTest = mySimulationFunction(number_taxa = 8, 
                                number_quads = j,
                                repeats = 100,
                                data1 = quadruple_data,
                                data2 = myTab_n8,
                                verbose = F)
  time2 = Sys.time()
  x0 = as.numeric(round(difftime(time2,time1,units = "mins"),3))
  message("       Total time for n=8, k=",j," & rep = 100: " ,round(difftime(time2,time1,units = "mins"),3)," minutes")
  
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
#> Working on n=8, k=1 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 70 combinations
#>        Total time for n=8, k=1 & rep = 100: 0.589 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=2 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2415 combinations
#>        Total time for n=8, k=2 & rep = 100: 0.68 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=3 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 54740 combinations
#>        Total time for n=8, k=3 & rep = 100: 0.76 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=4 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 916895 combinations
#>        Total time for n=8, k=4 & rep = 100: 0.805 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=5 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 12103014 combinations
#>        Total time for n=8, k=5 & rep = 100: 0.854 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=6 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 131115985 combinations
#>        Total time for n=8, k=6 & rep = 100: 0.883 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=7 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1198774720 combinations
#>        Total time for n=8, k=7 & rep = 100: 0.921 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=8 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 9440350920 combinations
#>        Total time for n=8, k=8 & rep = 100: 0.929 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=9 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 65033528560 combinations
#>        Total time for n=8, k=9 & rep = 100: 0.979 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=10 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 396704524216 combinations
#>        Total time for n=8, k=10 & rep = 100: 0.988 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=11 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2163842859360 combinations
#>        Total time for n=8, k=11 & rep = 100: 1.035 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=12 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 10638894058520 combinations
#>        Total time for n=8, k=12 & rep = 100: 1.038 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=13 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 47465835030320 combinations
#>        Total time for n=8, k=13 & rep = 100: 1.118 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=14 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 193253756909160 combinations
#>        Total time for n=8, k=14 & rep = 100: 1.128 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=15 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 721480692460864 combinations
#>        Total time for n=8, k=15 & rep = 100: 1.161 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=16 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2480089880334220 combinations
#>        Total time for n=8, k=16 & rep = 100: 1.295 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=17 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 7877932561061640 combinations
#>        Total time for n=8, k=17 & rep = 100: 1.272 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=18 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 23196134763125940 combinations
#>        Total time for n=8, k=18 & rep = 100: 1.37 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=19 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 63484158299081520 combinations
#>        Total time for n=8, k=19 & rep = 100: 1.419 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=20 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 161884603662657856 combinations
#>        Total time for n=8, k=20 & rep = 100: 1.513 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=21 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 385439532530137728 combinations
#>        Total time for n=8, k=21 & rep = 100: 1.582 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=22 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 858478958817124864 combinations
#>        Total time for n=8, k=22 & rep = 100: 1.582 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=23 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1791608261879217152 combinations
#>        Total time for n=8, k=23 & rep = 100: 1.686 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=24 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 3508566179513466880 combinations
#>        Total time for n=8, k=24 & rep = 100: 1.792 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=25 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6455761770304779264 combinations
#>        Total time for n=8, k=25 & rep = 100: 1.923 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=26 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 11173433833219811328 combinations
#>        Total time for n=8, k=26 & rep = 100: 1.931 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=27 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 18208558839321174016 combinations
#>        Total time for n=8, k=27 & rep = 100: 2.104 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=28 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 27963143931814662144 combinations
#>        Total time for n=8, k=28 & rep = 100: 2.19 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=29 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 40498346384007438336 combinations
#>        Total time for n=8, k=29 & rep = 100: 2.184 minutes
#>        There were 100 of 100 sets identified by my initial check as not decisive (100%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=30 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 55347740058143899648 combinations
#>        Total time for n=8, k=30 & rep = 100: 2.205 minutes
#>        There were 99 of 100 sets identified by my initial check as not decisive (99%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=31 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 71416438784701202432 combinations
#>        Total time for n=8, k=31 & rep = 100: 2.266 minutes
#>        There were 96 of 100 sets identified by my initial check as not decisive (96%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=32 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 87038784768854769664 combinations
#>        Total time for n=8, k=32 & rep = 100: 2.392 minutes
#>        There were 87 of 100 sets identified by my initial check as not decisive (87%)
#>        There were 0 of 0 sets identified by Fischers algorith as decisive (NaN%)
#> 
#> Working on n=8, k=33 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.00226479430802e+20 combinations
#>        Total time for n=8, k=33 & rep = 100: 2.32 minutes
#>        There were 86 of 96 sets identified by my initial check as not decisive (89.58%)
#>        There were 0 of 4 sets identified by Fischers algorith as decisive (0%)
#> 
#> Working on n=8, k=34 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.09069992321756e+20 combinations
#>        Total time for n=8, k=34 & rep = 100: 2.252 minutes
#>        There were 86 of 98 sets identified by my initial check as not decisive (87.76%)
#>        There were 0 of 2 sets identified by Fischers algorith as decisive (0%)
#> 
#> Working on n=8, k=35 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.12186277816662e+20 combinations
#>        Total time for n=8, k=35 & rep = 100: 2.14 minutes
#>        There were 73 of 94 sets identified by my initial check as not decisive (77.66%)
#>        There were 0 of 6 sets identified by Fischers algorith as decisive (0%)
#> 
#> Working on n=8, k=36 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.09069992321756e+20 combinations
#>        Total time for n=8, k=36 & rep = 100: 2.125 minutes
#>        There were 54 of 91 sets identified by my initial check as not decisive (59.34%)
#>        There were 3 of 9 sets identified by Fischers algorith as decisive (33.33%)
#> 
#> Working on n=8, k=37 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1.00226479430802e+20 combinations
#>        Total time for n=8, k=37 & rep = 100: 1.97 minutes
#>        There were 43 of 88 sets identified by my initial check as not decisive (48.86%)
#>        There were 6 of 12 sets identified by Fischers algorith as decisive (50%)
#> 
#> Working on n=8, k=38 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 87038784768854769664 combinations
#>        Total time for n=8, k=38 & rep = 100: 1.876 minutes
#>        There were 37 of 83 sets identified by my initial check as not decisive (44.58%)
#>        There were 12 of 17 sets identified by Fischers algorith as decisive (70.59%)
#> 
#> Working on n=8, k=39 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 71416438784701202432 combinations
#>        Total time for n=8, k=39 & rep = 100: 1.698 minutes
#>        There were 29 of 71 sets identified by my initial check as not decisive (40.85%)
#>        There were 25 of 29 sets identified by Fischers algorith as decisive (86.21%)
#> 
#> Working on n=8, k=40 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 55347740058143899648 combinations
#>        Total time for n=8, k=40 & rep = 100: 1.604 minutes
#>        There were 20 of 59 sets identified by my initial check as not decisive (33.9%)
#>        There were 38 of 41 sets identified by Fischers algorith as decisive (92.68%)
#> 
#> Working on n=8, k=41 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 40498346384007438336 combinations
#>        Total time for n=8, k=41 & rep = 100: 1.529 minutes
#>        There were 25 of 56 sets identified by my initial check as not decisive (44.64%)
#>        There were 43 of 44 sets identified by Fischers algorith as decisive (97.73%)
#> 
#> Working on n=8, k=42 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 27963143931814662144 combinations
#>        Total time for n=8, k=42 & rep = 100: 1.441 minutes
#>        There were 15 of 40 sets identified by my initial check as not decisive (37.5%)
#>        There were 58 of 60 sets identified by Fischers algorith as decisive (96.67%)
#> 
#> Working on n=8, k=43 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 18208558839321174016 combinations
#>        Total time for n=8, k=43 & rep = 100: 1.367 minutes
#>        There were 6 of 37 sets identified by my initial check as not decisive (16.22%)
#>        There were 59 of 63 sets identified by Fischers algorith as decisive (93.65%)
#> 
#> Working on n=8, k=44 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 11173433833219811328 combinations
#>        Total time for n=8, k=44 & rep = 100: 1.299 minutes
#>        There were 3 of 29 sets identified by my initial check as not decisive (10.34%)
#>        There were 71 of 71 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=45 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 6455761770304779264 combinations
#>        Total time for n=8, k=45 & rep = 100: 1.247 minutes
#>        There were 0 of 17 sets identified by my initial check as not decisive (0%)
#>        There were 83 of 83 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=46 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 3508566179513466880 combinations
#>        Total time for n=8, k=46 & rep = 100: 1.219 minutes
#>        There were 2 of 25 sets identified by my initial check as not decisive (8%)
#>        There were 74 of 75 sets identified by Fischers algorith as decisive (98.67%)
#> 
#> Working on n=8, k=47 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1791608261879217152 combinations
#>        Total time for n=8, k=47 & rep = 100: 1.173 minutes
#>        There were 0 of 15 sets identified by my initial check as not decisive (0%)
#>        There were 84 of 85 sets identified by Fischers algorith as decisive (98.82%)
#> 
#> Working on n=8, k=48 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 858478958817124864 combinations
#>        Total time for n=8, k=48 & rep = 100: 1.141 minutes
#>        There were 1 of 15 sets identified by my initial check as not decisive (6.67%)
#>        There were 85 of 85 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=49 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 385439532530137728 combinations
#>        Total time for n=8, k=49 & rep = 100: 1.096 minutes
#>        There were 0 of 6 sets identified by my initial check as not decisive (0%)
#>        There were 94 of 94 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=50 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 161884603662657856 combinations
#>        Total time for n=8, k=50 & rep = 100: 1.082 minutes
#>        There were 0 of 3 sets identified by my initial check as not decisive (0%)
#>        There were 97 of 97 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=51 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 63484158299081520 combinations
#>        Total time for n=8, k=51 & rep = 100: 1.044 minutes
#>        There were 0 of 1 sets identified by my initial check as not decisive (0%)
#>        There were 99 of 99 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=52 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 23196134763125940 combinations
#>        Total time for n=8, k=52 & rep = 100: 1.034 minutes
#>        There were 0 of 5 sets identified by my initial check as not decisive (0%)
#>        There were 95 of 95 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=53 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 7877932561061640 combinations
#>        Total time for n=8, k=53 & rep = 100: 1.011 minutes
#>        There were 0 of 3 sets identified by my initial check as not decisive (0%)
#>        There were 97 of 97 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=54 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2480089880334220 combinations
#>        Total time for n=8, k=54 & rep = 100: 0.996 minutes
#>        There were 0 of 4 sets identified by my initial check as not decisive (0%)
#>        There were 96 of 96 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=55 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 721480692460864 combinations
#>        Total time for n=8, k=55 & rep = 100: 0.975 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=56 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 193253756909160 combinations
#>        Total time for n=8, k=56 & rep = 100: 0.97 minutes
#>        There were 0 of 1 sets identified by my initial check as not decisive (0%)
#>        There were 99 of 99 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=57 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 47465835030320 combinations
#>        Total time for n=8, k=57 & rep = 100: 0.942 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=58 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 10638894058520 combinations
#>        Total time for n=8, k=58 & rep = 100: 0.919 minutes
#>        There were 0 of 1 sets identified by my initial check as not decisive (0%)
#>        There were 99 of 99 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=59 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2163842859360 combinations
#>        Total time for n=8, k=59 & rep = 100: 0.909 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=60 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 396704524216 combinations
#>        Total time for n=8, k=60 & rep = 100: 0.901 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=61 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 65033528560 combinations
#>        Total time for n=8, k=61 & rep = 100: 0.878 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=62 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 9440350920 combinations
#>        Total time for n=8, k=62 & rep = 100: 0.872 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=63 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 1198774720 combinations
#>        Total time for n=8, k=63 & rep = 100: 0.872 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=64 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 131115985 combinations
#>        Total time for n=8, k=64 & rep = 100: 0.863 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=65 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 12103014 combinations
#>        Total time for n=8, k=65 & rep = 100: 0.86 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=66 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 916895 combinations
#>        Total time for n=8, k=66 & rep = 100: 0.857 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=67 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 54740 combinations
#>        Total time for n=8, k=67 & rep = 100: 0.855 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=68 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 2415 combinations
#>        Total time for n=8, k=68 & rep = 100: 0.853 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
#> 
#> Working on n=8, k=69 & rep = 100 ...
#> Input data matches to given taxa size
#>        Working on 100 repeats of 70 combinations
#>        Total time for n=8, k=69 & rep = 100: 0.851 minutes
#>        There were 0 of 0 sets identified by my initial check as not decisive (NaN%)
#>        There were 100 of 100 sets identified by Fischers algorith as decisive (100%)
dumTab2 = rbindlist(dumTab2)
dumTab2[,negRate := NR_check3_neg/NR_NotPhyloDec]
dumTab2[,posRate := NR_FAlg_pos/NR_PhyloDec]
dumTab2[NR_PhyloDec==0,posRate := NA]
dumTab2[NR_NotPhyloDec==0,negRate := NA]
dumTab2[NR_PhyloDec>0,]
#>      k  time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec    negRate
#>  1: 33 2.320            86           0             96           4 0.89583333
#>  2: 34 2.252            86           0             98           2 0.87755102
#>  3: 35 2.140            73           0             94           6 0.77659574
#>  4: 36 2.125            54           3             91           9 0.59340659
#>  5: 37 1.970            43           6             88          12 0.48863636
#>  6: 38 1.876            37          12             83          17 0.44578313
#>  7: 39 1.698            29          25             71          29 0.40845070
#>  8: 40 1.604            20          38             59          41 0.33898305
#>  9: 41 1.529            25          43             56          44 0.44642857
#> 10: 42 1.441            15          58             40          60 0.37500000
#> 11: 43 1.367             6          59             37          63 0.16216216
#> 12: 44 1.299             3          71             29          71 0.10344828
#> 13: 45 1.247             0          83             17          83 0.00000000
#> 14: 46 1.219             2          74             25          75 0.08000000
#> 15: 47 1.173             0          84             15          85 0.00000000
#> 16: 48 1.141             1          85             15          85 0.06666667
#> 17: 49 1.096             0          94              6          94 0.00000000
#> 18: 50 1.082             0          97              3          97 0.00000000
#> 19: 51 1.044             0          99              1          99 0.00000000
#> 20: 52 1.034             0          95              5          95 0.00000000
#> 21: 53 1.011             0          97              3          97 0.00000000
#> 22: 54 0.996             0          96              4          96 0.00000000
#> 23: 55 0.975             0         100              0         100         NA
#> 24: 56 0.970             0          99              1          99 0.00000000
#> 25: 57 0.942             0         100              0         100         NA
#> 26: 58 0.919             0          99              1          99 0.00000000
#> 27: 59 0.909             0         100              0         100         NA
#> 28: 60 0.901             0         100              0         100         NA
#> 29: 61 0.878             0         100              0         100         NA
#> 30: 62 0.872             0         100              0         100         NA
#> 31: 63 0.872             0         100              0         100         NA
#> 32: 64 0.863             0         100              0         100         NA
#> 33: 65 0.860             0         100              0         100         NA
#> 34: 66 0.857             0         100              0         100         NA
#> 35: 67 0.855             0         100              0         100         NA
#> 36: 68 0.853             0         100              0         100         NA
#> 37: 69 0.851             0         100              0         100         NA
#>      k  time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec    negRate
#>       posRate
#>  1: 0.0000000
#>  2: 0.0000000
#>  3: 0.0000000
#>  4: 0.3333333
#>  5: 0.5000000
#>  6: 0.7058824
#>  7: 0.8620690
#>  8: 0.9268293
#>  9: 0.9772727
#> 10: 0.9666667
#> 11: 0.9365079
#> 12: 1.0000000
#> 13: 1.0000000
#> 14: 0.9866667
#> 15: 0.9882353
#> 16: 1.0000000
#> 17: 1.0000000
#> 18: 1.0000000
#> 19: 1.0000000
#> 20: 1.0000000
#> 21: 1.0000000
#> 22: 1.0000000
#> 23: 1.0000000
#> 24: 1.0000000
#> 25: 1.0000000
#> 26: 1.0000000
#> 27: 1.0000000
#> 28: 1.0000000
#> 29: 1.0000000
#> 30: 1.0000000
#> 31: 1.0000000
#> 32: 1.0000000
#> 33: 1.0000000
#> 34: 1.0000000
#> 35: 1.0000000
#> 36: 1.0000000
#> 37: 1.0000000
#>       posRate
```

# Loop with 10,000 repeats

``` r

registerDoMC(cores=10)

dumTab3 = foreach(j=1:max_quad)%dopar%{
  # j=10
  message("\nWorking on n=8, k=",j," & rep = max 10,000 ... ")
  time1 = Sys.time()
  myTest = mySimulationFunction(number_taxa = 8, 
                                number_quads = j,
                                repeats = 10000,
                                data1 = quadruple_data,
                                data2 = myTab_n8,
                                verbose = F)
  
  time2 = Sys.time()
  x0 = as.numeric(round(difftime(time2,time1,units = "mins"),3))
  message("       Total time for n=8, k=",j," & rep = 100: " ,round(difftime(time2,time1,units = "mins"),3)," minutes")
  
  outfn = paste0("../results/SimulationResults_n8_k",j,"_rep10000.RData")
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
SimulationResults_n8 = rbindlist(dumTab3)

SimulationResults_n8[,negRate := NR_check3_neg/NR_NotPhyloDec]
SimulationResults_n8[,posRate := NR_FAlg_pos/NR_PhyloDec]
SimulationResults_n8[NR_PhyloDec==0,posRate := NA]
SimulationResults_n8[NR_NotPhyloDec==0,negRate := NA]
save(SimulationResults_n8, file = "../results/SimulationResults_n8.RData")

SimulationResults_n8[NR_PhyloDec>0,]
#>      k    time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec     negRate
#>  1: 30 227.632          9907           0           9997           3 0.990997299
#>  2: 31 230.692          9684           0           9985          15 0.969854782
#>  3: 32 231.857          9333           0           9938          62 0.939122560
#>  4: 33 234.184          8660           0           9842         158 0.879902459
#>  5: 34 227.881          7912           0           9685         315 0.816933402
#>  6: 35 216.855          6841         100           9371         629 0.730018141
#>  7: 36 205.552          5792         360           8975        1025 0.645348189
#>  8: 37 194.262          4674         990           8326        1674 0.561374009
#>  9: 38 185.225          3772        1586           7720        2280 0.488601036
#> 10: 39 172.420          2846        2536           6952        3048 0.409378596
#> 11: 40 161.680          2093        3419           6139        3861 0.340935006
#> 12: 41 153.463          1494        4397           5303        4697 0.281727324
#> 13: 42 144.499          1091        5209           4584        5416 0.238001745
#> 14: 43 138.054           669        6008           3841        6159 0.174173392
#> 15: 44 132.732           483        6766           3132        6868 0.154214559
#> 16: 45 126.028           292        7374           2555        7445 0.114285714
#> 17: 46 121.086           179        7855           2118        7882 0.084513692
#> 18: 47 117.527            95        8331           1648        8352 0.057645631
#> 19: 48 114.288            63        8666           1326        8674 0.047511312
#> 20: 49 110.190            27        8993           1005        8995 0.026865672
#> 21: 50 107.041            22        9225            773        9227 0.028460543
#> 22: 51 105.008            11        9429            569        9431 0.019332162
#> 23: 52 102.333             8        9571            427        9573 0.018735363
#> 24: 53 100.920             1        9741            259        9741 0.003861004
#> 25: 54  99.646             1        9804            196        9804 0.005102041
#> 26: 55  97.389             0        9841            159        9841 0.000000000
#> 27: 56  95.378             0        9907             93        9907 0.000000000
#> 28: 57  94.182             0        9942             58        9942 0.000000000
#> 29: 58  92.883             0        9964             36        9964 0.000000000
#> 30: 59  90.754             0        9974             26        9974 0.000000000
#> 31: 60  89.042             0        9980             20        9980 0.000000000
#> 32: 61  88.012             0        9996              4        9996 0.000000000
#> 33: 62  87.011             0        9999              1        9999 0.000000000
#> 34: 63  86.479             0        9999              1        9999 0.000000000
#> 35: 64  86.101             0       10000              0       10000          NA
#> 36: 65  85.193             0       10000              0       10000          NA
#> 37: 66  85.655             0       10000              0       10000          NA
#> 38: 67  85.433             0       10000              0       10000          NA
#> 39: 68  85.185             0       10000              0       10000          NA
#> 40: 69  85.280             0       10000              0       10000          NA
#>      k    time NR_check3_neg NR_FAlg_pos NR_NotPhyloDec NR_PhyloDec     negRate
#>       posRate
#>  1: 0.0000000
#>  2: 0.0000000
#>  3: 0.0000000
#>  4: 0.0000000
#>  5: 0.0000000
#>  6: 0.1589825
#>  7: 0.3512195
#>  8: 0.5913978
#>  9: 0.6956140
#> 10: 0.8320210
#> 11: 0.8855219
#> 12: 0.9361294
#> 13: 0.9617799
#> 14: 0.9754830
#> 15: 0.9851485
#> 16: 0.9904634
#> 17: 0.9965745
#> 18: 0.9974856
#> 19: 0.9990777
#> 20: 0.9997777
#> 21: 0.9997832
#> 22: 0.9997879
#> 23: 0.9997911
#> 24: 1.0000000
#> 25: 1.0000000
#> 26: 1.0000000
#> 27: 1.0000000
#> 28: 1.0000000
#> 29: 1.0000000
#> 30: 1.0000000
#> 31: 1.0000000
#> 32: 1.0000000
#> 33: 1.0000000
#> 34: 1.0000000
#> 35: 1.0000000
#> 36: 1.0000000
#> 37: 1.0000000
#> 38: 1.0000000
#> 39: 1.0000000
#> 40: 1.0000000
#>       posRate
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
message("\nTOTAL TIME : " ,round(difftime(Sys.time(),time0,units = "mins"),3)," minutes")
#> 
#> TOTAL TIME : 1027.742 minutes
```
