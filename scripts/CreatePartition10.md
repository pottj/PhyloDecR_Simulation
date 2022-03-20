
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

library(PhyloDecR)
library(data.table)
library(foreach)
```

# Check & general parameters

``` r
myStirlingFunction(n=10,k=4)
#> [1] 34105

n=10
x = c(1:n)
```

# Set 1

a \| b \| c \| defghij

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
#>    set1 set2 set3           set4
#> 1:    1    2    3 4|5|6|7|8|9|10
#> 2:    1    2    4 3|5|6|7|8|9|10
#> 3:    1    2    5 3|4|6|7|8|9|10
#> 4:    1    2    6 3|4|5|7|8|9|10
#> 5:    1    2    7 3|4|5|6|8|9|10
#> 6:    1    2    8 3|4|5|6|7|9|10
#>                                                    allQuads
#> 1: 1_2_3_10|1_2_3_4|1_2_3_5|1_2_3_6|1_2_3_7|1_2_3_8|1_2_3_9
#> 2: 1_2_3_4|1_2_4_10|1_2_4_5|1_2_4_6|1_2_4_7|1_2_4_8|1_2_4_9
#> 3: 1_2_3_5|1_2_4_5|1_2_5_10|1_2_5_6|1_2_5_7|1_2_5_8|1_2_5_9
#> 4: 1_2_3_6|1_2_4_6|1_2_5_6|1_2_6_10|1_2_6_7|1_2_6_8|1_2_6_9
#> 5: 1_2_3_7|1_2_4_7|1_2_5_7|1_2_6_7|1_2_7_10|1_2_7_8|1_2_7_9
#> 6: 1_2_3_8|1_2_4_8|1_2_5_8|1_2_6_8|1_2_7_8|1_2_8_10|1_2_8_9
table(duplicated(tab1$allQuads))
#> 
#> FALSE 
#>   120
```

# Set 2

