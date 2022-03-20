#' ---
#' title: "Zusammenfassung der ersten Ergebnisse"
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
#' 
#' 1) Ich will barplots für die Simulationsergebnisse
#' 2) Ich will 4-Feldertafeln pro n um die Testgüte angeben zu kennen (False neg rate)
#' 
#' # Init ####
#' ***
rm(list = ls())
time0<-Sys.time()

#.libPaths("C:/userprograms/R_4.1.1/")
.libPaths("/net/ifs1/san_projekte/projekte/genstat/07_programme/rpackages/forostar/")
library(data.table)
library(ggplot2)

source("../helperFunctions/my4FTFunction.R")

#' # Get data ####
#' ***
#' n=6, n=7, und n=8
load("../results/SimulationResults_n6.RData")
load("../results/SimulationResults_n7.RData")
load("../results/SimulationResults_n8.RData")

#' # Bar plots ####
#' ***
x6 = dim(SimulationResults_n6)[1]
PlotData_n6 = data.table(k = rep(SimulationResults_n6$k,2),
                         phyloDec = c(SimulationResults_n6$NR_FAlg_pos,
                                      SimulationResults_n6$NR_PhyloDec),
                         category = c(rep("Algorithm",x6),rep("4WPP",x6)))
ggplot(data=PlotData_n6, aes(fill=category, y=phyloDec, x=k)) + 
  geom_bar(position="dodge", stat="identity")

x7 = dim(SimulationResults_n7)[1]
PlotData_n7 = data.table(k = rep(SimulationResults_n7$k,2),
                         phyloDec = c(SimulationResults_n7$NR_FAlg_pos,
                                      SimulationResults_n7$NR_PhyloDec),
                         category = c(rep("Algorithm",x7),rep("4WPP",x7)))
ggplot(data=PlotData_n7, aes(fill=category, y=phyloDec, x=k)) + 
  geom_bar(position="dodge", stat="identity")

x8 = dim(SimulationResults_n8)[1]
PlotData_n8 = data.table(k = rep(SimulationResults_n8$k,2),
                         phyloDec = c(SimulationResults_n8$NR_FAlg_pos,
                                      SimulationResults_n8$NR_PhyloDec),
                         category = c(rep("Algorithm",x8),rep("4WPP",x8)))
ggplot(data=PlotData_n8, aes(fill=category, y=phyloDec, x=k)) + 
  geom_bar(position="dodge", stat="identity")

#' # Scatter plots ####
#' ***

ggplot(SimulationResults_n6,aes(x=k,y=posRate)) +
  geom_point() +
  geom_line(linetype = "dashed", color = "blue") + 
  scale_x_continuous('No. of used quadruples') +
  scale_y_continuous ('True Positive Rate')

ggplot(SimulationResults_n7,aes(x=k,y=posRate)) +
  geom_point() +
  geom_line(linetype = "dashed", color = "blue") + 
  scale_x_continuous('No. of used quadruples') +
  scale_y_continuous ('True Positive Rate')

ggplot(SimulationResults_n8,aes(x=k,y=posRate)) +
  geom_point() +
  geom_line(linetype = "dashed", color = "blue") + 
  scale_x_continuous('No. of used quadruples') +
  scale_y_continuous ('True Positive Rate')

#' # Vier-Feldertafel ####
#' ***
#' * Prevalence = actual positive (P) / all (N+P)
#' * PPV = Positive Predictive Value = true positives (TP) / predicted positives (PP)
#' * NPV = Negative Predictive Value = true negatives (TN) / predicted negatives = bedingte Wahrscheinlichkeit P(wahrer Zustand negativ | Prädiktion negativ)
#' * TPR = True Positive Rate = sensitivity = power = TP / P
#' * TNR = True Negative Rate = specificity = TN / N
#' * see also [Wikipedia](https://en.wikipedia.org/wiki/Positive_and_negative_predictive_values)
#' 
stats_n6 = my4FTFunction(P = sum(SimulationResults_n6$NR_PhyloDec),
                         N = sum(SimulationResults_n6$NR_NotPhyloDec),
                         PP = sum(SimulationResults_n6$NR_FAlg_pos))
stats_n6

stats_n7 = my4FTFunction(P = sum(SimulationResults_n7$NR_PhyloDec),
                         N = sum(SimulationResults_n7$NR_NotPhyloDec),
                         PP = sum(SimulationResults_n7$NR_FAlg_pos))
stats_n7

stats_n8 = my4FTFunction(P = sum(SimulationResults_n8$NR_PhyloDec),
                         N = sum(SimulationResults_n8$NR_NotPhyloDec),
                         PP = sum(SimulationResults_n8$NR_FAlg_pos))
stats_n8

stats = rbind(stats_n6,stats_n7,stats_n8)
stats

#' **Fazit 1**: NPV ist in der Simulation relativ konstant bei 98%, d.h. mit 98%-iger Wahrscheinlichkeit ist ein negatives Set auch wirklich nicht phylogentisch entscheidend. 
#' 
#' **Fazit 2**: Die Gesamt-Power nimmt ab. 
#' 
#' Was passiert, wenn man das pro k macht?

dumTab = foreach(i = 1:x6)%do%{
  #i=1
  stats_k = my4FTFunction(P = SimulationResults_n6$NR_PhyloDec[i],
                        N = SimulationResults_n6$NR_NotPhyloDec[i],
                        PP = SimulationResults_n6$NR_FAlg_pos[i])
  stats_k[,n :=6]
  stats_k[,k := i]
  stats_k
  
}
stats_n6_byk = rbindlist(dumTab)

dumTab = foreach(i = 1:x7)%do%{
  #i=1
  stats_k = my4FTFunction(P = SimulationResults_n7$NR_PhyloDec[i],
                        N = SimulationResults_n7$NR_NotPhyloDec[i],
                        PP = SimulationResults_n7$NR_FAlg_pos[i])
  stats_k[,n :=7]
  stats_k[,k := i]
  stats_k
  
}
stats_n7_byk = rbindlist(dumTab)

dumTab = foreach(i = 1:x8)%do%{
  #i=1
  stats_k = my4FTFunction(P = SimulationResults_n8$NR_PhyloDec[i],
                        N = SimulationResults_n8$NR_NotPhyloDec[i],
                        PP = SimulationResults_n8$NR_FAlg_pos[i])
  stats_k[,n :=8]
  stats_k[,k := i]
  stats_k
  
}
stats_n8_byk = rbindlist(dumTab)

stats_byk = rbind(stats_n6_byk,stats_n7_byk,stats_n8_byk)

boxplot(stats_byk$TPR ~ stats_byk$n,
        xlab = "number of taxa",
        ylab = "power")
boxplot(stats_byk$NPV ~ stats_byk$n,
        xlab = "number of taxa",
        ylab = "NPV")

tab6 = stats_byk[n==6,summary(TPR)]
tab7 = stats_byk[n==7,summary(TPR)]
tab8 = stats_byk[n==8,summary(TPR)]

tab_TPR = rbind(tab6,tab7)
tab_TPR

tab6_NPV = stats_byk[n==6,summary(NPV)]
tab7_NPV = stats_byk[n==7,summary(NPV)]
tab8_NPV = stats_byk[n==8,summary(NPV)]

tab_NPV = rbind(tab6_NPV,tab7_NPV,tab8_NPV)
tab_NPV

#' # SessionInfo ####
#' ***
sessionInfo()
message("\nTOTAL TIME : " ,round(difftime(Sys.time(),time0,units = "mins"),3)," minutes")
