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
#' Was habe ich simuliert?
#' 
#' 1) Vorbereitungen: 
#'    * alle möglichen Quadrupel für n=6, 7, und 8 erstellt
#'    * alle möglichen 4-way-partitions  für n=6, 7, und 8 erstellt
#' 2) Schleife pro k (Anzahl Input-Quadrupels)
#' 3) Simulation mit 10,000 Wiederholungen, d.h. 10,000 mal ein zufälliges Set aus k Quadrupeln erstellt und getestet, ob phylogenetisch entscheidend nach 4WPP und nach Fischers Algorithmus (Wahrheit vs Vorhersage)
#' 4) Alle Simulationsergebnisse sind lokal gespeichert, die Zusammenfassung auch auf github abgelegt.  
#' 
#' Jetzt: Zusammenfassung der Vorhersagegüte erstellen. Dazu will ich ein paar Barplots erstellen (Anzahl phylogenetisch entscheidender Sets gemäß 4WPP und Algorithmus). Zusätzlich will ich für die Testgüte die Parameter der 4-Feldertafeln ausrechnen (negative predictive value, power). 
#' 
#' Ich will die Auswertung einmal über alle k machen und einmal ab meinem Schrankenwert aus der MA: 
#' 
#' Upper border: Ab einer Quadrupelanzahl größer oder gleich $\binom{n}{4} - (n-4)$ sind alle Sets phylogenetisch entscheidend.
#' 
#' * n=6: 15-2 = 13
#' * n=7: 35-3 = 32
#' * n=8: 70-4 = 66
#' 
#' Lower border: Keine einfache Formel für alle n. Ich nutze hier die Anzahl mit der alle Triple mindestens einmal abgedeckt sind. Siehe MA S. 9
#' 
#' * n=6: 6
#' * n=7: 11
#' * n=8: 14
#' 
#' # Init ####
#' ***
rm(list = ls())
time0<-Sys.time()

.libPaths("C:/userprograms/R_4.1.1/")
library(data.table)
library(ggplot2)
library(foreach)

source("../helperFunctions/my4FTFunction.R")

x6_lb = 6
x6_ub = 13
x7_lb = 11
x7_ub = 32
x8_lb = 14
x8_ub = 66

#' # Get data ####
#' ***
#' n=6, n=7, und n=8
load("../results/SimulationResults_n6.RData")
load("../results/SimulationResults_n7.RData")
load("../results/SimulationResults_n8.RData")

sim_n6 = SimulationResults_n6[k>=x6_lb & k<=x6_ub]
sim_n7 = SimulationResults_n7[k>=x7_lb & k<=x7_ub]
sim_n8 = SimulationResults_n8[k>=x8_lb & k<=x8_ub]

#' # Bar plots ####
#' ***
x6 = dim(sim_n6)[1]
PlotData_n6 = data.table(k = rep(sim_n6$k,2),
                         phyloDec = c(sim_n6$NR_FAlg_pos,
                                      sim_n6$NR_PhyloDec),
                         category = c(rep("Algorithm",x6),rep("4WPP",x6)))
ggplot(data=PlotData_n6,aes(fill=category, y=phyloDec, x=k)) + 
  geom_bar(position="dodge", stat="identity")

x7 = dim(sim_n7)[1]
PlotData_n7 = data.table(k = rep(sim_n7$k,2),
                         phyloDec = c(sim_n7$NR_FAlg_pos,
                                      sim_n7$NR_PhyloDec),
                         category = c(rep("Algorithm",x7),rep("4WPP",x7)))
ggplot(data=PlotData_n7,aes(fill=category, y=phyloDec, x=k)) + 
  geom_bar(position="dodge", stat="identity")

x8 = dim(sim_n8)[1]
PlotData_n8 = data.table(k = rep(sim_n8$k,2),
                         phyloDec = c(sim_n8$NR_FAlg_pos,
                                      sim_n8$NR_PhyloDec),
                         category = c(rep("Algorithm",x8),rep("4WPP",x8)))
ggplot(data=PlotData_n8, aes(fill=category, y=phyloDec, x=k)) + 
  geom_bar(position="dodge", stat="identity")

#' # Scatter plots ####
#' ***
ggplot(sim_n6,aes(x=k,y=posRate)) +
  geom_point() +
  geom_line(linetype = "dashed", color = "blue") + 
  scale_x_continuous('No. of used quadruples') +
  scale_y_continuous ('True Positive Rate')

ggplot(sim_n7,aes(x=k,y=posRate)) +
  geom_point() +
  geom_line(linetype = "dashed", color = "blue") + 
  scale_x_continuous('No. of used quadruples') +
  scale_y_continuous ('True Positive Rate')

ggplot(sim_n8,aes(x=k,y=posRate)) +
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
stats_n7 = my4FTFunction(P = sum(SimulationResults_n7$NR_PhyloDec),
                         N = sum(SimulationResults_n7$NR_NotPhyloDec),
                         PP = sum(SimulationResults_n7$NR_FAlg_pos))
stats_n8 = my4FTFunction(P = sum(SimulationResults_n8$NR_PhyloDec),
                         N = sum(SimulationResults_n8$NR_NotPhyloDec),
                         PP = sum(SimulationResults_n8$NR_FAlg_pos))