a \| b \| cd \| efghij

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
#>    set1 set2 set3         set4
#> 1:    1    2  3|4 5|6|7|8|9|10
#> 2:    1    2  3|5 4|6|7|8|9|10
#> 3:    1    2  3|6 4|5|7|8|9|10
#> 4:    1    2  3|7 4|5|6|8|9|10
#> 5:    1    2  3|8 4|5|6|7|9|10
#> 6:    1    2  3|9 4|5|6|7|8|10
#>                                                                                             allQuads
#> 1: 1_2_3_10|1_2_3_5|1_2_3_6|1_2_3_7|1_2_3_8|1_2_3_9|1_2_4_10|1_2_4_5|1_2_4_6|1_2_4_7|1_2_4_8|1_2_4_9
#> 2: 1_2_3_10|1_2_3_4|1_2_3_6|1_2_3_7|1_2_3_8|1_2_3_9|1_2_4_5|1_2_5_10|1_2_5_6|1_2_5_7|1_2_5_8|1_2_5_9
#> 3: 1_2_3_10|1_2_3_4|1_2_3_5|1_2_3_7|1_2_3_8|1_2_3_9|1_2_4_6|1_2_5_6|1_2_6_10|1_2_6_7|1_2_6_8|1_2_6_9
#> 4: 1_2_3_10|1_2_3_4|1_2_3_5|1_2_3_6|1_2_3_8|1_2_3_9|1_2_4_7|1_2_5_7|1_2_6_7|1_2_7_10|1_2_7_8|1_2_7_9
#> 5: 1_2_3_10|1_2_3_4|1_2_3_5|1_2_3_6|1_2_3_7|1_2_3_9|1_2_4_8|1_2_5_8|1_2_6_8|1_2_7_8|1_2_8_10|1_2_8_9
#> 6: 1_2_3_10|1_2_3_4|1_2_3_5|1_2_3_6|1_2_3_7|1_2_3_8|1_2_4_9|1_2_5_9|1_2_6_9|1_2_7_9|1_2_8_9|1_2_9_10
table(duplicated(tab2$allQuads))
#> 
#> FALSE 
#>  1260
```

# Set 3

a \| b \| cde \| fghij

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
#>    set1 set2   set3       set4
#> 1:    1    2  3|4|5 6|7|8|9|10
#> 2:    1    2  3|4|6 5|7|8|9|10
#> 3:    1    2  3|4|7 5|6|8|9|10
#> 4:    1    2  3|4|8 5|6|7|9|10
#> 5:    1    2  3|4|9 5|6|7|8|10
#> 6:    1    2 3|4|10  5|6|7|8|9
#>                                                                                                                        allQuads
#> 1:   1_2_3_10|1_2_3_6|1_2_3_7|1_2_3_8|1_2_3_9|1_2_4_10|1_2_4_6|1_2_4_7|1_2_4_8|1_2_4_9|1_2_5_10|1_2_5_6|1_2_5_7|1_2_5_8|1_2_5_9
#> 2:   1_2_3_10|1_2_3_5|1_2_3_7|1_2_3_8|1_2_3_9|1_2_4_10|1_2_4_5|1_2_4_7|1_2_4_8|1_2_4_9|1_2_5_6|1_2_6_10|1_2_6_7|1_2_6_8|1_2_6_9
#> 3:   1_2_3_10|1_2_3_5|1_2_3_6|1_2_3_8|1_2_3_9|1_2_4_10|1_2_4_5|1_2_4_6|1_2_4_8|1_2_4_9|1_2_5_7|1_2_6_7|1_2_7_10|1_2_7_8|1_2_7_9
#> 4:   1_2_3_10|1_2_3_5|1_2_3_6|1_2_3_7|1_2_3_9|1_2_4_10|1_2_4_5|1_2_4_6|1_2_4_7|1_2_4_9|1_2_5_8|1_2_6_8|1_2_7_8|1_2_8_10|1_2_8_9
#> 5:   1_2_3_10|1_2_3_5|1_2_3_6|1_2_3_7|1_2_3_8|1_2_4_10|1_2_4_5|1_2_4_6|1_2_4_7|1_2_4_8|1_2_5_9|1_2_6_9|1_2_7_9|1_2_8_9|1_2_9_10
#> 6: 1_2_3_5|1_2_3_6|1_2_3_7|1_2_3_8|1_2_3_9|1_2_4_5|1_2_4_6|1_2_4_7|1_2_4_8|1_2_4_9|1_2_5_10|1_2_6_10|1_2_7_10|1_2_8_10|1_2_9_10
table(duplicated(tab3$allQuads))
#> 
#> FALSE 
#>  2520
tab3 = tab3[!duplicated(allQuads)]
```

# Set 4

a \| b \| cdef \| ghij

