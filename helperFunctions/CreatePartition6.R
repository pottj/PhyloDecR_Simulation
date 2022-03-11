#' ---
#' title: "Creating all 4WPs for n=6 "
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
#' I want to create a data table containing all possible four-way partitions with n=6 taxa. The data table should contain the following columns: 
#' 
#' * set_i: taxa included in partition i of 4
#' * allQuads: all quadruples possible with the given partition, separated by "|"
#' 
#' According to Stirling numbers of the second kind, there are 65 different partitions for 6 taxa. 
#' 
#' There are two types of partitions: 
#' 
#' 1) a | b | c | def
#' 2) a | b | cd | ef
#' 
#' I create them separately and combine them at the end. 
#' 
#' In addition, I test the table with the example data set 2 (phylo. dec.)
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
myStirlingFunction(n=6,k=4)

n=6
x = c(1:n)

#' # First set of partitions: triples ####
#' ***
#' a | b | c | def  
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
#' a | b | cd | ef
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
  a1 = a1/2

  dumTab2 = foreach(j = 1:a1)%do%{
    #j=1
    a2 = a[j,]
    myRow2 = copy(myRow)
    
    x1 = notmyX[a2[1]]
    x2 = notmyX[a2[2]]
    x3 = notmyX[!is.element(notmyX,c(x1,x2))]
    myRow2[,set3:=paste(c(x1,x2), collapse = "|")]
    myRow2[,set4:=paste(c(x3[1],x3[2]),collapse = "|")]
    
    myY1 = c(myX,x1,x3[1])
    myY2 = c(myX,x1,x3[2])
    myY3 = c(myX,x2,x3[1])
    myY4 = c(myX,x2,x3[2])

    myY1 = myY1[order(myY1)]
    myY2 = myY2[order(myY2)]
    myY3 = myY3[order(myY3)]
    myY4 = myY4[order(myY4)]
    
    quad1 = paste(myY1[1],myY1[2],myY1[3],myY1[4],sep="_") 
    quad2 = paste(myY2[1],myY2[2],myY2[3],myY2[4],sep="_") 
    quad3 = paste(myY3[1],myY3[2],myY3[3],myY3[4],sep="_") 
    quad4 = paste(myY4[1],myY4[2],myY4[3],myY4[4],sep="_") 
    
    myQuads <-paste(c(quad1,quad2,quad3,quad4), collapse = "|")
    myRow2[,allQuads := myQuads]
    myRow2[,tuple := NULL]
    myRow2
  }
  
  myRow2 = rbindlist(dumTab2)
  myRow2
}

tab2 = rbindlist(dumTab)
head(tab2)

#' # Merge sets ####
#' ***
myTab_n6 = rbind(tab1,tab2)
dim(myTab_n6)

myTab_n6[,status := "uncovered"]
myTab_n6[,count := 0]

save(myTab_n6,file = "../partitions/partitions_n6.RData")

#' # Test ####
#' ***
#' I use the second example data set from my PhyloDecR package. 
#' 
fn2 = system.file("extdata", 
                  "example_2_Decisive.txt", 
                  package = "PhyloDecR")
test2 = createInput(fn=fn2,sepSym = ",")
dummy = test2$data
dummy2 = dummy[status=="input",]

myTab = copy(myTab_n6)

for(i in 1:dim(dummy2)[1]){
  #i=1
  myInput = dummy2[i,quadruple]
  filt = grepl(myInput,myTab$allQuads)
  myTab[filt==T,status := "covered"]
  myTab[filt==T,count := count + 1]
  myTab
}

table(myTab$count)
if(min(myTab$count>0)) message("phylogenetically decisive according to 4WPP")

#' Okay, the test is positive. The data set is decisive according to 4WPP & Fischers Algorithm.  
#' 
#' # SessionInfo ####
#' ***
sessionInfo()
message("\nTOTAL TIME : " ,round(difftime(Sys.time(),time0,units = "mins"),3)," minutes")
