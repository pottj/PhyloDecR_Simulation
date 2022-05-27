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
    
    # Step 1: my Algorithm
    # test_1 = initialCheck(data = data3)
    time0 = Sys.time()
    test_1 = runAlgorithm(data = data3, verbose = F)
    time1 = Sys.time()
    diff_1 =  round(difftime(time1,time0,units = "sec"),3)
    filt1 = test_1$status == "unresolved"
    if(sum(filt1)==0){
      test_1_res = "FTT - Pott"
      test_1_rounds = max(test_1$round)
    } else {
      test_1_res = "not resolvable"
      test_1_rounds = max(test_1$round) + 1
    } 
    
    # Step 2: Fischer Algorithm
    time0 = Sys.time()
    test_2 = FixingTaxonTraceability_v3(data = data3, verbose = F)
    time1 = Sys.time()
    diff_2 =  round(difftime(time1,time0,units = "sec"),3)
    filt2 = test_2$status == "unresolved"
    test_2_rounds = max(test_2$round)
    if(sum(filt2)==0){
      test_2_res = "FTT - Fischer"
    } else {
      test_2_res = "not resolvable"
    } 
 
    # Step 3: exakt test with 4WPP
    time0 = Sys.time()
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
    time1 = Sys.time()
    diff_3 =  round(difftime(time1,time0,units = "sec"),3)
    
    filt3 = myTab1$count == 0
    if(sum(filt3)==0){
      test_3_res = "PhyloDec"
    } else {
      test_3_res = "NOT PhyloDec"
    }  
    
    # Step 4: summary
    quads = data3[status == "input", paste(quadruple, collapse ="|")]
    res = data.table(myAlg = test_1_res,
                     myAlg_time = diff_1,
                     myAlg_round = test_1_rounds,
                     FischersAlg = test_2_res,
                     FischersAlg_time = diff_2,
                     FischersAlg_round = test_2_rounds,
                     FWPP = test_3_res,
                     FWPP_time = diff_3,
                     input = quads)
    res
  }
  dumTab = rbindlist(dumTab)
  return(dumTab)
  
}
