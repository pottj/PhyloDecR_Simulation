myStirlingFunction = function(n,k){
  # k=4
  # n=8
  
  y=c()
  for(i in 0:k){
    #i=0
    x = (-1)^i *  choose(k,i) * (k-i)^n
    y = c(y,x)

  }
  y
  y2 = sum(y)
  y3 = y2 / factorial(k)
  return(y3)
}