stats = rbind(stats_n6,stats_n7,stats_n8)
stats

stats_n6 = my4FTFunction(P = sum(sim_n6$NR_PhyloDec),
                         N = sum(sim_n6$NR_NotPhyloDec),
                         PP = sum(sim_n6$NR_FAlg_pos))
stats_n7 = my4FTFunction(P = sum(sim_n7$NR_PhyloDec),
                         N = sum(sim_n7$NR_NotPhyloDec),
                         PP = sum(sim_n7$NR_FAlg_pos))
stats_n8 = my4FTFunction(P = sum(sim_n8$NR_PhyloDec),
                         N = sum(sim_n8$NR_NotPhyloDec),
                         PP = sum(sim_n8$NR_FAlg_pos))
stats2 = rbind(stats_n6,stats_n7,stats_n8)
stats2

#' **Fazit 1**: NPV ist in der Simulation relativ konstant bei 98%, d.h. mit 98%-iger Wahrscheinlichkeit ist ein negatives Set auch wirklich nicht phylogentisch entscheidend. 
#' 
#' **Fazit 2**: Die Gesamt-Power nimmt zu. 
#' 
#' Was passiert, wenn man das pro k macht?

dumTab = foreach(i = 1:dim(SimulationResults_n6)[1])%do%{
  #i=1
  stats_k = my4FTFunction(P = SimulationResults_n6$NR_PhyloDec[i],
                        N = SimulationResults_n6$NR_NotPhyloDec[i],
                        PP = SimulationResults_n6$NR_FAlg_pos[i])
  stats_k[,n :=6]
  stats_k[,k := i]
  stats_k[,status := "bad"]
  if(i>=x6_lb & i<= x6_ub)stats_k[,status := "good"]
  stats_k
  
}
stats_n6_byk = rbindlist(dumTab)

dumTab = foreach(i = 1:dim(SimulationResults_n7)[1])%do%{
  #i=1
  stats_k = my4FTFunction(P = SimulationResults_n7$NR_PhyloDec[i],
                        N = SimulationResults_n7$NR_NotPhyloDec[i],
                        PP = SimulationResults_n7$NR_FAlg_pos[i])
  stats_k[,n :=7]
  stats_k[,k := i]
  stats_k[,status := "bad"]
  if(i>=x7_lb & i<= x7_ub)stats_k[,status := "good"]
  stats_k
  
}
stats_n7_byk = rbindlist(dumTab)

dumTab = foreach(i = 1:dim(SimulationResults_n8)[1])%do%{
  #i=1
  stats_k = my4FTFunction(P = SimulationResults_n8$NR_PhyloDec[i],
                        N = SimulationResults_n8$NR_NotPhyloDec[i],
                        PP = SimulationResults_n8$NR_FAlg_pos[i])
  stats_k[,n :=8]
  stats_k[,k := i]
  stats_k[,status := "bad"]
  if(i>=x8_lb & i<= x8_ub)stats_k[,status := "good"]
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

filt = stats_byk$status =="good"
boxplot(stats_byk$TPR[filt] ~ stats_byk$n[filt],
        xlab = "number of taxa",
        ylab = "power")
boxplot(stats_byk$NPV[filt] ~ stats_byk$n[filt],
        xlab = "number of taxa",
        ylab = "NPV")

tab6 = stats_byk[n==6,summary(TPR)]
tab7 = stats_byk[n==7,summary(TPR)]
tab8 = stats_byk[n==8,summary(TPR)]
tab_TPR1 = rbind(tab6,tab7,tab8)
tab6 = stats_byk[n==6 & filt,summary(TPR)]
tab7 = stats_byk[n==7 & filt,summary(TPR)]
tab8 = stats_byk[n==8 & filt,summary(TPR)]
tab_TPR2 = rbind(tab6,tab7,tab8)

tab6_NPV = stats_byk[n==6,summary(NPV)]
tab7_NPV = stats_byk[n==7,summary(NPV)]
tab8_NPV = stats_byk[n==8,summary(NPV)]
tab_NPV1 = rbind(tab6_NPV,tab7_NPV,tab8_NPV)
tab6_NPV = stats_byk[n==6 & filt,summary(NPV)]
tab7_NPV = stats_byk[n==7 & filt,summary(NPV)]
tab8_NPV = stats_byk[n==8 & filt,summary(NPV)]
tab_NPV2 = rbind(tab6_NPV,tab7_NPV,tab8_NPV)

tabs = rbind(tab_NPV1,tab_NPV2,tab_TPR1,tab_TPR2)
rownames(tabs) = c("NPV_n6","NPV_n7","NPV_n8",
                   "NPV_n6_filtered","NPV_n7_filtered","NPV_n8_filtered",
                   "TPR_n6","TPR_n7","TPR_n8",
                   "TPR_n6_filtered","TPR_n7_filtered","TPR_n8_filtered")
tabs

#' # SessionInfo ####
#' ***
sessionInfo()
message("\nTOTAL TIME : " ,round(difftime(Sys.time(),time0,units = "mins"),3)," minutes")
