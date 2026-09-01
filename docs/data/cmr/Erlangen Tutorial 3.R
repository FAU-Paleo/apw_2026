#Lee Hsiang Liow Tutorial 3 for Erlangen
#Updated Aug 2025

#Tutorial 3
rm(list=ls())
#read in PBDB from Adam's 2024 lectures https://fau-paleo.github.io/apw_2024/paleodiversity/ sorry no time to update!
pbdb <- readRDS("pbdb_processed_2024-07-11.rds")
#takes a while to read this don't worry

#subset it
data=subset(pbdb, select=c("phylum", "class", "order", "family", "accepted_rank", "genus", "collection_no", "time_bins", "max_ma", "min_ma"))

#useful for input data for openCR (historically coming from serc)
#https://www.otago.ac.nz/density/pdfs/secr-datainput.pdf
library(openCR) 

# we will work on genus level, let's check everything looks ok; check you know what the columns mean 
head(unique(data$genus)[order(unique(data$genus))])
length(unique(data$genus))

#let's reduce the dataset a bit and only work on, say bivalves of the Cenozoic (you can try other groups yourself)
biv=data[which(data$class=="Bivalvia" & data$max_ma <= 66),]
head(biv) 
length(unique(biv$genus)) #1252 genera
     
#some Orders have more data than others. Do you think you can get estimate the taxonomic of richness  of Cyrtodontida or Hippuritida
#using PBDB data? What about Trigoniida or Unionida?
table(biv$order)

#let's explore the data a bit first. We sometimes have to convert the data types to be able to work further.
str(biv)

biv$genus=as.factor(biv$genus) #make genus a factor rather than just a character string    
biv$time_bins=as.factor(biv$time_bins)  #make time_bins (the names of stages) a factor rather than just a character string 
biv$mid_age=(biv$max_ma+biv$min_ma)*0.5   #get the mid point of the max and min ages for each observation (for convenience)   
str(biv) # better

# I am going to randomly assign a covariate at genus level to this data to show you how to do simple covariate analyses 
genera=as.data.frame(unique(biv$genus))
colnames(genera)=c("genera")
genera$covariate=runif(dim(genera)[1],min=0,max=1)
genera$covariate=replace(genera$covariate, which(genera$covariate>0.5), 1)
genera$covariate=replace(genera$covariate, which(genera$covariate<=0.5), 0)
one=genera$genera[which(genera$covariate==1)] #those bivalve genera assigned covariate state = 1 (e.g. pretend they are epifaunal, and 0 = infaunal)

biv$covariate=0
biv$covariate=replace(biv$covariate, which(biv$genus %in% one), 1)

#quick a dirty look at the temporal distribution of the data we downloaded: 
par(mfrow=c(1,1))
hist(-biv$mid_age, axes=F, xlab="mya chunks", main="observations of cenozoic bivalve genera") 
axis(2)
axis(1, at=seq(-60,0, 10), labels=seq(60,0, -10))
box()
#you see that there is the "pull of the recent". and that there is a gap between 50-45 mya.
#do you think there are no bivalves on earth at that time? What might happen when you standardize to the "lowest denominator" by time-interval?

#let's assign the data to standard stages, get the data for stages in first. You can also do it from the pbdb data itself
#in many different ways. I had this information lying around, so we are just using what I had from before.
stages=c("Danian","Selandian","Thanetian",
"Ypresian", "Lutetian", "Bartonian",  "Priabonian",
"Rupelian", "Chattian", "Aquitanian", "Burdigalian","Langhian", "Serravallian",
"Tortonian","Messinian","Zanclean","Piacenzian","Gelasian","Calabrian", "Almost.now")
max=c(66, 61.6,  59.2, 56, 47.8, 41.3, 38,33.9,28.1, 23.03,  20.44,
      15.97, 13.82, 11.62,7.246, 5.333, 3.6, 2.58,1.8,  0.781)
min=c(61.6, 59.2,56, 47.8, 41.3, 38, 33.9,  28.1, 23.03, 20.44,
       15.97,13.82, 11.62, 7.246, 5.333, 3.6, 2.58, 1.8, 0.781, 0)
