A <- c(60, 5, 5, 5, 5, 5, 5, 5, 5, 5)     # S = 10
B <- c(17, 17, 17, 16, 15, 12)            # S = 6
C <- c(30, 25, 15, 10, 8, 6, 4, 2)        # S = 8



p.A <- A/sum(A)
p.B <- B/sum(B)
p.C <- C/sum(C)



# Create a loop to compute Hill numbers for q values between 0 and 5
D.A <- numeric()
D.B <- numeric()
D.C <- numeric()

q <- numeric()
q. <- seq(0, 5, 0.01)
for (i in 1:length(q.)){
  q <- q.[i]
  if (q!=1) {
   D.A[i] <- sum(p.A^q)^(1/(1-q))
   D.B[i] <- sum(p.B^q)^(1/(1-q))
   D.C[i] <- sum(p.C^q)^(1/(1-q))
  }
   
  if (q== 1) {
    D.A[i] <- exp(-sum(p.A * log(p.A))) 
    D.B[i] <- exp(-sum(p.B * log(p.B))) 
    D.C[i] <- exp(-sum(p.C * log(p.C))) 
  }
}

X11()
plot(q., D.A, type="l", ylim=c(2,10), xlab="q", ylab="Effective number of species",
     main="Diversity profiles", lwd=2, col="red")
lines(q., D.B, lwd=2, col="darkgreen")
lines(q., D.C, lwd=2, col="steelblue")
legend("topright", legend=c("A - Strong dominance","B - Very even", "C -Moderately even"), lwd=2,
       col=c("red", "darkgreen", "steelblue"), lty=1, bty="n")

