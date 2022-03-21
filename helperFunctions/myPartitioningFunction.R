#' @title Get all possible 4-way partitions for a given type
#' @description Get all possible 4-way partitions given the cardinality of the four subsets. 
#' @param z1 Numeric, Cardinality of subset 1
#' @param z2 Numeric, Cardinality of subset 1
#' @param z3 Numeric, Cardinality of subset 1
#' @param z4 Numeric, Cardinality of subset 1
#' @return Data.table with all possible 4-way partitions for the given type and all possible quadruples given the partition
#' @seealso
#'  \code{\link[data.table]{as.data.table}}
#' @rdname myPartitioningFunction
#' @export
#' @importFrom data.table as.data.table
#' @importFrom foreach foreach
myPartitioningFunction = function(z1,z2,z3,z4){
  # z1 = 2
  # z2 = 2
  # z3 = 2
  # z4 = 2
  n=sum(z1,z2,z3,z4)
  x = c(1:n)

  # step 1: create set 1 (all combinations) - using index i
  a = t(combn(n,z1))
  a1 = dim(a)[1]
  
  dumTab1 = foreach(i = 1:a1)%do%{
    # i=1
    a2 = a[i,]
    
    x0 = x[a2]
    x1 = x[!is.element(x,x0)]
    myRow1 = data.table::data.table(set1 = paste(x0,collapse = "|"))
    
    # step 2: create set 2 (all combinations) - using index j
    b = t(combn(length(x1),z2))
    b1 = dim(b)[1]
    
    dumTab2 = foreach(j = 1:b1)%do%{
      #j=1
      b2 = b[j,]
      myRow2 = copy(myRow1)
      
      x2 = x1[b2]
      x3 = x1[!is.element(x1,x2)]
      myRow2[,set2:=paste(x2, collapse = "|")]
      
      # step 3: create set 3 (all combinations) - using index k
      c = t(combn(length(x3),z3))
      c1 = dim(c)[1]
      
      dumTab3 = foreach(k = 1:c1)%do%{
        #k=1
        c2 = c[k,]
        myRow3 = copy(myRow2)
        
        x4 = x3[c2]
        x5 = x3[!is.element(x3,x4)]
        myRow3[,set3:=paste(x4, collapse = "|")]
        myRow3[,set4:=paste(x5, collapse = "|")]
        
        myQuads = getAllPosQuads(y1 = x0,
                                 y2 = x2,
                                 y3 = x4,
                                 y4 = x5)
        
        myRow3[,allQuads := myQuads]
        myRow3
      }
      dumTab3 = rbindlist(dumTab3)
      dumTab3
    }
    dumTab2 = rbindlist(dumTab2)
    dumTab2 = dumTab2[!duplicated(allQuads),]
    dumTab2
  }
  tab = rbindlist(dumTab1)
  head(tab)
  tab = tab[!duplicated(allQuads),]
  
  return(tab)
}