num=seq(1,20,1)
stages=as.data.frame(cbind(stages, max, min, num))
stages$stages=as.factor(stages$stages)
stages$max=as.numeric(stages$max)
stages$min=as.numeric(stages$min)
stages$mid=-(stages$max+stages$min)*0.5
stages$num=as.numeric(stages$num)
breaks=c(-(stages$max),0 )
stages$bins = cut(stages$mid, breaks=breaks) 
stages$dur=stages$max-stages$min

#look at data
stages

#make sure the bivalve data is equivalent
biv$bins = cut(-biv$mid_age, breaks=breaks)
#merge the stage datta with the pbdb data
biv=merge(biv,stages, by="bins")

#check it looks good
head(biv)
tail(biv)

#make openCR format
trapXY.1=trapXY[1,] #all traps the same number, trapXY is from Open.CR, just lazy copying 
#but because we are not using spatial data, it doesn't matter. It's just that these cannot be missing the way
#funcstuins are set up in openCR
dummytraps <- read.traps(data = trapXY.1)

#now we will set it up like openCR wants it, it wants Sessions and IDs and trapID's minimally and the Occasion
#has the temporal sequence

detection=as.data.frame(rep(1, dim(biv)[1]))
colnames(detection)=c("Session") #one session
detection$ID=biv$genus
detection$Occasion=biv$num#ordered bin
detection$trapID=rep(1, dim(biv)[1])
detection$faunality=biv$covariate

dnd.matrix=suppressWarnings(make.capthist (detection, dummytraps, fmt = "trapID", covnames="faunality"))
#EpiF=subset(dnd.matrix, covariates(dnd.matrix)$covariate==1) #epifaunal bivalves
#InF=subset(dnd.matrix, covariates(dnd.matrix)$covariate==0) #infaunal bivalves
#take a peak 
dnd.matrix #typical single-session capture recapture data where 1 is observed and 0 is not observed.

JS.direct.est=JS.direct(dnd.matrix)
?JS.counts #will explain the parameters you see 
?JS.direct #will explain the parameters you see 
#e.g. n = detected, R released, m= previously marked, r = detected later, z alive but not marked
#phi is survival from one interval to the next, while p is sampling probability within interval

#converting from from se (e.g. sep, sepN etc) to CI
#The standard approach to calculating 95% confidence limits for some parameter theta is theta ±
#(1.96 × SE). However, to guarantee that the calculated 95% CI is [0, 1] bounded for parameters 
#(like phi or p) that are [0, 1] bounded,we can calculate the 95% CI on the logit scale, 
#before back-transforming to the real probability scale. However, because the logit transform is 
#not linear, the reconstituted 95% CI will not be symmetrical around the parameter estimate, 
#especially for parameters estimated near the [0, 1] boundaries.

#Note: JS.direct spits out the estimates on the "real" scale

par(mfrow=c(1,1), mar=c(5,4,4,2))
plot(stages$mid, JS.direct.est$N, pch=20, cex=1, axes=F, ylab="N", xlab="MYA",
     main="", cex.main=1, ylim=c(200,800), "compare JS and range thru")
points(stages$mid, JS.direct.est$N, type="l")
points(stages$mid, JS.direct.est$N, pch=20)
arrows(stages$mid, JS.direct.est$N+(1.96*JS.direct.est$seN), stages$mid, JS.direct.est$N-(1.96*JS.direct.est$seN), code=3, angle=90, length=0.1)

#grey lines are n + z which is range through 
points(stages$mid, JS.direct.est$n+JS.direct.est$z, pch=20, cex=1, col="darkgrey")
points(stages$mid, JS.direct.est$n+JS.direct.est$z, type="l", col="darkgrey")
axis(1)
axis(2)
box()
legend("bottomright", c("estimated genus richness", "rangethrough richness"), pch = c(20, 20), 
       col = c("black", "grey"),
       text.col = c("black", "grey"),
       bty="n")

#discuss the differences in the black and grey lines!
#will the black  line always be higher than the grey? Will they always be "parallel"? Why or why not?
#are the numbers the same?
#what are the vertical bars plotted in one and not the other?
#why does the grey line start before 60 mya but not the black one? and why does the grey one reach 0 mya and not the black one?


