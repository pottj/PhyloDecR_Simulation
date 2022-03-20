
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Introduction

<!-- badges: start -->
<!-- badges: end -->

I want to create a data table containing all possible four-way
partitions with n=7 taxa. The data table should contain the following
columns:

-   set_i: taxa included in partition i of 4, separated by “\|”
-   allQuads: all quadruples possible with the given partition,
    separated by “\|”

According to Stirling numbers of the second kind, there are 350
different partitions for 7 taxa.

There are three types of partitions:

1.  a \| b \| c \| defg
2.  a \| b \| cd \| efg
3.  a \| bc \| de \| fg

I create them separately and combine them at the end.

In addition, I test the table with the example data set from my master
thesis.

# Initialize

``` r
rm(list = ls())
time0<-Sys.time()

source("../helperFunctions/myStirlingFunction.R")
source("../helperFunctions/myPartitioningFunction.R")

library(PhyloDecR)
library(data.table)
library(foreach)
```

# Check & general parameters

``` r
myStirlingFunction(n=7,k=4)
#> [1] 350

n=7
x = c(1:n)
```

# Set 1

a \| b \| c \| defg

``` r
allTriples = t(combn(n,3))
allTriples<-data.table::as.data.table(allTriples)
names(allTriples) = c("set1","set2","set3")

dumTab = foreach(i = 1:dim(allTriples)[1])%do%{
  #i=1
  myRow = allTriples[i,]
  myX = c(myRow$set1,myRow$set2,myRow$set3)
  notmyX = x[!is.element(x,myX)]
  
  myQuads = myPartitioningFunction(y1 = myRow$set1,
                                   y2 = myRow$set2,
                                   y3 = myRow$set3,
                                   y4 = notmyX)
  myRow[,set4 := paste(notmyX, collapse = "|")]
  myRow[,allQuads := myQuads]
  myRow
  
}

tab1 = rbindlist(dumTab)
head(tab1)
#>    set1 set2 set3    set4                        allQuads
#> 1:    1    2    3 4|5|6|7 1_2_3_4|1_2_3_5|1_2_3_6|1_2_3_7
#> 2:    1    2    4 3|5|6|7 1_2_3_4|1_2_4_5|1_2_4_6|1_2_4_7
#> 3:    1    2    5 3|4|6|7 1_2_3_5|1_2_4_5|1_2_5_6|1_2_5_7
#> 4:    1    2    6 3|4|5|7 1_2_3_6|1_2_4_6|1_2_5_6|1_2_6_7
#> 5:    1    2    7 3|4|5|6 1_2_3_7|1_2_4_7|1_2_5_7|1_2_6_7
#> 6:    1    3    4 2|5|6|7 1_2_3_4|1_3_4_5|1_3_4_6|1_3_4_7
table(duplicated(tab1$allQuads))
#> 
#> FALSE 
#>    35
```

# Set 2

a \| b \| cd \| efg

``` r
allTuples = t(combn(n,2))
allTuples<-data.table::as.data.table(allTuples)
names(allTuples) = c("set1","set2")

dumTab = foreach(i = 1:dim(allTuples)[1])%do%{
  #i=1
  myRow = allTuples[i,]
  myX = c(myRow$set1,myRow$set2)
  notmyX = x[!is.element(x,myX)]
  
  a = t(combn(length(notmyX),2))
  a1 = dim(a)[1]

  dumTab2 = foreach(j = 1:a1)%do%{
    #j=1
    a2 = a[j,]
    myRow2 = copy(myRow)
    
    x2 = notmyX[a2]
    x3 = notmyX[!is.element(notmyX,x2)]
    myRow2[,set3:=paste(x2, collapse = "|")]
    myRow2[,set4:=paste(x3,collapse = "|")]
    
    myQuads = myPartitioningFunction(y1 = myRow2$set1,
                                     y2 = myRow2$set2,
                                     y3 = x2,
                                     y4 = x3)
    
    myRow2[,allQuads := myQuads]
    myRow2
  }
  
  myRow2 = rbindlist(dumTab2)
  myRow2
}

tab2 = rbindlist(dumTab)
head(tab2)
#>    set1 set2 set3  set4                                        allQuads
#> 1:    1    2  3|4 5|6|7 1_2_3_5|1_2_3_6|1_2_3_7|1_2_4_5|1_2_4_6|1_2_4_7
#> 2:    1    2  3|5 4|6|7 1_2_3_4|1_2_3_6|1_2_3_7|1_2_4_5|1_2_5_6|1_2_5_7
#> 3:    1    2  3|6 4|5|7 1_2_3_4|1_2_3_5|1_2_3_7|1_2_4_6|1_2_5_6|1_2_6_7
#> 4:    1    2  3|7 4|5|6 1_2_3_4|1_2_3_5|1_2_3_6|1_2_4_7|1_2_5_7|1_2_6_7
#> 5:    1    2  4|5 3|6|7 1_2_3_4|1_2_3_5|1_2_4_6|1_2_4_7|1_2_5_6|1_2_5_7
#> 6:    1    2  4|6 3|5|7 1_2_3_4|1_2_3_6|1_2_4_5|1_2_4_7|1_2_5_6|1_2_6_7
table(duplicated(tab2$allQuads))
#> 
#> FALSE 
#>   210
```

# Set 3

a \| bc \| de \| fg