``` r
allTuples = t(combn(n,2))
allTuples<-data.table::as.data.table(allTuples)
names(allTuples) = c("set1","set2")

dumTab = foreach(i = 1:dim(allTuples)[1])%do%{
  #i=1
  myRow = allTuples[i,]
  myX = c(myRow$set1,myRow$set2)
  notmyX = x[!is.element(x,myX)]
  
  a = t(combn(length(notmyX),4))
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

tab4 = rbindlist(dumTab)
head(tab4)
#>    set1 set2     set3     set4
#> 1:    1    2  3|4|5|6 7|8|9|10
#> 2:    1    2  3|4|5|7 6|8|9|10
#> 3:    1    2  3|4|5|8 6|7|9|10
#> 4:    1    2  3|4|5|9 6|7|8|10
#> 5:    1    2 3|4|5|10  6|7|8|9
#> 6:    1    2  3|4|6|7 5|8|9|10
#>                                                                                                                               allQuads
#> 1: 1_2_3_10|1_2_3_7|1_2_3_8|1_2_3_9|1_2_4_10|1_2_4_7|1_2_4_8|1_2_4_9|1_2_5_10|1_2_5_7|1_2_5_8|1_2_5_9|1_2_6_10|1_2_6_7|1_2_6_8|1_2_6_9
#> 2: 1_2_3_10|1_2_3_6|1_2_3_8|1_2_3_9|1_2_4_10|1_2_4_6|1_2_4_8|1_2_4_9|1_2_5_10|1_2_5_6|1_2_5_8|1_2_5_9|1_2_6_7|1_2_7_10|1_2_7_8|1_2_7_9
#> 3: 1_2_3_10|1_2_3_6|1_2_3_7|1_2_3_9|1_2_4_10|1_2_4_6|1_2_4_7|1_2_4_9|1_2_5_10|1_2_5_6|1_2_5_7|1_2_5_9|1_2_6_8|1_2_7_8|1_2_8_10|1_2_8_9
#> 4: 1_2_3_10|1_2_3_6|1_2_3_7|1_2_3_8|1_2_4_10|1_2_4_6|1_2_4_7|1_2_4_8|1_2_5_10|1_2_5_6|1_2_5_7|1_2_5_8|1_2_6_9|1_2_7_9|1_2_8_9|1_2_9_10
#> 5: 1_2_3_6|1_2_3_7|1_2_3_8|1_2_3_9|1_2_4_6|1_2_4_7|1_2_4_8|1_2_4_9|1_2_5_6|1_2_5_7|1_2_5_8|1_2_5_9|1_2_6_10|1_2_7_10|1_2_8_10|1_2_9_10
#> 6: 1_2_3_10|1_2_3_5|1_2_3_8|1_2_3_9|1_2_4_10|1_2_4_5|1_2_4_8|1_2_4_9|1_2_5_6|1_2_5_7|1_2_6_10|1_2_6_8|1_2_6_9|1_2_7_10|1_2_7_8|1_2_7_9
table(duplicated(tab4$allQuads))
#> 
#> FALSE  TRUE 
#>  1575  1575
tab4 = tab4[!duplicated(allQuads)]
```

# Set 5

a \| bc \| de \| fghij

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

tab5 = rbindlist(dumTab)
head(tab5)
#>    set1 set2 set3       set4
#> 1:    1  2|3  4|5 6|7|8|9|10
#> 2:    1  2|3  4|6 5|7|8|9|10
#> 3:    1  2|3  4|7 5|6|8|9|10
#> 4:    1  2|3  4|8 5|6|7|9|10
#> 5:    1  2|3  4|9 5|6|7|8|10
#> 6:    1  2|3 4|10  5|6|7|8|9
#>                                                                                                                                                                     allQuads
#> 1:       1_2_4_10|1_2_4_6|1_2_4_7|1_2_4_8|1_2_4_9|1_2_5_10|1_2_5_6|1_2_5_7|1_2_5_8|1_2_5_9|1_3_4_10|1_3_4_6|1_3_4_7|1_3_4_8|1_3_4_9|1_3_5_10|1_3_5_6|1_3_5_7|1_3_5_8|1_3_5_9
#> 2:       1_2_4_10|1_2_4_5|1_2_4_7|1_2_4_8|1_2_4_9|1_2_5_6|1_2_6_10|1_2_6_7|1_2_6_8|1_2_6_9|1_3_4_10|1_3_4_5|1_3_4_7|1_3_4_8|1_3_4_9|1_3_5_6|1_3_6_10|1_3_6_7|1_3_6_8|1_3_6_9
#> 3:       1_2_4_10|1_2_4_5|1_2_4_6|1_2_4_8|1_2_4_9|1_2_5_7|1_2_6_7|1_2_7_10|1_2_7_8|1_2_7_9|1_3_4_10|1_3_4_5|1_3_4_6|1_3_4_8|1_3_4_9|1_3_5_7|1_3_6_7|1_3_7_10|1_3_7_8|1_3_7_9
#> 4:       1_2_4_10|1_2_4_5|1_2_4_6|1_2_4_7|1_2_4_9|1_2_5_8|1_2_6_8|1_2_7_8|1_2_8_10|1_2_8_9|1_3_4_10|1_3_4_5|1_3_4_6|1_3_4_7|1_3_4_9|1_3_5_8|1_3_6_8|1_3_7_8|1_3_8_10|1_3_8_9
#> 5:       1_2_4_10|1_2_4_5|1_2_4_6|1_2_4_7|1_2_4_8|1_2_5_9|1_2_6_9|1_2_7_9|1_2_8_9|1_2_9_10|1_3_4_10|1_3_4_5|1_3_4_6|1_3_4_7|1_3_4_8|1_3_5_9|1_3_6_9|1_3_7_9|1_3_8_9|1_3_9_10
#> 6: 1_2_4_5|1_2_4_6|1_2_4_7|1_2_4_8|1_2_4_9|1_2_5_10|1_2_6_10|1_2_7_10|1_2_8_10|1_2_9_10|1_3_4_5|1_3_4_6|1_3_4_7|1_3_4_8|1_3_4_9|1_3_5_10|1_3_6_10|1_3_7_10|1_3_8_10|1_3_9_10
table(duplicated(tab5$allQuads))
#> 
#> FALSE 
#>  3780
```

# Set 6

a \| bc \| def \| ghij

``` r
allSingles = data.table(set1 = x)

