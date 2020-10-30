N=1e6 # pool of choices, each experiment has N options to choice from, regardless of the previous experiments' results. These N choices (outcome space) are equally likely, i.e. with equal chance of 1/N to appear in each experiment.

record = vector()
for (i in 1:10000) {
  print(i)
  
  X <- vector()
  x = sample.int(N, size = 1, replace = T)
  
  position = 1
  k = 1
  while (!(x %in% X)) {
    if (k>=10000){break}
    else{
      X = c(X, x)
      x = sample.int(N, size = 1, replace = T)
      # list.append(X, x)
      position = position + 1
      k = k + 1
    }
  }
  if (x %in% X) {
    record = c(record, position)
    # list.append(record, position)
  }
}
hist(record, breaks = 50)
