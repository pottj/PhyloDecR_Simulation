#' ---
#' title: "Creating all 4WPs for n=9"
#' subtitle: "Simulation Phylogenetic Decisivness"
#' author: "Janne Pott"
#' date: "20.03.2022"
#' output:
#'   html_document:
#'     toc: true
#'     number_sections: true
#'     toc_float: true
#'     code_folding: show
#' ---
#'
#' # Intro ####
#' ***
#' I want to create a data table containing all possible four-way partitions with n=9 taxa. The data table should contain the following columns: 
#' 
#' * set_i: taxa included in partition i of 4, separated by "|"
#' * allQuads: all quadruples possible with the given partition, separated by "|"
#' 
#' According to Stirling numbers of the second kind, there are 7770 different partitions for 9 taxa. 
#' 
#' There are six types of partitions: 
#' 
#' 1) a | b | c | defghi
#' 2) a | b | cd | efghi
#' 3) a | b | cde | fghi
#' 4) a | bc | de | fghi
#' 5) a | bc | def | ghi
#' 6) ab | cd | ef | ghi
#' 
#' I create them separately and combine them at the end. 
#' 
#' In addition, I test the table with some example data sets (not decisive: Mareikes Mathematica example, decisive: some trees added to the previous example)

#' # Init ####
#' ***
rm(list = ls())
time0<-Sys.time()

source("../helperFunctions/myStirlingFunction.R")
source("../helperFunctions/myPartitioningFunction.R")

library(PhyloDecR)
library(data.table)
library(foreach)

#' # Check & general parameters ####
#' ***
myStirlingFunction(n=9,k=4)

n=9
x = c(1:n)

#' # First set of partitions: triples ####
#' ***
#' a | b | c | defghi  
#' 
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
table(duplicated(tab1$allQuads))

#' # Second set of partitions ####
#' ***
#' a | b | cd | efghi
#' 
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
table(duplicated(tab2$allQuads))

#' # Third set of partitions ####
#' ***
#' a | b | cde | fghi
#' 
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
table(duplicated(tab3$allQuads))
tab3 = tab3[!duplicated(allQuads)]

#' # Fourth set of partitions ####
#' ***
#' a | bc | de | fghi
#'  
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
table(duplicated(tab4$allQuads))

#' # Fifth set of partitions ####
#' ***
#' a | bc | def | ghi
#'  
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

tab5 = rbindlist(dumTab)
head(tab5)
table(duplicated(tab5$allQuads))

#' # Sixth set of partitions ####
#' ***
#' ab | cd | ef | ghi
#'  
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
tab6 = rbindlist(dumTab)
head(tab6)
table(duplicated(tab6$allQuads))
tab6 = tab6[!duplicated(allQuads),]

#' # Merge sets ####
#' ***
myTab_n9 = rbind(tab1,tab2,tab3,tab4,tab5,tab6)
dim(myTab_n9)

myTab_n9[,status := "uncovered"]
myTab_n9[,count := 0]

save(myTab_n9,file = "../partitions/partitions_n9.RData")

#' # Test ####
#' ***
#' I use the example data from Mareikes tool + one with another additional tree
#' 
test1 = createInput(fn="../testData/S9_notDecisive.txt",sepSym = "_")
test1_checks = initialCheck(test1$data)
test1_alg<-runAlgorithm(data = test1$data,verbose = T)
test2 = createInput(fn="../testData/S9_Decisive.txt",sepSym = "_")
test2_checks = initialCheck(test2$data)
test2_alg<-runAlgorithm(data = test2$data,verbose = T)

dummy1 = test1$data
dummy2 = test2$data

dummy1 = dummy1[status=="input",]
dummy2 = dummy2[status=="input",]

myTab1 = copy(myTab_n9)
myTab2 = copy(myTab_n9)

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
table(myTab2$count)

if(min(myTab1$count>0)) message("phylogenetically decisive according to 4WPP") else message("not phylogenetically decisive")
if(min(myTab2$count>0)) message("phylogenetically decisive according to 4WPP") else message("not phylogenetically decisive")

#' Okay, the test like this: not phylogenetic decisive, as there are 2506 partitions that are not covered by any quadruple
#' 
#' # SessionInfo ####
#' ***
sessionInfo()
message("\nTOTAL TIME : " ,round(difftime(Sys.time(),time0,units = "mins"),3)," minutes")
