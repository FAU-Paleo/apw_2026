# Analyse Sepkoski Database
setwd("d:/daten/R/Lehre")

  stages <- read.table(file="Stage_sepk.csv", header=TRUE, sep=";", quote="\"")



  # Sepkoski compendium with numeric ages and higher taxa
  sepk <- read.table(file="gen_link2.csv", header=TRUE, sep=";", quote="\"")

   sepk <- subset(sepk, EXT_BASE<999 & EXT_TOP<999)


 # Look at the data
 names(sepk)
  table(sepk$CLASS)
  table(sepk$ORDER)
  length(table(sepk$CLASS))
  length(table(sepk$ORDER))
  table(sepk$PHYLUM)
  x <- table(factor(sepk$CLASS))

  # Create subset
   # All data
     ans <- sepk
   # Ecologic subset
    # ans <- subset(sepk, MOBILITY==1)  # 0 = sessile, 1 = mobil
   # Taxonomic subset
    # ans <- subset(sepk, CLASS=="Articulata" | CLASS=="Lingulata")
  #   ans <- subset(sepk, PHYLUM=="Brachiopoda")
    # ans <- subset(sepk, CLASS=="Bivalvia")   # Bivalves
     #ans <- subset(sepk, ORDER=="Hippuritoida")


 attach(stages)

 age1 <- Base
 age2 <- Age


start <- min(St_nr)
end <- max(St_nr)
vl <- end-start+1 # vector length

FL <- numeric(vl) # singletons
bL <- numeric(vl) # extinct in interval
Ft <- numeric(vl) # origin in interval
bt <- numeric(vl) # crossing-through

# Count four possible cases for each stage
  for (i in start:end) {
  FL[i] <- nrow(subset(ans, Base[i]>EXT_BASE & Top[i]<EXT_TOP)) # Singletons
  bL[i] <- nrow(subset(ans, Base[i]>EXT_TOP & Top[i]<=EXT_TOP)) # Extinct with single
  Ft[i] <- nrow(subset(ans, Base[i]>EXT_BASE & Top[i]<EXT_BASE)) # Origin with single
  bt[i] <- nrow(subset(ans, Base[i]<EXT_BASE & Top[i]>EXT_TOP)) # Through-ranging
   } 

 # subtract singletons from bL and Ft
  bL <- bL-FL
  Ft <- Ft-FL

 # Diversity + singletons
  divs <- bL+Ft+bt+FL
 # Diversity curve (traditional) - subtract singletons but include extinct and originating taxa
  div <- bL+Ft+bt
 # Diversity curve based on boundary crossers
  bc <- bL+bt
 # Extinction percentages (traditional)
  ex <- bL/div
 # Origination percentages (traditional)
  or <- Ft/div
 # Extinction percentages based on boundary crossers
  exb <- bL/bc
 # Origination percentages based on boundary crossers
  orb <- Ft/bc
 # Foote extinction metrics
  exF <- -log(bt/(bL+bt))
 # Foote origination metrics
  orF <- -log(bt/(Ft+bt))


detach(stages)

#### Store intermediate results
  div.biv <- div
  bc.biv <- bc
  ext.biv <- exF
  
  div.brach <- div
  bc.brach <- bc
  ext.brach <- exF
  
  
### PLOTS

# Plot diversity curve
  X11(height=6, width=8) # Define window size

  op <- par(xaxs="i", yaxs="i", mfrow=c(1,1)) # 
  
   # Define what to plot
  #x <- age2[10:76]
  # y <- ext.biv[10:76]
  # y2 <- ext.brach[10:76]
  # lg <- "Extinction rate"
  
   x <- age2[1:76]
   y <- exF[1:76]
   y2 <- orF[1:76]
   lg <- "Rate"
   
   # Define borders for legend
     ub <- 0 # Top of rectangle
    # For div and bc
    # bo <- -0.1 # Bottom of rectangle for diversity
    # tb <- 1.4 # Top of graph for diversity
    # For Foote extinction and origination rates
      bo <- -0.08
      tb <- 1.55
    # For global diversity
  #  bo <- -180
     #  bo <- -60
      # tb <- max(y)+0.1*max(y)
    # For percent rates
     # bo <- -0.05
     # tb <- 0.9 
  
     th <- 2.5 # Line thickness in plot
  
   plot(x, y, xlab="Age (Ma)", ylab=lg, pch=16, type="l", 
        col="red", lwd=th, xlim=c(550,0), ylim=c(bo,tb))
   #  points(x, y2, type="l", col="blue", lwd=th) 
   lines(x, y2, col="darkgreen", lwd=th)
   
     abline(v=251, lty=2) # Mark Permian-Triassic boundary
     abline(v=65.5, lty=2) # Mark KT boundary
  
  # Add boxes  for legend of time
    bases <- c(542, 488.3, 443.7, 416, 359.2, 299, 251, 199.6, 145.5, 65.5, 23, 0)
       tpl <- c(515, 468, 430, 390, 330, 275, 226, 175, 105, 45, 10)
       tx <- c("Cm", "O", "S", "D", "C", "P", "Tr", "J", "K", "Pg", "N")
    cols <- rep("white", 13)
  
  # Lines for major boundaries
     abline(v=443.7, lty=2); abline(v=376.1, lty=2); abline(v=251, lty=2); abline(v=199.6, lty=2); abline(v=65.5, lty=2)
   # Add boxes  for legend of time 
    for (b in 1:11) rect(xleft=bases[b], ybottom=bo, xright=bases[b+1], ytop=0, col=cols[b])
   # Add Text for legend of time
   for (t in 1:11) text(x=tpl[t], y=(0+bo)/2, labels=tx[t], cex=0.9)
  
     # legend("topleft", legend=c("Marine genera"), lwd=2, 
     #        col=c("red", "blue"), bg="white") 
     
      legend("topright", legend=c("Extinction rate", "Origination rate"), lwd=2, 
             col=c("red", "darkgreen"), bg="white") 
     
     
   # legend("topleft", legend=c("Bivalves", "Brachiopods"), lwd=2, 
   #        col=c("red", "blue"), bg="white") 
     
  par(op)



###############
 longev <- sepk$EXT_BASE - sepk$EXT_TOP
  hist(longev[longev>0])

   longev.biv <- longev[sepk$CLASS=="Bivalvia"]
   longev.art <- longev[sepk$CLASS=="Articulata"]

  op <- par(mfrow=c(2,1))
   h1 <- hist(longev.biv[longev.biv>0], main="Bivalvia", xlim=c(0,150))
   h2 <- hist(longev.art[longev.art>0], main="Articulata")  
  par(op)
   
  wilcox.test(longev.biv[longev>0],longev.art[longev>0], alternative="greater")
   boxplot(longev.biv, longev.art)
    