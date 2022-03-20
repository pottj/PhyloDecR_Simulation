my4FTFunction = function(P,N,PP){
  # P = PhyloPos
  # N = PhyloNeg
  # PP = FischerPos
  
  TP = PP
  TN = N
  FP = 0
  FN = P-PP
  PN = TN + FN 
    
  PPV = TP/PP
  NPV = TN/PN
  FDR = FP/PP
  FOR = FN/PN
  
  Sensitivity = TP/P
  Specificity = TN/N
  FNR = FN/P
  FPR = FP/N
  
  prev = P/(P+N)
  
  x = data.table(Prevalence = prev, 
                 PPV = PPV,
                 NPV = NPV,
                 TPR = Sensitivity,
                 TNR = Specificity) 
  return(x)
}
