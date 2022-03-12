#' ---
#' title: "Creating all 4WPs for n=7"
#' subtitle: "Simulation Phylogenetic Decisivness"
#' author: "Janne Pott"
#' date: "11.03.2022"
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
#' I want to create a data table containing all possible four-way partitions with n=7 taxa. The data table should contain the following columns: 
#' 
#' * set_i: taxa included in partition i of 4, separated by "|"
#' * allQuads: all quadruples possible with the given partition, separated by "|"
#' 
#' According to Stirling numbers of the second kind, there are 350 different partitions for 6 taxa. 
#' 
#' There are three types of partitions: 
#' 
#' 1) a | b | c | defg
#' 2) a | b | cd | efg
#' 3) a | bc | de | fg
#' 
#' I create them separately and combine them at the end. 
#' 
#' In addition, I test the table with the example data set from my master thesis (not yet included as example data set).
#' 
#' # Init ####
#' ***
rm(list = ls())
time0<-Sys.time()

source("myStirlingFunction.R")
.libPaths()
library(PhyloDecR)
library(data.table)
library(foreach)

#' # Check & general parameters ####
#' ***
myStirlingFunction(n=7,k=4)

n=7
x = c(1:n)

#' # First set of partitions: triples ####
#' ***
#' a | b | c | defg  
#' 
allTriples = t(combn(n,3))
allTriples<-data.table::as.data.table(allTriples)
names(allTriples) = c("set1","set2","set3")
allTriples[,triple := paste(set1,set2,set3,sep="_")]

dumTab = foreach(i = 1:dim(allTriples)[1])%do%{
  #i=1
  myRow = allTriples[i,]
  myX = c(myRow$set1,myRow$set2,myRow$set3)
  notmyX = x[!is.element(x,myX)]
  
  quads = c()
  for(j in 1:length(notmyX)){
    #j=1
    myY = c(myX,notmyX[j])
    ordering = order(myY)
    myY = myY[ordering]
    
    quads = c(quads, paste(myY[1],myY[2],myY[3],myY[4],sep="_")) 
  }
  
  quads
  myQuads <-paste(quads, collapse = "|")
  myRow[,set4 := paste(notmyX, collapse = "|")]
  myRow[,allQuads := myQuads]
  myRow[,triple := NULL]
  myRow
  
}

tab1 = rbindlist(dumTab)
head(tab1)

#' # Second set of partitions: tuples ####
#' ***
#' a | b | cd | efg
#' 
allTuples = t(combn(n,2))
allTuples<-data.table::as.data.table(allTuples)
names(allTuples) = c("set1","set2")
allTuples[,tuple := paste(set1,set2,sep="_")]

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
    
    x1 = notmyX[a2[1]]
    x2 = notmyX[a2[2]]
    x3 = notmyX[!is.element(notmyX,c(x1,x2))]
    myRow2[,set3:=paste(c(x1,x2), collapse = "|")]
    myRow2[,set4:=paste(x3,collapse = "|")]
    
    quads = c()
    for(k in 1:length(x3)){
      myY1 = c(myX,x1,x3[k])
      myY1 = myY1[order(myY1)]
      myY2 = c(myX,x2,x3[k])
      myY2 = myY2[order(myY2)]
      quad1 = paste(myY1[1],myY1[2],myY1[3],myY1[4],sep="_") 
      quad2 = paste(myY2[1],myY2[2],myY2[3],myY2[4],sep="_") 
      
      quads = c(quads,quad1,quad2)
      
    }

    myQuads <-paste(quads, collapse = "|")
    myRow2[,allQuads := myQuads]
    myRow2[,tuple := NULL]
    myRow2
  }
  
  myRow2 = rbindlist(dumTab2)
  myRow2
}

tab2 = rbindlist(dumTab)
head(tab2)

#' # Third set of partitions ####
#' ***
#' a | bc | de | fg
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
    
    x1 = notmyX[a2[1]]
    x2 = notmyX[a2[2]]
    x3 = notmyX[!is.element(notmyX,c(x1,x2))]
    myRow2[,set2:=paste(c(x1,x2), collapse = "|")]
    
    b = t(combn(length(x3),2))
    b1 = dim(b)[1]
    
    dumTab3 = foreach(k = 1:b1)%do%{
      #k=1
      b2 = b[k,]
      myRow3 = copy(myRow2)
      
      x4 = x3[b2[1]]
      x5 = x3[b2[2]]
      x6 = x3[!is.element(x3,c(x4,x5))]
      myRow2[,set3:=paste(c(x4,x5), collapse = "|")]
      myRow2[,set4:=paste(x6, collapse = "|")]
      
      myRow2
      
      quads = c()
      for(l in 1:length(x6)){
        #l=1
        myY1 = c(myX,x1,x4,x6[l])
        myY2 = c(myX,x1,x5,x6[l])
        myY3 = c(myX,x2,x4,x6[l])
        myY4 = c(myX,x2,x5,x6[l])
        
        myY1 = myY1[order(myY1)]
        myY2 = myY2[order(myY2)]
        myY3 = myY3[order(myY3)]
        myY4 = myY4[order(myY4)]
        
        quad1 = paste(myY1[1],myY1[2],myY1[3],myY1[4],sep="_") 
        quad2 = paste(myY2[1],myY2[2],myY2[3],myY2[4],sep="_") 
        quad3 = paste(myY3[1],myY3[2],myY3[3],myY3[4],sep="_") 
        quad4 = paste(myY4[1],myY4[2],myY4[3],myY4[4],sep="_") 
        
        quads = c(quads,quad1,quad2,quad3,quad4)
        
      }
      myQuads <-paste(quads, collapse = "|")
      myRow2[,allQuads := myQuads]
      myRow2
    }
    dumTab3 = rbindlist(dumTab3)
    dumTab3
  }
  dumTab2 = rbindlist(dumTab2)
  dumTab2
}

tab3 = rbindlist(dumTab)
head(tab3)
table(duplicated(tab3$allQuads))
tab3 = tab3[!duplicated(allQuads)]

#' # Merge sets ####
#' ***
myTab_n7 = rbind(tab1,tab2,tab3)
dim(myTab_n7)

myTab_n7[,status := "uncovered"]
myTab_n7[,count := 0]

save(myTab_n7,file = "../partitions/partitions_n7.RData")

#' # Test ####
#' ***
#' I use the example data sets from my master thesis. 
#' 
test1 = createInput(fn="../testData/Smin7_notDecisive.txt",sepSym = "_")
test2 = createInput(fn="../testData/S7_Decisive.txt",sepSym = "_")
test1_checks = initialCheck(test1$data)
test2_checks = initialCheck(test2$data)
test1_alg<-runAlgorithm(data = test1$data,verbose = T)
test2_alg<-runAlgorithm(data = test2$data,verbose = T)

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
table(myTab2$count)
if(min(myTab1$count>0)) message("phylogenetically decisive according to 4WPP") else message("not phylogenetically decisive")
if(min(myTab2$count>0)) message("phylogenetically decisive according to 4WPP") else message("not phylogenetically decisive")

#' Okay, the test is positive:
#' 
#' * as stated in my thesis, test1 is not decisive & test2 is decisive
#' * Fischers Algorithm fails for both
#'   * test1: not enough qaudruples & not enough tuples
#'   * test2: not enough quadruples
#' 
#' # SessionInfo ####
#' ***
sessionInfo()
message("\nTOTAL TIME : " ,round(difftime(Sys.time(),time0,units = "mins"),3)," minutes")
