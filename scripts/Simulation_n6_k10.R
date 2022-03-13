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

#' # Test 1 ####
#' n=6, k=10, repeats = 100
myTest1 = mySimulationFunction(number_taxa = 6, 
                              number_quads = 10,
                              repeats = 100,
                              data1 = quadruple_data,
                              data2 = myTab_n6)

table(myTest1$check1)
table(myTest1$check2)
table(myTest1$check3,myTest1$FischersAlg)
table(myTest1$check3,myTest1$FWPP)
table(myTest1$FischersAlg,myTest1$FWPP)

#' Was sagt mir das? 
#' 
#' * Von den 100 getesten Kombis würde ich laut meine Masterarbeit 55 gleich aussortieren, dabei übersehe ich nur 2
#' * Von den Phylogenetic decisive sets werden nur 3 nicht erkannt
#' 
myTest2 = mySimulationFunction(number_taxa = 6, 
                               number_quads = 10,
                               repeats = 4000,
                               data1 = quadruple_data,
                               data2 = myTab_n6)

table(myTest1$check1)
table(myTest1$check2)
table(myTest1$check3,myTest1$FischersAlg)
table(myTest1$check3,myTest1$FWPP)
table(myTest1$FischersAlg,myTest1$FWPP)

#' Was sagt mir das? 
#' 
#' * Von den 100 getesten Kombis würde ich laut meine Masterarbeit 55 gleich aussortieren, dabei übersehe ich nur 2
#' * Von den Phylogenetic decisive sets werden nur 3 nicht erkannt