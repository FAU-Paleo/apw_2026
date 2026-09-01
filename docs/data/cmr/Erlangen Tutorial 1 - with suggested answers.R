#Lee Hsiang Liow Tutorial for Erlangen
#Tutorial 1 revised June 2024

#Applies to all tutorials - please let me know if something doesn't "work". Or if there is something
#that is weird or you don't understand. It will help me improve my notes!

#Try changing the code to check what happens, I find that is a good way to learn about the functions etc. and to do sanity checks

#It is important to look at your data in many different ways and to think about 
#potential issues and biases that may affect general or specific inferences. 
#Below are some questions and suggestions to get us thinking.

#If I mark the questions with (v), they can be discussed (with a desk partner or in your own head), 
#If they are marked with (c) they should be explored with code.
#After you have worked through the questions I have suggested, you can come up with different ones (that could have bearing on 
#diversification or richness analyses using paleo data) that you can share with the class.

rm(list=ls()) #start with a clean slate
#Q(v) How are PBDB data obtained and compiled?
#Q(v) What are some of the potential differences among taxa, sampling environments, biogeographic areas, 
#and time intervals and their "interactions", when considering PBDB data?

#Download canidae data from PBDB
library(paleobioDB)

#check this for more specifics https://paleobiodb.org/data1.1/occs/list for the function pbdb_occurrences; not sure how
#updated it is, so please verify information
canidae=pbdb_occurrences( limit="all", vocab= "pbdb", base_name="Canidae")

#Q(c) how many canidae genera are represented in pbdb and what are they? 
#first, check the downloaded data, it needs some manipulation!
head(canidae) #just show the first few rows so you can check the columns
canidae$genus= NA #create a genus column since the downloaded data does not have that

#put in those that we already have the genus name of
canidae$genus[which(canidae$accepted_rank=="genus")]=canidae$accepted_name[which(canidae$accepted_rank=="genus")]
#cut out the species epithet
canidae$genus[which(canidae$accepted_rank=="species")]= gsub( " .*$", "", canidae$accepted_name[which(canidae$accepted_rank=="species")]) 

#get rid of the ones that are "indet"
which(is.na(canidae$genus)) #these ones have "NA's"
canidae[which(is.na(canidae$genus)),] # look at them to check, they are not identified to genus
canidae=canidae[which(!is.na(canidae$genus)),]# we lost a few data points (249) with the indets, just retain the ones with genus names at least 
unique(canidae$genus)[order(unique(canidae$genus))] #good to check names
genus.list=unique(canidae$genus)[order(unique(canidae$genus))]
genus.list
length(genus.list)
#there are 70 genera in PBDB, that's one more than last year when I taught this class!

#Q(c)how many species are represented?
temp=canidae$accepted_name[which(canidae$accepted_rank=="species")]
sp.list=unique(temp)[order(unique(temp))] 
sp.list#good to check names, does it look alright?
length(sp.list)
#there are 250 canidae species with accepted names in pbdb, yay

#plot the observed temporal ranges of the genera
data=matrix(data=NA, nrow=length(genus.list), ncol=3) #lets make an empty matrix to put data in
rownames(data)=genus.list
colnames(data)=c("FIRST.APP", "LAST.APP", "N")
data[,1]=as.numeric(paste(tapply(canidae$max_ma, as.factor(canidae$genus), max )))
data[,2]=as.numeric(paste(tapply(canidae$min_ma, as.factor(canidae$genus), min )))
data[,3]=as.numeric(paste(tapply(canidae$genus, as.factor(canidae$genus), length)))
data=as.data.frame(data)
data#check if it looks nice; if you know any of these genera, check if they gel with what you know. If not, why?

#plot the observed temporal ranges of the genera
#first make the empty plot
par(mfrow=c(1,1))
plot(0, 0, ylim=c(0,length(genus.list)), xlim=c(-max(data[,1]), 10), type="n", xlab="Mya", ylab="genus index")

