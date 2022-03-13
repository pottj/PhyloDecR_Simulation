#' ---
#' title: "Simulation with n=6"
#' subtitle: "Simulation Phylogenetic Decisivness"
#' author: "Janne Pott"
#' date: "13.03.2022"
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
#' 
#' # Init ####
#' ***
rm(list = ls())
time0<-Sys.time()

.libPaths()
library(PhyloDecR)
library(data.table)
library(foreach)

source("../helperFunctions/mySimulationFunction.R")

#' # Get test data ####
#' ***
test1 = createInput(fn="../testData/S6_Decisive.txt",sepSym = "_")
quadruple_data = test1$data
quadruple_data[,status:=NA]

load("../partitions/partitions_n6.RData")

#' # Loop with 100 repeats ####
#' ***
dumTab2 = foreach(j=1:14)%do%{
  # j=10
  time1 = Sys.time()
  myTest = mySimulationFunction(number_taxa = 6, 
                                number_quads = j,
                                repeats = 100,
                                data1 = quadruple_data,
                                data2 = myTab_n6,
                                verbose = F)
  time2 = Sys.time()
  message("Total time for n=6, k=",j," & rep = 100: " ,round(difftime(time2,time1,units = "mins"),3)," minutes")
  
  head(myTest)
  
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
  
  message("There were ",x1," of ",x3," sets identified by my initial check as not decisive (",round(x1/x3,4)*100,"%)")
  message("There were ",x2," of ",x4," sets identified by Fischers algorith as decisive (",round(x2/x4,4)*100,"%)")
  
  myTest[,k:= j]
  myTest
}
dumTab2 = rbindlist(dumTab2)

#' # Loop with all repeats ####
#' ***
dumTab2 = foreach(j=1:14)%do%{
  # j=10
  time1 = Sys.time()
  myTest = mySimulationFunction(number_taxa = 6, 
                                number_quads = j,
                                repeats = 10000,
                                data1 = quadruple_data,
                                data2 = myTab_n6,
                                verbose = F)
  
  time2 = Sys.time()
  x0 = as.numeric(round(difftime(time2,time1,units = "mins"),3))
  message("Total time for n=6, k=",j," & rep = 100: " ,round(difftime(time2,time1,units = "mins"),3)," minutes")
  
  outfn = paste0("../results/SimulationResults_n6_k",j,".RData")
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
  
  message("There were ",x1," of ",x3," sets identified by my initial check as not decisive (",round(x1/x3,4)*100,"%)")
  message("There were ",x2," of ",x4," sets identified by Fischers algorith as decisive (",round(x2/x4,4)*100,"%)")
  
  res = data.table(k = j,
                   time = x0,
                   NR_check3_neg = x1,
                   NR_FAlg_pos = x2,
                   NR_NotPhyloDec = x3,
                   NR_PhyloDec = x4)
  res
}
SimulationResults_n6 = rbindlist(dumTab2)
save(SimulationResults_n6, file = "../results/SimulationResults_n6.RData")

#' # SessionInfo ####
#' ***
sessionInfo()
message("\nTOTAL TIME : " ,round(difftime(Sys.time(),time0,units = "mins"),3)," minutes")