#Figure you just plotted above: it is a bit "odd" that it declines toward the Recent, 
#but that will be "remedied" by add e.g. genera we know are extant from WORMS, our own data and adding WORMS data might show a different picture

#Let's now plot what the sampling probability looks like 
plot(stages$mid,JS.direct.est$p,  ylim=c(0,1.5), lty=2, axes=F, lwd=2, ylab="sampling", xlab="Mya", main="")
points(stages$mid, JS.direct.est$p, type="l")
arrows(stages$mid, JS.direct.est$p+(1.96*JS.direct.est$sep), stages$mid, JS.direct.est$p-(1.96*JS.direct.est$sep), code=3, angle=90, length=0.1)
axis(1)
axis(2)
box()

#blue is "corrected" for the time interval, i.e. the instantaneous" sampling in that time interval
#so it's more comparable.
p=-log(1-JS.direct.est$p)/stages$dur #have to drop the penultimate one
pl=-log(1-(JS.direct.est$p-(1.96*JS.direct.est$sep)))/stages$dur #have to drop the penultimate one
pu=-log(1-(JS.direct.est$p+(1.96*JS.direct.est$sep)))/stages$dur #have to drop the penultimate one
points(stages$mid, p, type="l", col="blue", lty=2)
arrows(stages$mid, pl, stages$mid, pu, code=3, angle=90, length=0.1,col="blue",)


#lets put the two sets of plots together for a better visual
par(mfrow=c(2,1), mar=c(4,4,1,2))
plot(stages$mid, JS.direct.est$N, pch=20, cex=1, axes=F, ylab="N", xlab="MYA",
     main="", cex.main=1, ylim=c(200,800), "compare JS and range thru")
points(stages$mid, JS.direct.est$N, type="l")
points(stages$mid, JS.direct.est$N, pch=20)
arrows(stages$mid, JS.direct.est$N+(1.96*JS.direct.est$seN), stages$mid, JS.direct.est$N-(1.96*JS.direct.est$seN), code=3, angle=90, length=0.1)
points(stages$mid, JS.direct.est$n+JS.direct.est$z, pch=20, cex=1, col="darkgrey")
points(stages$mid, JS.direct.est$n+JS.direct.est$z, type="l", col="darkgrey")
axis(1)
axis(2)
box()
legend("bottomright", c("estimated genus richness", "rangethrough richness"), pch = c(20, 20), 
       col = c("black", "grey"),
       text.col = c("black", "grey"),
       bty="n")

plot(stages$mid,JS.direct.est$p,  ylim=c(0,1.5), lty=2, axes=F, lwd=2, ylab="sampling", xlab="Mya", main="")
points(stages$mid, JS.direct.est$p, type="l")
arrows(stages$mid, JS.direct.est$p+(1.96*JS.direct.est$sep), stages$mid, JS.direct.est$p-(1.96*JS.direct.est$sep), code=3, angle=90, length=0.1)
axis(1)
axis(2)
box()
p=-log(1-JS.direct.est$p)/stages$dur #have to drop the penultimate one
pl=-log(1-(JS.direct.est$p-(1.96*JS.direct.est$sep)))/stages$dur #have to drop the penultimate one
pu=-log(1-(JS.direct.est$p+(1.96*JS.direct.est$sep)))/stages$dur #have to drop the penultimate one
points(stages$mid, p, type="l", col="blue", lty=2)
arrows(stages$mid, pl, stages$mid, pu, code=3, angle=90, length=0.1,col="blue",)

#JSSAl = POPAN
#Exercise, fit some models we tried in tutorial 2 and maybe some others? Do you expect the randomly 
#assigned covariates to have any bearing on sampling or some "biological" rate you image?

#try some other datasets and have fun and ask questions!


