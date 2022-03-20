
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

library(PhyloDecR)
library(data.table)
library(foreach)
```

# Check & general parameters

``` r
myStirlingFunction(n=8,k=4)
#> [1] 1701

n=8
x = c(1:n)
```

# Set 1

a \| b \| c \| defghi

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
#>    set1 set2 set3      set4                                allQuads
#> 1:    1    2    3 4|5|6|7|8 1_2_3_4|1_2_3_5|1_2_3_6|1_2_3_7|1_2_3_8
#> 2:    1    2    4 3|5|6|7|8 1_2_3_4|1_2_4_5|1_2_4_6|1_2_4_7|1_2_4_8
#> 3:    1    2    5 3|4|6|7|8 1_2_3_5|1_2_4_5|1_2_5_6|1_2_5_7|1_2_5_8
#> 4:    1    2    6 3|4|5|7|8 1_2_3_6|1_2_4_6|1_2_5_6|1_2_6_7|1_2_6_8
#> 5:    1    2    7 3|4|5|6|8 1_2_3_7|1_2_4_7|1_2_5_7|1_2_6_7|1_2_7_8
#> 6:    1    2    8 3|4|5|6|7 1_2_3_8|1_2_4_8|1_2_5_8|1_2_6_8|1_2_7_8
table(duplicated(tab1$allQuads))
#> 
#> FALSE 
#>    56
```

# Set 2

a \| b \| cd \| efghi

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
#>    set1 set2 set3    set4
#> 1:    1    2  3|4 5|6|7|8
#> 2:    1    2  3|5 4|6|7|8
#> 3:    1    2  3|6 4|5|7|8
#> 4:    1    2  3|7 4|5|6|8
#> 5:    1    2  3|8 4|5|6|7
#> 6:    1    2  4|5 3|6|7|8
#>                                                           allQuads
#> 1: 1_2_3_5|1_2_3_6|1_2_3_7|1_2_3_8|1_2_4_5|1_2_4_6|1_2_4_7|1_2_4_8
#> 2: 1_2_3_4|1_2_3_6|1_2_3_7|1_2_3_8|1_2_4_5|1_2_5_6|1_2_5_7|1_2_5_8
#> 3: 1_2_3_4|1_2_3_5|1_2_3_7|1_2_3_8|1_2_4_6|1_2_5_6|1_2_6_7|1_2_6_8
#> 4: 1_2_3_4|1_2_3_5|1_2_3_6|1_2_3_8|1_2_4_7|1_2_5_7|1_2_6_7|1_2_7_8
#> 5: 1_2_3_4|1_2_3_5|1_2_3_6|1_2_3_7|1_2_4_8|1_2_5_8|1_2_6_8|1_2_7_8
#> 6: 1_2_3_4|1_2_3_5|1_2_4_6|1_2_4_7|1_2_4_8|1_2_5_6|1_2_5_7|1_2_5_8
table(duplicated(tab2$allQuads))
#> 
#> FALSE 
#>   420
```

# Set 3

a \| b \| cde \| fghi

``` r
allTuples = t(combn(n,2))
allTuples<-data.table::as.data.table(allTuples)
names(allTuples) = c("set1","set2")

