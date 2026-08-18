 # Load diversity data
  
  tfa <- read.table(file="ThreeFaunas.csv", header=TRUE, sep=";")
   age <- (tfa$HIGH + tfa$LOW)/2

   tf <- subset(tfa, select=c(5:19))

  cor(tf)

  factanal(tf, 2)

  x <- factanal(tf, 3)
  y <- loadings(x)

   cl.fac1 <- which(y[,1]>0.5)
   cl.fac2 <- which(y[,2]>0.5)
   cl.fac3 <- which(y[,3]>0.4)

  mod.faun <- apply(tf[,cl.fac1],1,sum)
  pal.faun <- apply(tf[,cl.fac2],1,sum)
  cam.faun <- apply(tf[,cl.fac3],1,sum)

  tot <- mod.faun + pal.faun + cam.faun

    mag <- max(age)

 # Plot absolute
   plot(age, tot, type="l", xlim=c(550,0), xlab="Age (Ma)", ylab="Number of genera")
    polygon(c(0,mag,age),c(0,0,tot), col="green") # modern fauna
    polygon(c(0,mag,age),c(0,0,pal.faun+cam.faun), col="blue") # paleozoic fauna
    polygon(c(0,mag,age),c(0,0,cam.faun), col="brown") # cambrian fauna

  res <- data.frame(cbind(age, mod.faun, pal.faun, cam.faun))


  write.table(res, file="d:/daten/r/output/three_faunas.csv", sep=";", row.names=F)


 # Plot proportional
    plot(age, tot/tot, type="l", xlim=c(550,0), ylim=c(0,1), xlab="Age (Ma)", 
         ylab="Proportion of genera")
    polygon(c(0,mag,age),c(0,0,tot/tot), col="green") # modern fauna
    polygon(c(0,mag,age),c(0,0,(pal.faun+cam.faun)/tot), col="blue") # paleozoic fauna
    polygon(c(0,mag,age),c(0,0,cam.faun/tot), col="brown") # cambrian fauna  



 # First differences
  d.tf <- diff(as.matrix(tf))

   factanal(d.tf, 3)



##############
 # Extra
  # What happens with four factors?
     x <- factanal(tf, 4)
     y <- loadings(x)

   cl.fac1 <- which(y[,1]>0.5)
   cl.fac2 <- which(y[,2]>0.5)
   cl.fac3 <- which(y[,3]>0.4)
   cl.fac4 <- which(y[,4]>0.2)

  mod.faun <- apply(tf[,cl.fac1],1,sum)
  pal.faun <- apply(tf[,cl.fac2],1,sum)
  cam.faun <- apply(tf[,cl.fac3],1,sum)
  x.faun <- apply(tf[,cl.fac4],1,sum)

 tot <- mod.faun + pal.faun + cam.faun + x.faun
   mag <- max(age)

   plot(age, tot, type="l", xlim=c(550,0), xlab="Age (Ma)", ylab="Number of genera")
    polygon(c(0,mag,age),c(0,0,tot-x.faun), col="green") # modern fauna
    polygon(c(0,mag,age),c(0,0,pal.faun+cam.faun), col="blue") # paleozoic fauna
    polygon(c(0,mag,age),c(0,0,cam.faun), col="brown") # cambrian fauna


 # Plot proportional
    plot(age, tot/tot, type="l", xlim=c(550,0), ylim=c(0,1), xlab="Age (Ma)", 
         ylab="Proportion of genera")
    polygon(c(0,mag,age),c(0,0,(tot-x.faun)/tot), col="green") # modern fauna
    polygon(c(0,mag,age),c(0,0,(pal.faun+cam.faun)/tot), col="blue") # paleozoic fauna
    polygon(c(0,mag,age),c(0,0,cam.faun/tot), col="brown") # cambrian fauna  