``` r
allSingles = data.table(set1 = x)

dumTab = foreach(i = 1:dim(allSingles)[1])%do%{
  #i=7
  myRow = allSingles[i,]
  myX = c(myRow$set1)
  notmyX = x[!is.element(x,myX)]
  
  a = t(combn(length(notmyX),2))
  a1 = dim(a)[1]
  
  dumTab2 = foreach(j = 1:a1)%do%{
    #j=14
    a2 = a[j,]
    myRow2 = copy(myRow)
    
    x2 = notmyX[a2]
    x3 = notmyX[!is.element(notmyX,x2)]
    myRow2[,set2:=paste(x2, collapse = "|")]
    
    b = t(combn(length(x3),2))
    b1 = dim(b)[1]
    
    dumTab3 = foreach(k = 1:b1)%do%{
      #k=7
      b2 = b[k,]
      myRow3 = copy(myRow2)
      
      x4 = x3[b2]
      x6 = x3[!is.element(x3,x4)]
      myRow3[,set3:=paste(x4, collapse = "|")]
      myRow3[,set4:=paste(x6, collapse = "|")]
      
      myQuads = myPartitioningFunction(y1 = myRow3$set1,
                                       y2 = x2,
                                       y3 = x4,
                                       y4 = x6)
      
      myRow3[,allQuads := myQuads]
      myRow3
    }
    dumTab3 = rbindlist(dumTab3)
    dumTab3
  }
  dumTab2 = rbindlist(dumTab2)
  dumTab2 = dumTab2[!duplicated(allQuads),]
  dumTab2
}

tab3 = rbindlist(dumTab)
head(tab3)
#>    set1 set2 set3 set4
#> 1:    1  2|3  4|5  6|7
#> 2:    1  2|3  4|6  5|7
#> 3:    1  2|3  4|7  5|6
#> 4:    1  2|4  3|5  6|7
#> 5:    1  2|4  3|6  5|7
#> 6:    1  2|4  3|7  5|6
#>                                                           allQuads
#> 1: 1_2_4_6|1_2_4_7|1_2_5_6|1_2_5_7|1_3_4_6|1_3_4_7|1_3_5_6|1_3_5_7
#> 2: 1_2_4_5|1_2_4_7|1_2_5_6|1_2_6_7|1_3_4_5|1_3_4_7|1_3_5_6|1_3_6_7
#> 3: 1_2_4_5|1_2_4_6|1_2_5_7|1_2_6_7|1_3_4_5|1_3_4_6|1_3_5_7|1_3_6_7
#> 4: 1_2_3_6|1_2_3_7|1_2_5_6|1_2_5_7|1_3_4_6|1_3_4_7|1_4_5_6|1_4_5_7
#> 5: 1_2_3_5|1_2_3_7|1_2_5_6|1_2_6_7|1_3_4_5|1_3_4_7|1_4_5_6|1_4_6_7
#> 6: 1_2_3_5|1_2_3_6|1_2_5_7|1_2_6_7|1_3_4_5|1_3_4_6|1_4_5_7|1_4_6_7
table(duplicated(tab3$allQuads))
#> 
#> FALSE 
#>   105
```

# Save

``` r
myTab_n7 = rbind(tab1,tab2,tab3)
dim(myTab_n7)
#> [1] 350   5
myStirlingFunction(n=7,k=4)
#> [1] 350

stopifnot(dim(myTab_n7)[1]==myStirlingFunction(n=7,k=4))

myTab_n7[,status := "uncovered"]
myTab_n7[,count := 0]

save(myTab_n7,file = "../partitions/partitions_n7.RData")
```

# Test

``` r
test1 = createInput(fn="../testData/Smin7_notDecisive.txt",sepSym = "_")
#> Input contains 12 trees with 7 different taxa. The biggest tree has 4 taxa.
test1_checks = initialCheck(test1$data)
test1_alg<-runAlgorithm(data = test1$data,verbose = T)
#> Using 12 of 35 quadruples as input for algorithm (7 unique taxa). 
#>  This leaves 23 quadruples unsolved.
#> In round #1, 0 quadruples could be resolved ...
#> [1] "NOT RESOLVABLE VIA THIS ALGORITHM, MAYBE A SECOND FIXING TAXON IS NEEDED"
test2 = createInput(fn="../testData/S7_Decisive.txt",sepSym = "_")
#> Input contains 14 trees with 7 different taxa. The biggest tree has 4 taxa.
test2_checks = initialCheck(test2$data)
test2_alg<-runAlgorithm(data = test2$data,verbose = T)
#> Using 14 of 35 quadruples as input for algorithm (7 unique taxa). 
#>  This leaves 21 quadruples unsolved.
#> In round #1, 0 quadruples could be resolved ...
#> [1] "NOT RESOLVABLE VIA THIS ALGORITHM, MAYBE A SECOND FIXING TAXON IS NEEDED"

dummy1 = test1$data
dummy2 = test2$data

dummy1 = dummy1[status=="input",]
dummy2 = dummy2[status=="input",]

myTab1 = copy(myTab_n7)
myTab2 = copy(myTab_n7)

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
#>   0   1   2   3   4   5 
#>  22  59 134 100  34   1
table(myTab2$count)
#> 
#>   1   2   3   4   5 
#>  56 112 126  42  14

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
#> TOTAL TIME : 0.059 minutes
```
