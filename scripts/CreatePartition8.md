
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction

<!-- badges: start -->
<!-- badges: end -->

I want to create a data table containing all possible four-way
partitions with n=8 taxa. The data table should contain the following
columns:

-   set_i: taxa included in partition i of 4, separated by “\|”
-   allQuads: all quadruples possible with the given partition,
    separated by “\|”

According to Stirling numbers of the second kind, there are 1,701
different partitions for 8 taxa.

There are five types of partitions:

1.  a \| b \| c \| defgh
2.  a \| b \| cd \| efgh
3.  a \| b \| cde \| fgh
4.  a \| bc \| de \| fgh
5.  ab \| cd \| ef \| gh

I create them separately and combine them at the end.

In addition, I test the table with the example data set from my master
thesis.

# Initialize

``` r
rm(list = ls())
time0<-Sys.time()

source("../helperFunctions/myStirlingFunction.R")
source("../helperFunctions/myPartitioningFunction.R")
source("../helperFunctions/getAllPosQuads.R")

library(PhyloDecR)
library(data.table)
library(foreach)
```

# Check & general parameters

``` r
myStirlingFunction(n=8,k=4)
#> [1] 1701

myPartitioningFunction
#> function (z1, z2, z3, z4) 
#> {
#>     n = sum(z1, z2, z3, z4)
#>     x = c(1:n)
#>     a = t(combn(n, z1))
#>     a1 = dim(a)[1]
#>     dumTab1 = foreach(i = 1:a1) %do% {
#>         a2 = a[i, ]
#>         x0 = x[a2]
#>         x1 = x[!is.element(x, x0)]
#>         myRow1 = data.table::data.table(set1 = paste(x0, collapse = "|"))
#>         b = t(combn(length(x1), z2))
#>         b1 = dim(b)[1]
#>         dumTab2 = foreach(j = 1:b1) %do% {
#>             b2 = b[j, ]
#>             myRow2 = copy(myRow1)
#>             x2 = x1[b2]
#>             x3 = x1[!is.element(x1, x2)]
#>             myRow2[, `:=`(set2, paste(x2, collapse = "|"))]
#>             c = t(combn(length(x3), z3))
#>             c1 = dim(c)[1]
#>             dumTab3 = foreach(k = 1:c1) %do% {
#>                 c2 = c[k, ]
#>                 myRow3 = copy(myRow2)
#>                 x4 = x3[c2]
#>                 x5 = x3[!is.element(x3, x4)]
#>                 myRow3[, `:=`(set3, paste(x4, collapse = "|"))]
#>                 myRow3[, `:=`(set4, paste(x5, collapse = "|"))]
#>                 myQuads = getAllPosQuads(y1 = x0, y2 = x2, y3 = x4, 
#>                   y4 = x5)
#>                 myRow3[, `:=`(allQuads, myQuads)]
#>                 myRow3
#>             }
#>             dumTab3 = rbindlist(dumTab3)
#>             dumTab3
#>         }
#>         dumTab2 = rbindlist(dumTab2)
#>         dumTab2 = dumTab2[!duplicated(allQuads), ]
#>         dumTab2
#>     }
#>     tab = rbindlist(dumTab1)
#>     head(tab)
#>     tab = tab[!duplicated(allQuads), ]
#>     return(tab)
#> }
getAllPosQuads
#> function (y1, y2, y3, y4) 
#> {
#>     dum = c(y1, y2, y3, y4)
#>     stopifnot(sum(duplicated(dum)) == 0)
#>     quads = c()
#>     for (t in 1:length(y1)) {
#>         set1 = y1[t]
#>         for (u in 1:length(y2)) {
#>             set2 = y2[u]
#>             for (v in 1:length(y3)) {
#>                 set3 = y3[v]
#>                 for (w in 1:length(y4)) {
#>                   set4 = y4[w]
#>                   myY = c(set1, set2, set3, set4)
#>                   myY = myY[order(myY)]
#>                   quad = paste(myY[1], myY[2], myY[3], myY[4], 
#>                     sep = "_")
#>                   quads = c(quads, quad)
#>                 }
#>             }
#>         }
#>     }
#>     quads = quads[order(quads)]
#>     myQuads <- paste(quads, collapse = "|")
#>     return(myQuads)
#> }
```

# Set 1

a \| b \| c \| defgh == 1 + 1 + 1 + 5

``` r
tab1 = myPartitioningFunction(1,1,1,5)
```

# Set 2

a \| b \| cd \| efgh == 1 + 1 + 2 + 4

``` r
tab2 = myPartitioningFunction(1,1,2,4)
```

# Set 3

a \| b \| cde \| fgh == 1 + 1 + 3 + 3

``` r
tab3 = myPartitioningFunction(1,1,3,3)
```

# Set 4

a \| bc \| de \| fgh == 1 + 2 + 2 + 3

``` r
tab4 = myPartitioningFunction(1,2,2,3)
```

# Set 5

ab \| cd \| ef \| gh == 2 + 2 + 2 + 2

