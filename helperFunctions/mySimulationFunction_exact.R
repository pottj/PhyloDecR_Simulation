#' was will ich?
#' Ich will eine Simulation mit Parametern n, number_quads, repeats, datasets
#' 
mySimulationFunction_exact = function(number_taxa, number_quads, repeats, data1, data2, verbose=F){
  # number_taxa = 6
  # number_quads = 10
  # repeats = 100
  # data1 = quadruple_data
  # data2 = myTab_n6
  
  n = number_taxa
  k = number_quads
  
  allQuads = data.table::as.data.table(t(combn(n,4)))
  stopifnot(dim(data1)[1] == dim(allQuads)[1])
  if(verbose == T) message("       Input data matches to given taxa size")
  m = dim(data1)[1]
  
  allCombis = data.table::as.data.table(t(combn(m,k)))
  rep2 = dim(allCombis)[1]
  if(rep2<repeats & verbose == T) message("       Testing all combination only once ...")
  if(rep2<repeats) repeats = rep2 
  if(verbose == T) message("       Working on ",repeats," repeats of ", dim(allCombis)[1]," combinations")
  
  x = sample(x = 1:rep2,size = repeats,replace = F)
  y = seq(1,repeats,by=ceiling(repeats/100))
  
  dumTab = foreach(i = 1:repeats)%do%{
    #i=1
    #if(is.element(i,y) & verbose==T) message("              Working on combination ",i)
    myX = x[i]
    myCombi = as.numeric(allCombis[myX,])
    data3 = copy(data1)
    data3[myCombi,status := "input"]
    data3[is.na(status),status := "unresolved"]
    
    # Step 1: my initial checks
    test_1 = initialCheck(data = data3)
    
    # Step 2: Fischer Algorithm
    test_2 = runAlgorithm(data = data3, verbose = F)
    filt1 = test_2$status == "unresolved"
    if(sum(filt1)==0){
      test_2_res = "PHYLOGENETICALLY DECISIVE"
    } else {
      test_2_res = "NOT RESOLVABLE VIA FISCHERS ALGORITHM"
    }  
    
    # Step 3: exakt test with 4WPP
    dummy1 = data3[status=="input",]
    myTab1 = copy(data2)
    
    for(i in 1:dim(dummy1)[1]){
      #i=1
      myInput = dummy1[i,quadruple]
      filt = grepl(myInput,myTab1$allQuads)
      myTab1[filt==T,status := "covered"]
      myTab1[filt==T,count := count + 1]
      myTab1
    }
    filt2 = myTab1$count == 0
    if(sum(filt2)==0){
      test_3_res = "PHYLOGENETICALLY DECISIVE"
    } else {
      test_3_res = "NOT PHYLOGENETICALLY DECISIVE"
    }  
    
    # Step 4: summary
    quads = data3[status == "input", paste(quadruple, collapse ="|")]
    res = data.table(check1 = test_1[1],
                     check2 = test_1[2],
                     check3 = test_1[3],
                     FischersAlg = test_2_res,
                     FWPP = test_3_res,
                     input = quads)
    res
  }
  dumTab = rbindlist(dumTab)
  return(dumTab)
  
}
