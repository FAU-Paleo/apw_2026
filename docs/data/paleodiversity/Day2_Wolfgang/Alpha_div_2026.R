# Alpha Diversity
# Script for course

library(vegan)

# download from PBDB Middle Triassic community data from Stiller (2001) in South China
# Bangtoupo, Qingyan, China: Pelsonian - Illyrian, China

url <- "https://paleobiodb.org/data1.2/occs/list.csv?coll_id=31610,31611,31612,31613,31614,31615,31616,31617,31618&show=class,abund,ecospace"
temp <- read.csv(file = url)

table(temp$collection_no)

# PBDB collection 31618
# Bangtoupo F30, Qingyan, China: Pelsonian - Illyrian, China

 # Explore only one sample
  coll <- 31617
  dat <- subset(temp, collection_no==coll)

  cl <- length(levels(factor(dat$class))) # Number of classes
  gen <- length(levels(factor(dat$genus))) # Number of genera

  # limit analysis to taxa identified to genus or species level
   dat <- subset(dat, accepted_rank=="genus" | accepted_rank=="species")
  
attach(dat) # to avoid the need of $ signs, important to detach after analyses

# Compute diversity indices manually
# Immediate values
 S <- nrow(dat) # = number of species
 N <- sum(abund_value) # N

 menh <- S/sqrt(N) # Menhinick Index
 marg <- (S-1)/log(N) # Margalef Index

# Prepare data for other indices
 psp <- abund_value/N  # Proportions of each individual in assemblage
 sha <- psp*log(psp)  # For Shannon-Index
 p2 <- psp^2        # For Hurlbert's PIE and Simpson's index
 Dn <- sum(abund_value*(abund_value-1)) # for true Simpson

 # Calculate indices
      H <- -sum(sha)             ## Shannon H
      J <- H/log(S)              ## Shannon J
      E <- exp(H)/S              ## Equitability
      pD <- max(psp)             ## Berger-Parker Dominanz
      D1 <- sum(p2)               ## Simpson's Dominance
      SD <- 1-D1
      D2 <- (N*(N-1))/Dn
      PIE <- S/(S-1)*(1-sum(p2)) ## Hurlbert's PIE
 
  # Fisher's alpha  S = a ln(1+N/a) 
     alpha <- 1
     F <- 1
     while(F <= S) {
           F <- alpha * log(1+N/alpha)
           alpha <- alpha+0.0001
            }


  # Hill number
     # D=(SUM p_i^q)^(1/(1-q))
     q = 0
     q = 0.99999 # Modify here, Do not use q = 1 but rather q = 0.999
     q = 99 # 
     
     if (q!=1) D <- sum(psp^q)^(1/(1-q))
     if (q== 1) D <- exp(-sum(psp * log(psp))) 
     
      
    exp(H) # for q=1
    1/D1 # for q=2
    
          
    # Create a loop to compute Hill numbers for q values between 0 and 5
     D <- numeric()
     q <- numeric()
     q. <- seq(0, 5, 0.01)
     for (i in 1:length(q.)){
       q <- q.[i]
       if (q!=1) D[i] <- sum(psp^q)^(1/(1-q))
       if (q== 1) D[i] <- exp(-sum(psp * log(psp))) 
    
     }
     
     plot(q., D, pch=1)

  # Use renyi function in vegan package to retrieve diversity estimates
     renyi(abund_value, scales= c(0, 1, 2), hill=TRUE)
     
     
     
 ##### Subsampling ####
     # Empirical rarefaction
      # Get one rarefied diversity value for 100 individuals
    abu <- rep(identified_name, abund_value)
     
     trial <- 100 # subsampling trials
     quota <- 100 # subsampling quota
     div <- numeric()
     
     for (i in 1:trial) {
       z <- sample(abu, quota) # subsampling without replacement
       div[i] <- length(levels(factor(z)))    
     }  
      
     mean(div)
     sd(div)
     
     # Expected number of species according to Good (1953)
     E.Sm <- S - sum((1-psp)^quota) 
     E.Sm
     
   # Empirical rarefaction curve
     # Expected number of species if x individuals are collected

     trial <- 200 # subsampling trials
        rardiv <- numeric()
         erdiv <- numeric()
       count <- 1 
        sq <- seq(1, 481, by=5)
     for (j in sq)  {    # loop for the quota

      div <- numeric(trial)

     for (i in 1:trial) { # loop for the trial
       z <- sample(abu, j) # subsampling without replacement
       div[i] <- length(levels(factor(z)))    
           }  

      # Rarefied diversity
       rardiv[count] <- mean(div)
       erdiv[count] <- sd(div)
      count <- count+1
  }

        plot(sq, rardiv, type="l", col="red")
         #segments(sq, rardiv-erdiv, sq, rardiv+erdiv)
         lines(sq, rardiv-erdiv, col="grey")
         lines(sq, rardiv+erdiv, col="grey")
         
