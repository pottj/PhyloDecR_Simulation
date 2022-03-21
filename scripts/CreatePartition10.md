
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction

<!-- badges: start -->
<!-- badges: end -->

I want to create a data table containing all possible four-way
partitions with n=10 taxa. The data table should contain the following
columns:

-   set_i: taxa included in partition i of 4, separated by “\|”
-   allQuads: all quadruples possible with the given partition,
    separated by “\|”

According to Stirling numbers of the second kind, there are 34,105
different partitions for 10 taxa.

There are nine types of partitions:

1.  a \| b \| c \| defghij
2.  a \| b \| cd \| efghij
3.  a \| b \| cde \| fghij
4.  a \| b \| cdef \| ghij
5.  a \| bc \| de \| fghij
6.  a \| bc \| def \| ghij
7.  a \| bcd \| efg \| hij
8.  ab \| cd \| ef \| ghij
9.  ab \| cd \| efg \| hij

I create them separately and combine them at the end.

In addition, I test the table with some example data sets (not decisive:
Mareikes Mathematica example, decisive: some trees added to the previous
example)

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
myStirlingFunction(n=10,k=4)
#> [1] 34105

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

a \| b \| c \| defghij == 1 + 1 + 1 + 7

``` r
tab1 = myPartitioningFunction(1,1,1,7)
dim(tab1)
#> [1] 120   5
```

# Set 2

a \| b \| cd \| efghij == 1 + 1 + 2 + 6

``` r
tab2 = myPartitioningFunction(1,1,2,6)
dim(tab2)
#> [1] 1260    5
```

# Set 3

a \| b \| cde \| fghij == 1 + 1 + 3 + 5

``` r
tab3 = myPartitioningFunction(1,1,3,5)
dim(tab3)
#> [1] 2520    5
```

# Set 4

a \| b \| cdef \| ghij == 1 + 1 + 4 + 4

``` r
tab4 = myPartitioningFunction(1,1,4,4)
dim(tab4)
#> [1] 1575    5
```

# Set 5

a \| bc \| de \| fghij == 1 + 2 + 2 + 5

``` r
tab5 = myPartitioningFunction(1,2,2,5)
dim(tab5)
#> [1] 3780    5
```

# Set 6

a \| bc \| def \| ghij == 1 + 2 + 3 + 4

``` r
tab6 = myPartitioningFunction(1,2,3,4)
dim(tab6)
#> [1] 12600     5
```

# Set 7

a \| bcd \| efg \| hij == 1 + 3 + 3 + 3

``` r
tab7 = myPartitioningFunction(1,3,3,3)
dim(tab7)
#> [1] 2800    5
```

# Set 8

ab \| cd \| ef \| ghij == 2 + 2 + 2 + 4

``` r
tab8 = myPartitioningFunction(2,2,2,4)
dim(tab8)
#> [1] 3150    5
```

# Set 9

ab \| bc \| efg \| hij == 2 + 2 + 3 + 3

``` r
tab9 = myPartitioningFunction(2,2,3,3)
dim(tab9)
#> [1] 6300    5
```

# Save

``` r
myTab_n10 = rbind(tab1,tab2,tab3,tab4,tab5,tab6,tab7,tab8,tab9)
dim(myTab_n10)
#> [1] 34105     5
myStirlingFunction(n=10,k=4)
#> [1] 34105

stopifnot(dim(myTab_n10)[1]==myStirlingFunction(n=10,k=4))

myTab_n10[,status := "uncovered"]
myTab_n10[,count := 0]

save(myTab_n10,file = "../partitions/partitions_n10.RData")
```

# Test

``` r
test1 = createInput(fn="../testData/S10_notDecisive.txt",sepSym = "_")
#> Input contains 7 trees with 10 different taxa. The biggest tree has 9 taxa.
test1_checks = initialCheck(test1$data)
test1_alg<-runAlgorithm(data = test1$data,verbose = T)
#> Using 188 of 210 quadruples as input for algorithm (10 unique taxa). 
#>  This leaves 22 quadruples unsolved.
#> In round #1, 9 quadruples could be resolved ...
#> In round #2, 0 quadruples could be resolved ...
#> [1] "NOT RESOLVABLE VIA THIS ALGORITHM, MAYBE A SECOND FIXING TAXON IS NEEDED"
test2 = createInput(fn="../testData/S10_Decisive.txt",sepSym = "_")
#> Input contains 7 trees with 10 different taxa. The biggest tree has 9 taxa.
test2_checks = initialCheck(test2$data)
test2_alg<-runAlgorithm(data = test2$data,verbose = T)
#> Using 196 of 210 quadruples as input for algorithm (10 unique taxa). 
#>  This leaves 14 quadruples unsolved.
#> In round #1, 14 quadruples could be resolved ...
#> [1] "PHYLOGENETICALLY DECISIVE"

dummy1 = test1$data
dummy2 = test2$data

dummy1 = dummy1[status=="input",]
dummy2 = dummy2[status=="input",]

myTab1 = copy(myTab_n10)
myTab2 = copy(myTab_n10)

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
#>    0    2    3    4    5    6    7    8    9   10   11   12   13   14   15   16 
#>    3    2    4    9   34   54  132  117  149  413  425  872  654 1176 1579 1012 
#>   17   18   19   20   21   22   23   24   25   26   27   28   29   30   31   32 
#>  735 1539 1641 2413 1562 3231 3010 2515  698  882  736  699  879 1238 1143 1598 
#>   33   34   35   36 
#> 1247 1007  428  269
table(myTab2$count)
#> 
#>    4    5    6    7    8    9   10   11   12   13   14   15   16   17   18   19 
#>    6   11   21   91   28  104  212  348  970  552  893 1616  987  367 1048 1083 
#>   20   21   22   23   24   25   26   27   28   29   30   31   32   33   34   35 
#> 2422 1135 3523 3455 3668  871  777  635  449  470 1265  790 1304 1026 2413 1174 
#>   36 
#>  391

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
#> TOTAL TIME : 5.993 minutes
```
