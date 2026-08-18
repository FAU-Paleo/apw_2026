# Beta Diversity
# Script for course

library(vegan)
library(betapart)

# download from PBDB Middle Triassic community data from Stiller (2001) in South China
# Bangtoupo, Qingyan, China: Pelsonian - Illyrian, China

url <- "https://paleobiodb.org/data1.2/occs/list.csv?coll_id=31610,31611,31612,31613,31614,31615,31616,31617,31618,31619,31620,31621,31622&show=class,abund,ecospace"
temp <- read.csv(file = url)

dat <- subset(temp, accepted_rank=="genus" | accepted_rank=="species")

table(dat$collection_no)

# Create a species-by-site matrix

# This has both genus and species names, which is ok
# Identification done at species level
#dat <- subset(dat, identified_rank=="species")

# use accepted_name as default
 dat$species <- dat$accepted_name

# replace with identified name if species authority is not present
 dat$species[dat$accepted_rank=="genus"] <- dat$identified_name[dat$accepted_rank=="genus"]

# check for mistakes/typos
sort(unique(dat$species))

# names don't matter, but they need to be uniform
dat$species[dat$species=="Triassocirrus moellendorfii"] <- "Triassocirrus moellendorfi"
dat$species[dat$species=="Pseudomyoconcha maximilianileuchtenbergensis"] <- "Pseudomyoconcha maximilianleuchtenberensis"
dat$species[dat$species=="Pseudomyoconcha maximilianleuchtenbergensis"] <- "Pseudomyoconcha maximilianleuchtenberensis"
dat$species[dat$species=="Delphinulopsis binodusa"] <- "Delphinulopsis binodosa"
dat$species[dat$species=="Cassianella subcislonensis"] <- "Cassianella subcicloensis"
dat$species[dat$species=="Hologyra guizhui"] <- "Hologyra guizhoui"
dat$species[dat$species=="Hartmanina ? bangtoupoensis"] <- "Hartmanina bangtoupoensis ?"

# every species/collection combination should be there only once!
tapply(INDEX=dat$collection_no, X=dat$species, FUN=function(x) all(table(x)==1))
# issues with 31620 - ideally these would need to be cleaned

# make occurrence table
occ.tab <- table(dat$collection_no, dat$species)

# easier to understand
class(occ.tab) <- "matrix"

# Use the dist function first (binary)
dis <- dist(occ.tab) # Euclidean distance
dis <- dist(occ.tab, method="binary") # This is Jaccard dissimilarity (check) 


# A simple cluster analysis
clus <- hclust(dis) # "complete" is the default
plot(clus)

X11()
clus <- hclust(dis, "ward.D2") # recommended method
plot(clus, hang=-1) 


# Get abundance values in for further analyses ...
abun.tab <- occ.tab

# loop through all occurrences and rewrite occurrence record counts with abundances
for(i in 1:nrow(dat)){
    abun.tab[as.character(dat$collection_no[i]),dat$species[i]] <- dat$abund_value[i]
}

# convert to proportional table
p.abun <- prop.table(abun.tab, margin=1) 
rowSums(p.abun) # check


dis <- vegdist(p.abun) # bray curtis as default
X11()
clus <- hclust(dis, "ward.D2") # recommended method
plot(clus, hang=-1) 

# R Mode clustering
r <- vegdist(t(p.abun))
clus <- hclust(r, "ward.D2") # recommended method
plot(clus, hang=-1) 


mds <- metaMDS(p.abun, k=2)
plot(mds)
stressplot(mds)

# R mode and Q mode combined
library(paleotree)
twoWayEcologyCluster(dis, r, propAbund=p.abun, clustMethod="ward.D2")




##### Beta diversity ####
Beta <- ncol(abun.tab)/mean(S)
