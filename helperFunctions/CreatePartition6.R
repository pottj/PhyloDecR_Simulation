#' What is my goal?
#' 
#' I want a function that gives me a TRUE/FALSE reply pending on the four-way partition property. 
#' 
#' 
library(PhyloDecR)
library(data.table)
library(foreach)

fn2 = system.file("extdata", 
                  "example_2_Decisive.txt", 
                  package = "PhyloDecR")
test2 = createInput(fn=fn2,sepSym = ",")
dummy = test2$data
dummy[status=="input"]
#' These are my input quadruples. If I understand the 4WPP & PD correctly, I must simply check, if all partitions of n=6 taxa are covered by these 11 quadruples. 
#' 
#' I need a quick way to generate all possible partitions
#' 
#' For n=6: a | b | cd | ef or a | b | c | def possible 
#' 
n=6
x = c(1:n)

allTriples = t(combn(n,3))
allTriples<-data.table::as.data.table(allTriples)
names(allTriples) = c("taxa1","taxa2","taxa3")
allTriples[,triple := paste(taxa1,taxa2,taxa3,sep="_")]

dumTab = foreach(i = 1:dim(allTriples)[1])%do%{
  #i=1
  myRow = allTriples[i,]
  myX = c(myRow$taxa1,myRow$taxa2,myRow$taxa3)
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
  myRow[,allQuads := myQuads]
  myRow
  
}

dum2 = rbindlist(dumTab)
dum2

#' okay, dum2 contains all possibilities for triple + any other taxa (a | b | c | def = 3*20 possibilities)
#' 
#' now the other option (a | b | cd | ef)

allTuples = t(combn(n,2))
allTuples<-data.table::as.data.table(allTuples)
names(allTuples) = c("taxa1","taxa2")
allTuples[,tuple := paste(taxa1,taxa2,sep="_")]

dumTab = foreach(i = 1:dim(allTuples)[1])%do%{
  #i=1
  myRow = allTuples[i,]
  myX = c(myRow$taxa1,myRow$taxa2)
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
    myRow2[,tuple2:=paste(x1,x2,sep="_")]
    myRow2[,tuple3:=paste(x3[1],x3[2],sep="_")]
    
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
    myRow2
  }
  
  myRow2 = rbindlist(dumTab2)
  myRow2
}

dum3 = rbindlist(dumTab)
dum3

# I want to rename! set1 set2 set3 set4 allQuads, then merge

tab1 = copy(dum2)
names(tab1) = gsub("taxa","set",names(tab1))
setnames(tab1,"triple","set4")

tab2 = copy(dum3)
names(tab2)
tab2[,tuple := NULL]
names(tab2) = gsub("taxa","set",names(tab2))
setnames(tab2,"tuple2","set3")
setnames(tab2,"tuple3","set4")

myTab = rbind(tab1,tab2)

# all 45 partitions have to be covered ...
myTab[,status := "uncovered"]
myTab[,count := 0]

dummy2 = dummy[status=="input",]

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