### Shareholder quorum subsampling
      # Good's U (coverage)
         single <- length(abund_value[abund_value==1]) 
         u <- 1-single/N
         
    # We use a simple script of Steve Holland to load the function   
        source("sqs_Holland.R")
      
       sqs0.7 <- sqs(abund_value, quota=0.7)  
       sqs0.5 <- sqs(abund_value, quota=0.5) 
       sqs0.3 <- sqs(abund_value, quota=0.3)   
        
# Summarize results
resname <- c("PBDB.Collection", "Species", "Individuals", "H", "J", "Simpson's D", "1-D", "PIE", "Berger-Parker", "Fisher's alpha",
   "Margalef", "Menhinick", "Rarefied.200", "SD_Rarefied.200", "SQS0.7")                       
resu <- c(coll, S, N, H, J, SD, 1-SD, PIE, pD, alpha, marg, menh, rardiv[41], erdiv[41], sqs0.7)
resround <- round(resu, 3)
x <- data.frame(cbind(resname, resround))

write.table(x, file="Result_div1.csv", sep=",", row.names=FALSE)
getwd()


##### Vegan package ####
library(vegan)
specnumber(abund_value)
diversity(abund_value)
diversity(abund_value, "simpson")
fisher.alpha(abund_value)
rarefy(abund_value, seq(5,210,by=5)) # rarefaction


plot(sort(abund_value, decreasing=TRUE), log="y")

####
#### Rank-abundance curves ####
 z <- sort(abund_value, decreasing=T)
 p.z <- sort(psp, decreasing = T)
 op <- par(cex=1.5, lwd=1.5, mar=c(5,4,2,1), mfrow=c(2,2))

 # Linear plot
 plot(z, type="b", xlab="Rank", ylab="Abundance", col="red", lwd=2)

 # Log plot
 plot(z, type="b", log="y", xlab="Rank", ylab="Abundance", col="red", lwd=2)

 # Cummulative plot
 plot(cumsum(z), type="l", log="y", xlab="Rank", ylab="Abundance", col="red", lwd=2)
 
 # Log proportions
 plot(p.z, type="b", log="y", xlab="Rank", ylab="Abundance", col="red", lwd=2)
 
par(op)


# Create model distributions given data
 # Normal distribution
   Nm <- mean(abund_value)
   Nsd <- sd(abund_value)
    nsa <- rnorm(S, Nm, Nsd)
    hist(nsa)
     z2 <- sort(nsa, decreasing=T)
     plot(z2, type="l", log="y", xlab="Rank", ylab="Abundance", col="red", lwd=2)
 # Lognormal distribution
    lN <- log(abund_value)
    lNm <- mean(lN)
    lNsd <- sd(lN)
    lsa <- rlnorm(S, lNm, lNsd) 
    hist(lsa)
     z3 <- sort(lsa, decreasing=T)
     plot(z3, type="l", log="y", xlab="Rank", ylab="Abundance", col="red", lwd=2)
     lsa <- sort(round(lsa), decreasing=T)+1
 # Geometric series
   # Determine rate
      z <- sort(abund_value, decreasing=T)
       zn <- z[1] # use dominant
       rt <- S/zn/min(abund_value) # overall slope
       z4 <- numeric()
       for (i in 1:S) z4 <- c(zn, z4/rt)
       # use regression model
       reg <- lm(log(z) ~ seq(1,length(z)))
       reg2 <- exp(predict(reg))
     plot(reg2, type="l", log="y", xlab="Rank", ylab="Abundance", col="red", lwd=2)

   

### Multiplot
plot(z, type="b", log="y", xlab="Rank", ylab="Abundance", col="red", lwd=2)
 points(z2, type="l", col="grey") # Broken Stick
 points(z3, type="l", col="blue") # 
 points(reg2, type="l", col="green")

 library(vegan)
 X11()
 fit <- radfit(abund_value)
 plot(fit, main=paste("PBDB collection", coll))
 
fit
 
detach(dat)
 

##### Exercise ####
# Now use the vegan package to compute S, H, J, and Hill Diversities for q = 1 and 2
# for the other samples 

 
   