#do the ranges
for (i in 1:length(genus.list)){
  segments(-data[i,1], i, -data[i,2], i) #draw observed stratigraphic ranges
  text(8, i,  genus.list[i], cex = .5)#add genus names
  text(-55, i,  data[i,3], cex = .5) #add number of observations
}

#Q(c) What are the mean and median number of observations for canidae genera and species in pbdb?
#for genera, since we already have that nice table
median(data[,3]) #17 
mean(data[,3]) #45.8
#and for species 

sp.only=canidae[which(canidae$accepted_rank=="species"),]

median(as.numeric(paste(tapply(sp.only$accepted_name, as.factor(sp.only$accepted_name), length)))) #3
mean(as.numeric(paste(tapply(sp.only$accepted_name, as.factor(sp.only$accepted_name), length))))  #10.7

#Q(c) What are the mean and median number of observations in temporal bins you define for genera and species?
#ok let's decide on temporal bins first, let's see what the underlying data look like first

unique(canidae$early_interval)#there are quite a lot of different temporal systems and names in PBDB
#I am going to try equal sized time bins to make things easy, let's use the "clean" genus data
#table the number of observations per 5 million years for, say the genus
canidae$mid_age=0.5*(as.numeric(canidae$max_ma+as.numeric(canidae$min_ma)))
#look at distribution: most are in the 0-5 mya bin
hist(canidae$mid_age)

breaks=seq(-50,0, 5)
canidae$bins=cut((-canidae$mid_age), breaks=breaks) 
head(canidae)#see if the conversions look right
canidae$bins_n=canidae$bins #giving numerical values to the bins, where 1 is the youngest

x=as.character(canidae$bins_n)
for (i in 1:length(breaks-1)){
x=replace(x, x==as.character(levels(canidae$bins)[i]), length(breaks)-i)
}
canidae$bins_n=as.numeric(x) 

TAB=table(canidae$genus, canidae$bins_n) 
TAB.5=as.matrix(TAB)
colnames(TAB.5)=unique(canidae$bins)
TAB.5
# so now you can see from the table that Aelurodon has no observations in bin 1 (which is 0 to 5 mya), this one
#makes sense: https://en.wikipedia.org/wiki/Aelurodon, perhaps not all of the generas data will "make sense" - if you 
#see one that doesn't, think about it and discuss!

#table the number of observations per 1 million years for, say the genus and compare this with what you see for the 5 million year 
#binning - Q(v) what thoughts come to mind? (notice the "missing" bins, just means there was no data)
breaks=seq(-50,0, 1 )
canidae$bins=cut((-canidae$mid_age), breaks=breaks) 
head(canidae)#see if the conversions look right
canidae$bins_n=canidae$bins

x=as.character(canidae$bins_n)
for (i in 1:length(breaks)-i){
  x=replace(x, x==as.character(levels(canidae$bins)[i]), length(breaks)-i)
}
canidae$bins_n=as.numeric(x) 
table(canidae$genus, canidae$bins_n)
TAB=table(canidae$genus, canidae$bins_n) 
TAB.1=as.matrix(TAB)
ind=subset(canidae, select=c("bins_n", "bins"))


#Q(v) how gappy is the canidae record as represented in the PBDB? Do you think the function xxx represents what is close 
#to the "true" range of candidae? do you think if we sampled intensively if we can fill the temporal gaps?
#what about space?
approx.time=-as.numeric(colnames(table(canidae$genus, canidae$bins_n)))+0.5
obs=colSums(table(canidae$genus, canidae$bins_n))    # number of observations in each time interval
plot(approx.time,obs, pch=20)
points(approx.time,obs,type="l")
abline (h=0, col="red", lwd=3)
#it's pretty gappy,all those dots that are "on" the red line have one observation, the ones that are not "marked" have 0 observations. 



#Q(c) Choose any taxon you are interested in yourself (genus level upwards) and repeat these exercises/questions. 
#Q(v) Do the distributions/numbers looks similar or different from canidae? why?