#these will take a while and will give some warning messages which we can discuss (e.g. "variance calculation failed for some beta parameters; confounding likely")
full.Pradelg <- openCR.fit(dnd.matrix, type='Pradelg', model= list(p~t, phi~t, gamma~t)) #=JSSAgCL
full.Pradel <- openCR.fit(dnd.matrix, type='Pradel', model= list(p~t, phi~t, lambda~t))#== JSSAlCL
full.JSSAg <- openCR.fit(dnd.matrix, type = 'JSSAg', model = c(phi~t, p~t, gamma~t))
full.JSSAl <- openCR.fit(dnd.matrix, type = 'JSSAl', model = c(phi~t, p~t, lambda~t))
full.JSSAgCL <- openCR.fit(dnd.matrix, type = 'JSSAgCL', model = c(phi~t, p~t, gamma~t))
full.JSSAlCL <- openCR.fit(dnd.matrix, type = 'JSSAlCL', model = c(phi~t, p~t, lambda~t))
const.JSSAg <- openCR.fit(dnd.matrix, type = 'JSSAg', model = c(phi~1, p~1, gamma~1))
const.JSSAl <- openCR.fit(dnd.matrix, type = 'JSSAl', model = c(phi~1, p~1, lambda~1))

#compare full.JSSAg$fit$estimate and full.Pradelg$fit$estimate
#compare  full.JSSAl$fit$estimate and full.Pradel$fit$estimate
#The non-spatial model types ‘Pradel’ and ‘Pradelg’ are implemented
#in openCR using sufficient statistics (Pradel 1996) and therefore fall outside the main 
#framework (Table 3). They correspond to ‘JSSAlCL’ and ‘JSSAgCL’ respectively, and estimate 
#the same parameters as those models. Estimates should coincide except when there are losses 
#on capture. ‘Pradel’ is parameterized in terms of population growth rate (lambda) and 
#‘Pradelg’ is parameterized in terms of seniority (gamma)


#Exercises
#fit some models using the covariates I created
#fit some time models, where for instance, you specify differences between the Paleogene and the Neogene
#Convert the probabilities to rates so they are comparable across time intervals

sesscov <- data.frame(t.period = c(rep(0,10), rep(1,10))) 
attr(x = dnd.matrix, which = "covariates")

#examples of some models with covariates and without
mod0 <- openCR.fit(dnd.matrix, type = 'Pradelg', model = c(phi~1, p~1, gamma~1))
mod1 <- openCR.fit(dnd.matrix, type = 'Pradelg', model = c(phi~faunality, p~1, gamma~1))
mod2 <- openCR.fit(dnd.matrix, type = 'Pradelg', model = c(phi~1, p~1, gamma~faunality))
mod3 <- openCR.fit(dnd.matrix, type = 'Pradelg', model = c(phi~1, p~t, gamma~faunality))
mod4 <- openCR.fit(dnd.matrix, type = 'Pradelg', model = c(phi~1, p~t+faunality, gamma~1))
mod5 <- openCR.fit(dnd.matrix, type = 'Pradelg', model = c(phi~1, p~t.period, gamma~1), sessioncov = sesscov)
mod6 <- openCR.fit(dnd.matrix, type = 'Pradelg', model = c(phi~faunality, p~faunality, gamma~faunality))
AIC(mod0,mod1, mod2,mod3, mod4, mod5, mod6)

#looking at mod6 for instance
mod6faun0phi=invlogit(mod6$fit$estimate[1]) # in theory!
mod6faun1phi=invlogit(mod6$fit$estimate[1]+mod6$fit$estimate[2])  # in theory! but I made it up, so there is no fauanality effect! That's great!

#Try some simulations (do your estimates give you data that look plausible? can you get the estimates back? 
#What's the uncertainty? how much data do you "need"? what if you don't have enough data?
## using type = 'Pradelg' and extractfn = derived
## homogeneous p
fitarg <- list(type = 'Pradelg', model = list(p~t, phi~t, gamma~t))
turnover <- list(phi = c(rep(0.85, 5), rep(0.5,5)), lambda = 1.0, recrmodel = 'discrete')
cores=1
outg <- runsim.nonspatial(nrepl = 1, N = 500, ncores = cores, turnover = turnover,
                          p = 0.2, recapfactor = 4, nsessions = 10, noccasions = 1,
                          fitargs = fitarg, extractfn = derived)
outg[[1]]
apply(sapply(outg, function(x) x$estimates$lambda),1,mean)