``` r
tab5 = myPartitioningFunction(2,2,2,2)
```

# Save

``` r
myTab_n8 = rbind(tab1,tab2,tab3,tab4,tab5)
dim(myTab_n8)
#> [1] 1701    5
myStirlingFunction(n=8,k=4)
#> [1] 1701

stopifnot(dim(myTab_n8)[1]==myStirlingFunction(n=8,k=4))

myTab_n8[,status := "uncovered"]
myTab_n8[,count := 0]

save(myTab_n8,file = "../partitions/partitions_n8.RData")
```

# Test

``` r
test1 = createInput(fn="../testData/S8_notDecisive.txt",sepSym = "_")
#> Input contains 36 trees with 8 different taxa. The biggest tree has 4 taxa.
test1_checks = initialCheck(test1$data)
test1_alg<-runAlgorithm(data = test1$data,verbose = T)
#> Using 36 of 70 quadruples as input for algorithm (8 unique taxa). 
#>  This leaves 34 quadruples unsolved.
#> In round #1, 5 quadruples could be resolved ...
#> In round #2, 7 quadruples could be resolved ...
#> In round #3, 4 quadruples could be resolved ...
#> In round #4, 3 quadruples could be resolved ...
#> In round #5, 3 quadruples could be resolved ...
#> In round #6, 0 quadruples could be resolved ...
#> [1] "NOT RESOLVABLE VIA THIS ALGORITHM, MAYBE A SECOND FIXING TAXON IS NEEDED"
test2 = createInput(fn="../testData/S8_Decisive.txt",sepSym = "_")
#> Input contains 28 trees with 8 different taxa. The biggest tree has 4 taxa.
test2_checks = initialCheck(test2$data)
test2_alg<-runAlgorithm(data = test2$data,verbose = T)
#> Using 28 of 70 quadruples as input for algorithm (8 unique taxa). 
#>  This leaves 42 quadruples unsolved.
#> In round #1, 0 quadruples could be resolved ...
#> [1] "NOT RESOLVABLE VIA THIS ALGORITHM, MAYBE A SECOND FIXING TAXON IS NEEDED"

dummy1 = test1$data
dummy2 = test2$data

dummy1 = dummy1[status=="input",]
dummy2 = dummy2[status=="input",]

myTab1 = copy(myTab_n8)
myTab2 = copy(myTab_n8)

for(i in 1:dim(dummy1)[1]){
  #i=1
  myInput = dummy1[i,quadruple]
  filt = grepl(myInput,myTab1$allQuads)
  myTab1[filt==T,status := "covered"]
  myTab1[filt==T,count := count + 1]
  myTab1
}
for(i in 1:dim(dummy2)[1]){
  #i=1
  myInput = dummy2[i,quadruple]
  filt = grepl(myInput,myTab2$allQuads)
  myTab2[filt==T,status := "covered"]
  myTab2[filt==T,count := count + 1]
  myTab2
}

table(myTab1$count)
#> 
#>   0   1   2   3   4   5   6   7   8   9  10  11  12 
#>   1  10  56 174 307 368 323 253 126  52  23   7   1
table(myTab2$count)
#> 
#>   2   4   6   8  10 
#> 308 952 406  21  14

if(min(myTab1$count>0)) message("phylogenetically decisive according to 4WPP") else message("not phylogenetically decisive")
#> not phylogenetically decisive
if(min(myTab2$count>0)) message("phylogenetically decisive according to 4WPP") else message("not phylogenetically decisive")
#> phylogenetically decisive according to 4WPP
```

# Session Info

``` r
sessionInfo()
#> R version 4.1.1 (2021-08-10)
#> Platform: x86_64-w64-mingw32/x64 (64-bit)
#> Running under: Windows 10 x64 (build 22000)
#> 
#> Matrix products: default
#> 
#> locale:
#> [1] LC_COLLATE=German_Germany.1252  LC_CTYPE=German_Germany.1252   
#> [3] LC_MONETARY=German_Germany.1252 LC_NUMERIC=C                   
#> [5] LC_TIME=German_Germany.1252    
#> 
#> attached base packages:
#> [1] stats     graphics  grDevices utils     datasets  methods   base     
#> 
#> other attached packages:
#> [1] foreach_1.5.1        data.table_1.14.2    PhyloDecR_0.0.0.9007
#> 
#> loaded via a namespace (and not attached):
#>  [1] codetools_0.2-18 digest_0.6.28    magrittr_2.0.1   evaluate_0.14   
#>  [5] rlang_0.4.11     stringi_1.7.4    rmarkdown_2.11   iterators_1.0.13
#>  [9] tools_4.1.1      stringr_1.4.0    xfun_0.26        yaml_2.2.1      
#> [13] fastmap_1.1.0    compiler_4.1.1   htmltools_0.5.2  knitr_1.36
message("\nTOTAL TIME : " ,round(difftime(Sys.time(),time0,units = "mins"),3)," minutes")
#> 
#> TOTAL TIME : 0.405 minutes
```