dumTab = foreach(i = 1:dim(allTuples)[1])%do%{
  #i=1
  myRow = allTuples[i,]
  myX = c(myRow$set1,myRow$set2)
  notmyX = x[!is.element(x,myX)]
  
  a = t(combn(length(notmyX),3))
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

tab3 = rbindlist(dumTab)
head(tab3)
#>    set1 set2  set3  set4
#> 1:    1    2 3|4|5 6|7|8
#> 2:    1    2 3|4|6 5|7|8
#> 3:    1    2 3|4|7 5|6|8
#> 4:    1    2 3|4|8 5|6|7
#> 5:    1    2 3|5|6 4|7|8
#> 6:    1    2 3|5|7 4|6|8
#>                                                                   allQuads
#> 1: 1_2_3_6|1_2_3_7|1_2_3_8|1_2_4_6|1_2_4_7|1_2_4_8|1_2_5_6|1_2_5_7|1_2_5_8
#> 2: 1_2_3_5|1_2_3_7|1_2_3_8|1_2_4_5|1_2_4_7|1_2_4_8|1_2_5_6|1_2_6_7|1_2_6_8
#> 3: 1_2_3_5|1_2_3_6|1_2_3_8|1_2_4_5|1_2_4_6|1_2_4_8|1_2_5_7|1_2_6_7|1_2_7_8
#> 4: 1_2_3_5|1_2_3_6|1_2_3_7|1_2_4_5|1_2_4_6|1_2_4_7|1_2_5_8|1_2_6_8|1_2_7_8
#> 5: 1_2_3_4|1_2_3_7|1_2_3_8|1_2_4_5|1_2_4_6|1_2_5_7|1_2_5_8|1_2_6_7|1_2_6_8
#> 6: 1_2_3_4|1_2_3_6|1_2_3_8|1_2_4_5|1_2_4_7|1_2_5_6|1_2_5_8|1_2_6_7|1_2_7_8
table(duplicated(tab3$allQuads))
#> 
#> FALSE  TRUE 
#>   280   280
tab3 = tab3[!duplicated(allQuads)]
```

# Set 4

a \| bc \| de \| fghi

``` r
allSingles = data.table(set1 = x)

dumTab = foreach(i = 1:dim(allSingles)[1])%do%{
  #i=8
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

tab4 = rbindlist(dumTab)
head(tab4)
#>    set1 set2 set3  set4
#> 1:    1  2|3  4|5 6|7|8
#> 2:    1  2|3  4|6 5|7|8
#> 3:    1  2|3  4|7 5|6|8
#> 4:    1  2|3  4|8 5|6|7
#> 5:    1  2|3  5|6 4|7|8
#> 6:    1  2|3  5|7 4|6|8
#>                                                                                           allQuads
#> 1: 1_2_4_6|1_2_4_7|1_2_4_8|1_2_5_6|1_2_5_7|1_2_5_8|1_3_4_6|1_3_4_7|1_3_4_8|1_3_5_6|1_3_5_7|1_3_5_8
#> 2: 1_2_4_5|1_2_4_7|1_2_4_8|1_2_5_6|1_2_6_7|1_2_6_8|1_3_4_5|1_3_4_7|1_3_4_8|1_3_5_6|1_3_6_7|1_3_6_8
#> 3: 1_2_4_5|1_2_4_6|1_2_4_8|1_2_5_7|1_2_6_7|1_2_7_8|1_3_4_5|1_3_4_6|1_3_4_8|1_3_5_7|1_3_6_7|1_3_7_8
#> 4: 1_2_4_5|1_2_4_6|1_2_4_7|1_2_5_8|1_2_6_8|1_2_7_8|1_3_4_5|1_3_4_6|1_3_4_7|1_3_5_8|1_3_6_8|1_3_7_8
#> 5: 1_2_4_5|1_2_4_6|1_2_5_7|1_2_5_8|1_2_6_7|1_2_6_8|1_3_4_5|1_3_4_6|1_3_5_7|1_3_5_8|1_3_6_7|1_3_6_8
#> 6: 1_2_4_5|1_2_4_7|1_2_5_6|1_2_5_8|1_2_6_7|1_2_7_8|1_3_4_5|1_3_4_7|1_3_5_6|1_3_5_8|1_3_6_7|1_3_7_8
table(duplicated(tab4$allQuads))
#> 
#> FALSE 
#>   840
```

# Set 5

ab \| cd \| ef \| gh

``` r
allTuples = t(combn(n,2))
allTuples<-data.table::as.data.table(allTuples)
names(allTuples) = c("set1","set2")
allTuples[,tuple := paste(set1,set2,sep = "_")]
allTuples[,set2 := NULL]
allTuples[,set1 := NULL]

dumTab = foreach(i = 1:dim(allTuples)[1])%do%{
  #i=1
  myRow = allTuples[i,]
  myX = as.numeric(unlist(strsplit(myRow$tuple,"_")))
  notmyX = x[!is.element(x,myX)]
  myRow[,set1:=paste(myX, collapse = "|")]
  
  a = t(combn(length(notmyX),2))
  a1 = dim(a)[1]
  
  dumTab2 = foreach(j = 1:a1)%do%{
    #j=1
    a2 = a[j,]
    myRow2 = copy(myRow)
    
    x2 = notmyX[a2]
    x3 = notmyX[!is.element(notmyX,x2)]
    myRow2[,set2:=paste(x2, collapse = "|")]
    
    b = t(combn(length(x3),2))
    b1 = dim(b)[1]
    
    dumTab3 = foreach(k = 1:b1)%do%{
      #k=1
      b2 = b[k,]
      myRow3 = copy(myRow2)
      
      x4 = x3[b2]
      x6 = x3[!is.element(x3,x4)]
      myRow3[,set3:=paste(x4, collapse = "|")]
      myRow3[,set4:=paste(x6, collapse = "|")]
      
      myQuads = myPartitioningFunction(y1 = myX,
                                       y2 = x2,
                                       y3 = x4,
                                       y4 = x6)
      
      myRow3[,allQuads := myQuads]
      myRow3[,tuple:=NULL]
      myRow3
    }
    dumTab3 = rbindlist(dumTab3)
    dumTab3
  }
  dumTab2 = rbindlist(dumTab2)
  dumTab2 = dumTab2[!duplicated(allQuads),]
  dumTab2
}
tab5 = rbindlist(dumTab)
head(tab5)
#>    set1 set2 set3 set4
#> 1:  1|2  3|4  5|6  7|8
#> 2:  1|2  3|4  5|7  6|8
#> 3:  1|2  3|4  5|8  6|7
#> 4:  1|2  3|5  4|6  7|8
#> 5:  1|2  3|5  4|7  6|8
#> 6:  1|2  3|5  4|8  6|7
#>                                                                                                                           allQuads
#> 1: 1_3_5_7|1_3_5_8|1_3_6_7|1_3_6_8|1_4_5_7|1_4_5_8|1_4_6_7|1_4_6_8|2_3_5_7|2_3_5_8|2_3_6_7|2_3_6_8|2_4_5_7|2_4_5_8|2_4_6_7|2_4_6_8
#> 2: 1_3_5_6|1_3_5_8|1_3_6_7|1_3_7_8|1_4_5_6|1_4_5_8|1_4_6_7|1_4_7_8|2_3_5_6|2_3_5_8|2_3_6_7|2_3_7_8|2_4_5_6|2_4_5_8|2_4_6_7|2_4_7_8
#> 3: 1_3_5_6|1_3_5_7|1_3_6_8|1_3_7_8|1_4_5_6|1_4_5_7|1_4_6_8|1_4_7_8|2_3_5_6|2_3_5_7|2_3_6_8|2_3_7_8|2_4_5_6|2_4_5_7|2_4_6_8|2_4_7_8
#> 4: 1_3_4_7|1_3_4_8|1_3_6_7|1_3_6_8|1_4_5_7|1_4_5_8|1_5_6_7|1_5_6_8|2_3_4_7|2_3_4_8|2_3_6_7|2_3_6_8|2_4_5_7|2_4_5_8|2_5_6_7|2_5_6_8
#> 5: 1_3_4_6|1_3_4_8|1_3_6_7|1_3_7_8|1_4_5_6|1_4_5_8|1_5_6_7|1_5_7_8|2_3_4_6|2_3_4_8|2_3_6_7|2_3_7_8|2_4_5_6|2_4_5_8|2_5_6_7|2_5_7_8
#> 6: 1_3_4_6|1_3_4_7|1_3_6_8|1_3_7_8|1_4_5_6|1_4_5_7|1_5_6_8|1_5_7_8|2_3_4_6|2_3_4_7|2_3_6_8|2_3_7_8|2_4_5_6|2_4_5_7|2_5_6_8|2_5_7_8
table(duplicated(tab5$allQuads))
#> 
#> FALSE  TRUE 
#>   105   315
tab5 = tab5[!duplicated(allQuads),]
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
#> TOTAL TIME : 0.31 minutes
```