dumTab = foreach(i = 1:dim(allSingles)[1])%do%{
  #i=1
  myRow = allSingles[i,]
  myX = c(myRow$set1)
  notmyX = x[!is.element(x,myX)]
  
  a = t(combn(length(notmyX),2))
  a1 = dim(a)[1]
  
  dumTab2 = foreach(j = 1:a1)%do%{
    #j=1
    a2 = a[j,]
    myRow2 = copy(myRow)
    
    x2 = notmyX[a2]
    x3 = notmyX[!is.element(notmyX,x2)]
    myRow2[,set2:=paste(x2, collapse = "|")]
    
    b = t(combn(length(x3),3))
    b1 = dim(b)[1]
    
    dumTab3 = foreach(k = 1:b1)%do%{
      #k=1
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

tab6 = rbindlist(dumTab)
head(tab6)
#>    set1 set2   set3     set4
#> 1:    1  2|3  4|5|6 7|8|9|10
#> 2:    1  2|3  4|5|7 6|8|9|10
#> 3:    1  2|3  4|5|8 6|7|9|10
#> 4:    1  2|3  4|5|9 6|7|8|10
#> 5:    1  2|3 4|5|10  6|7|8|9
#> 6:    1  2|3  4|6|7 5|8|9|10
#>                                                                                                                                                                                                   allQuads
#> 1:   1_2_4_10|1_2_4_7|1_2_4_8|1_2_4_9|1_2_5_10|1_2_5_7|1_2_5_8|1_2_5_9|1_2_6_10|1_2_6_7|1_2_6_8|1_2_6_9|1_3_4_10|1_3_4_7|1_3_4_8|1_3_4_9|1_3_5_10|1_3_5_7|1_3_5_8|1_3_5_9|1_3_6_10|1_3_6_7|1_3_6_8|1_3_6_9
#> 2:   1_2_4_10|1_2_4_6|1_2_4_8|1_2_4_9|1_2_5_10|1_2_5_6|1_2_5_8|1_2_5_9|1_2_6_7|1_2_7_10|1_2_7_8|1_2_7_9|1_3_4_10|1_3_4_6|1_3_4_8|1_3_4_9|1_3_5_10|1_3_5_6|1_3_5_8|1_3_5_9|1_3_6_7|1_3_7_10|1_3_7_8|1_3_7_9
#> 3:   1_2_4_10|1_2_4_6|1_2_4_7|1_2_4_9|1_2_5_10|1_2_5_6|1_2_5_7|1_2_5_9|1_2_6_8|1_2_7_8|1_2_8_10|1_2_8_9|1_3_4_10|1_3_4_6|1_3_4_7|1_3_4_9|1_3_5_10|1_3_5_6|1_3_5_7|1_3_5_9|1_3_6_8|1_3_7_8|1_3_8_10|1_3_8_9
#> 4:   1_2_4_10|1_2_4_6|1_2_4_7|1_2_4_8|1_2_5_10|1_2_5_6|1_2_5_7|1_2_5_8|1_2_6_9|1_2_7_9|1_2_8_9|1_2_9_10|1_3_4_10|1_3_4_6|1_3_4_7|1_3_4_8|1_3_5_10|1_3_5_6|1_3_5_7|1_3_5_8|1_3_6_9|1_3_7_9|1_3_8_9|1_3_9_10
#> 5: 1_2_4_6|1_2_4_7|1_2_4_8|1_2_4_9|1_2_5_6|1_2_5_7|1_2_5_8|1_2_5_9|1_2_6_10|1_2_7_10|1_2_8_10|1_2_9_10|1_3_4_6|1_3_4_7|1_3_4_8|1_3_4_9|1_3_5_6|1_3_5_7|1_3_5_8|1_3_5_9|1_3_6_10|1_3_7_10|1_3_8_10|1_3_9_10
#> 6:   1_2_4_10|1_2_4_5|1_2_4_8|1_2_4_9|1_2_5_6|1_2_5_7|1_2_6_10|1_2_6_8|1_2_6_9|1_2_7_10|1_2_7_8|1_2_7_9|1_3_4_10|1_3_4_5|1_3_4_8|1_3_4_9|1_3_5_6|1_3_5_7|1_3_6_10|1_3_6_8|1_3_6_9|1_3_7_10|1_3_7_8|1_3_7_9
table(duplicated(tab6$allQuads))
#> 
#> FALSE 
#> 12600
```

# Set 7

a \| bcd \| efg \| hij

``` r
allSingles = data.table(set1 = x)

dumTab = foreach(i = 1:dim(allSingles)[1])%do%{
  #i=1
  myRow = allSingles[i,]
  myX = c(myRow$set1)
  notmyX = x[!is.element(x,myX)]
  
  a = t(combn(length(notmyX),3))
  a1 = dim(a)[1]
  
  dumTab2 = foreach(j = 1:a1)%do%{
    #j=1
    a2 = a[j,]
    myRow2 = copy(myRow)
    
    x2 = notmyX[a2]
    x3 = notmyX[!is.element(notmyX,x2)]
    myRow2[,set2:=paste(x2, collapse = "|")]
    
    b = t(combn(length(x3),3))
    b1 = dim(b)[1]
    
    dumTab3 = foreach(k = 1:b1)%do%{
      #k=1
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

tab7 = rbindlist(dumTab)
head(tab7)
#>    set1  set2   set3   set4
#> 1:    1 2|3|4  5|6|7 8|9|10
#> 2:    1 2|3|4  5|6|8 7|9|10
#> 3:    1 2|3|4  5|6|9 7|8|10
#> 4:    1 2|3|4 5|6|10  7|8|9
#> 5:    1 2|3|4  5|7|8 6|9|10
#> 6:    1 2|3|4  5|7|9 6|8|10
#>                                                                                                                                                                                                                            allQuads
#> 1: 1_2_5_10|1_2_5_8|1_2_5_9|1_2_6_10|1_2_6_8|1_2_6_9|1_2_7_10|1_2_7_8|1_2_7_9|1_3_5_10|1_3_5_8|1_3_5_9|1_3_6_10|1_3_6_8|1_3_6_9|1_3_7_10|1_3_7_8|1_3_7_9|1_4_5_10|1_4_5_8|1_4_5_9|1_4_6_10|1_4_6_8|1_4_6_9|1_4_7_10|1_4_7_8|1_4_7_9
#> 2: 1_2_5_10|1_2_5_7|1_2_5_9|1_2_6_10|1_2_6_7|1_2_6_9|1_2_7_8|1_2_8_10|1_2_8_9|1_3_5_10|1_3_5_7|1_3_5_9|1_3_6_10|1_3_6_7|1_3_6_9|1_3_7_8|1_3_8_10|1_3_8_9|1_4_5_10|1_4_5_7|1_4_5_9|1_4_6_10|1_4_6_7|1_4_6_9|1_4_7_8|1_4_8_10|1_4_8_9
#> 3: 1_2_5_10|1_2_5_7|1_2_5_8|1_2_6_10|1_2_6_7|1_2_6_8|1_2_7_9|1_2_8_9|1_2_9_10|1_3_5_10|1_3_5_7|1_3_5_8|1_3_6_10|1_3_6_7|1_3_6_8|1_3_7_9|1_3_8_9|1_3_9_10|1_4_5_10|1_4_5_7|1_4_5_8|1_4_6_10|1_4_6_7|1_4_6_8|1_4_7_9|1_4_8_9|1_4_9_10
#> 4: 1_2_5_7|1_2_5_8|1_2_5_9|1_2_6_7|1_2_6_8|1_2_6_9|1_2_7_10|1_2_8_10|1_2_9_10|1_3_5_7|1_3_5_8|1_3_5_9|1_3_6_7|1_3_6_8|1_3_6_9|1_3_7_10|1_3_8_10|1_3_9_10|1_4_5_7|1_4_5_8|1_4_5_9|1_4_6_7|1_4_6_8|1_4_6_9|1_4_7_10|1_4_8_10|1_4_9_10
#> 5: 1_2_5_10|1_2_5_6|1_2_5_9|1_2_6_7|1_2_6_8|1_2_7_10|1_2_7_9|1_2_8_10|1_2_8_9|1_3_5_10|1_3_5_6|1_3_5_9|1_3_6_7|1_3_6_8|1_3_7_10|1_3_7_9|1_3_8_10|1_3_8_9|1_4_5_10|1_4_5_6|1_4_5_9|1_4_6_7|1_4_6_8|1_4_7_10|1_4_7_9|1_4_8_10|1_4_8_9
#> 6: 1_2_5_10|1_2_5_6|1_2_5_8|1_2_6_7|1_2_6_9|1_2_7_10|1_2_7_8|1_2_8_9|1_2_9_10|1_3_5_10|1_3_5_6|1_3_5_8|1_3_6_7|1_3_6_9|1_3_7_10|1_3_7_8|1_3_8_9|1_3_9_10|1_4_5_10|1_4_5_6|1_4_5_8|1_4_6_7|1_4_6_9|1_4_7_10|1_4_7_8|1_4_8_9|1_4_9_10
table(duplicated(tab7$allQuads))
#> 
#> FALSE 
#>  2800
```

# Set 8

ab \| cd \| ef \| ghij

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
tab8 = rbindlist(dumTab)
head(tab8)
#>    set1 set2 set3     set4
#> 1:  1|2  3|4  5|6 7|8|9|10
#> 2:  1|2  3|4  5|7 6|8|9|10
#> 3:  1|2  3|4  5|8 6|7|9|10
#> 4:  1|2  3|4  5|9 6|7|8|10
#> 5:  1|2  3|4 5|10  6|7|8|9
#> 6:  1|2  3|4  6|7 5|8|9|10
#>                                                                                                                                                                                                                                                                           allQuads
#> 1:         1_3_5_10|1_3_5_7|1_3_5_8|1_3_5_9|1_3_6_10|1_3_6_7|1_3_6_8|1_3_6_9|1_4_5_10|1_4_5_7|1_4_5_8|1_4_5_9|1_4_6_10|1_4_6_7|1_4_6_8|1_4_6_9|2_3_5_10|2_3_5_7|2_3_5_8|2_3_5_9|2_3_6_10|2_3_6_7|2_3_6_8|2_3_6_9|2_4_5_10|2_4_5_7|2_4_5_8|2_4_5_9|2_4_6_10|2_4_6_7|2_4_6_8|2_4_6_9
#> 2:         1_3_5_10|1_3_5_6|1_3_5_8|1_3_5_9|1_3_6_7|1_3_7_10|1_3_7_8|1_3_7_9|1_4_5_10|1_4_5_6|1_4_5_8|1_4_5_9|1_4_6_7|1_4_7_10|1_4_7_8|1_4_7_9|2_3_5_10|2_3_5_6|2_3_5_8|2_3_5_9|2_3_6_7|2_3_7_10|2_3_7_8|2_3_7_9|2_4_5_10|2_4_5_6|2_4_5_8|2_4_5_9|2_4_6_7|2_4_7_10|2_4_7_8|2_4_7_9
#> 3:         1_3_5_10|1_3_5_6|1_3_5_7|1_3_5_9|1_3_6_8|1_3_7_8|1_3_8_10|1_3_8_9|1_4_5_10|1_4_5_6|1_4_5_7|1_4_5_9|1_4_6_8|1_4_7_8|1_4_8_10|1_4_8_9|2_3_5_10|2_3_5_6|2_3_5_7|2_3_5_9|2_3_6_8|2_3_7_8|2_3_8_10|2_3_8_9|2_4_5_10|2_4_5_6|2_4_5_7|2_4_5_9|2_4_6_8|2_4_7_8|2_4_8_10|2_4_8_9
#> 4:         1_3_5_10|1_3_5_6|1_3_5_7|1_3_5_8|1_3_6_9|1_3_7_9|1_3_8_9|1_3_9_10|1_4_5_10|1_4_5_6|1_4_5_7|1_4_5_8|1_4_6_9|1_4_7_9|1_4_8_9|1_4_9_10|2_3_5_10|2_3_5_6|2_3_5_7|2_3_5_8|2_3_6_9|2_3_7_9|2_3_8_9|2_3_9_10|2_4_5_10|2_4_5_6|2_4_5_7|2_4_5_8|2_4_6_9|2_4_7_9|2_4_8_9|2_4_9_10
#> 5: 1_3_5_6|1_3_5_7|1_3_5_8|1_3_5_9|1_3_6_10|1_3_7_10|1_3_8_10|1_3_9_10|1_4_5_6|1_4_5_7|1_4_5_8|1_4_5_9|1_4_6_10|1_4_7_10|1_4_8_10|1_4_9_10|2_3_5_6|2_3_5_7|2_3_5_8|2_3_5_9|2_3_6_10|2_3_7_10|2_3_8_10|2_3_9_10|2_4_5_6|2_4_5_7|2_4_5_8|2_4_5_9|2_4_6_10|2_4_7_10|2_4_8_10|2_4_9_10
#> 6:         1_3_5_6|1_3_5_7|1_3_6_10|1_3_6_8|1_3_6_9|1_3_7_10|1_3_7_8|1_3_7_9|1_4_5_6|1_4_5_7|1_4_6_10|1_4_6_8|1_4_6_9|1_4_7_10|1_4_7_8|1_4_7_9|2_3_5_6|2_3_5_7|2_3_6_10|2_3_6_8|2_3_6_9|2_3_7_10|2_3_7_8|2_3_7_9|2_4_5_6|2_4_5_7|2_4_6_10|2_4_6_8|2_4_6_9|2_4_7_10|2_4_7_8|2_4_7_9
table(duplicated(tab8$allQuads))
#> 
#> FALSE  TRUE 
#>  3150  6300
tab8 = tab8[!duplicated(allQuads),]
```

# Set 9

ab \| bc \| efg \| hij

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
    
    b = t(combn(length(x3),3))
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
tab9 = rbindlist(dumTab)
head(tab9)
#>    set1 set2   set3   set4
#> 1:  1|2  3|4  5|6|7 8|9|10
#> 2:  1|2  3|4  5|6|8 7|9|10
#> 3:  1|2  3|4  5|6|9 7|8|10
#> 4:  1|2  3|4 5|6|10  7|8|9
#> 5:  1|2  3|4  5|7|8 6|9|10
#> 6:  1|2  3|4  5|7|9 6|8|10
#>                                                                                                                                                                                                                                                                                                       allQuads
#> 1: 1_3_5_10|1_3_5_8|1_3_5_9|1_3_6_10|1_3_6_8|1_3_6_9|1_3_7_10|1_3_7_8|1_3_7_9|1_4_5_10|1_4_5_8|1_4_5_9|1_4_6_10|1_4_6_8|1_4_6_9|1_4_7_10|1_4_7_8|1_4_7_9|2_3_5_10|2_3_5_8|2_3_5_9|2_3_6_10|2_3_6_8|2_3_6_9|2_3_7_10|2_3_7_8|2_3_7_9|2_4_5_10|2_4_5_8|2_4_5_9|2_4_6_10|2_4_6_8|2_4_6_9|2_4_7_10|2_4_7_8|2_4_7_9
#> 2: 1_3_5_10|1_3_5_7|1_3_5_9|1_3_6_10|1_3_6_7|1_3_6_9|1_3_7_8|1_3_8_10|1_3_8_9|1_4_5_10|1_4_5_7|1_4_5_9|1_4_6_10|1_4_6_7|1_4_6_9|1_4_7_8|1_4_8_10|1_4_8_9|2_3_5_10|2_3_5_7|2_3_5_9|2_3_6_10|2_3_6_7|2_3_6_9|2_3_7_8|2_3_8_10|2_3_8_9|2_4_5_10|2_4_5_7|2_4_5_9|2_4_6_10|2_4_6_7|2_4_6_9|2_4_7_8|2_4_8_10|2_4_8_9
#> 3: 1_3_5_10|1_3_5_7|1_3_5_8|1_3_6_10|1_3_6_7|1_3_6_8|1_3_7_9|1_3_8_9|1_3_9_10|1_4_5_10|1_4_5_7|1_4_5_8|1_4_6_10|1_4_6_7|1_4_6_8|1_4_7_9|1_4_8_9|1_4_9_10|2_3_5_10|2_3_5_7|2_3_5_8|2_3_6_10|2_3_6_7|2_3_6_8|2_3_7_9|2_3_8_9|2_3_9_10|2_4_5_10|2_4_5_7|2_4_5_8|2_4_6_10|2_4_6_7|2_4_6_8|2_4_7_9|2_4_8_9|2_4_9_10
#> 4: 1_3_5_7|1_3_5_8|1_3_5_9|1_3_6_7|1_3_6_8|1_3_6_9|1_3_7_10|1_3_8_10|1_3_9_10|1_4_5_7|1_4_5_8|1_4_5_9|1_4_6_7|1_4_6_8|1_4_6_9|1_4_7_10|1_4_8_10|1_4_9_10|2_3_5_7|2_3_5_8|2_3_5_9|2_3_6_7|2_3_6_8|2_3_6_9|2_3_7_10|2_3_8_10|2_3_9_10|2_4_5_7|2_4_5_8|2_4_5_9|2_4_6_7|2_4_6_8|2_4_6_9|2_4_7_10|2_4_8_10|2_4_9_10
#> 5: 1_3_5_10|1_3_5_6|1_3_5_9|1_3_6_7|1_3_6_8|1_3_7_10|1_3_7_9|1_3_8_10|1_3_8_9|1_4_5_10|1_4_5_6|1_4_5_9|1_4_6_7|1_4_6_8|1_4_7_10|1_4_7_9|1_4_8_10|1_4_8_9|2_3_5_10|2_3_5_6|2_3_5_9|2_3_6_7|2_3_6_8|2_3_7_10|2_3_7_9|2_3_8_10|2_3_8_9|2_4_5_10|2_4_5_6|2_4_5_9|2_4_6_7|2_4_6_8|2_4_7_10|2_4_7_9|2_4_8_10|2_4_8_9
#> 6: 1_3_5_10|1_3_5_6|1_3_5_8|1_3_6_7|1_3_6_9|1_3_7_10|1_3_7_8|1_3_8_9|1_3_9_10|1_4_5_10|1_4_5_6|1_4_5_8|1_4_6_7|1_4_6_9|1_4_7_10|1_4_7_8|1_4_8_9|1_4_9_10|2_3_5_10|2_3_5_6|2_3_5_8|2_3_6_7|2_3_6_9|2_3_7_10|2_3_7_8|2_3_8_9|2_3_9_10|2_4_5_10|2_4_5_6|2_4_5_8|2_4_6_7|2_4_6_9|2_4_7_10|2_4_7_8|2_4_8_9|2_4_9_10
table(duplicated(tab9$allQuads))
#> 
#> FALSE  TRUE 
#>  6300  6300
tab9 = tab9[!duplicated(allQuads),]
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
#> TOTAL TIME : 4.93 minutes
```
