#' @title Get all possible quadruples given a 4-way partition
#' @description Get all possible quadruples given a 4-way partition 
#' @param y1 Numeric vector, elements of subset 1
#' @param y2 Numeric vector, elements of subset 1
#' @param y3 Numeric vector, elements of subset 1
#' @param y4 Numeric vector, elements of subset 1
#' @return Character with all possible quadruples given the partition
#' @seealso
#'  \code{\link[data.table]{as.data.table}}
#' @rdname getAllPosQuads
#' @export
#' @importFrom data.table as.data.table
#' @importFrom foreach foreach
getAllPosQuads = function(y1,y2,y3,y4){
  # y1 = myRow$set1
  # y2 = myRow$set2
  # y3 = myRow$set3
  # y4 = notmyX
  dum = c(y1,y2,y3,y4)
  stopifnot(sum(duplicated(dum))==0)
  
  quads = c()
  for(t in 1:length(y1)){
    # t=1
    set1 = y1[t]
    for(u in 1:length(y2)){
      # u=1
      set2 = y2[u]
      for(v in 1:length(y3)){
        # v=1
        set3 = y3[v]
        for(w in 1:length(y4)){
          # w=1
          set4 = y4[w]
          myY = c(set1,set2,set3,set4)
          myY = myY[order(myY)]
          quad = paste(myY[1],myY[2],myY[3],myY[4],sep="_") 
          quads = c(quads,quad)
        }
      }
    }
  }
  
  quads = quads[order(quads)]
  myQuads <-paste(quads, collapse = "|")
  return(myQuads)
}
