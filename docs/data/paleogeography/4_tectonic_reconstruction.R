# Basic tectonic reconstructions with rgplates
# Erlangen, 2026
# Ádám T. Kocsis
# CC-BY (attribution)
# see more examples at : https://gplates.github.io/rgplates/
#
# install.packages("rgplates")
library(rgplates) # 0.6.1

##########################################################
# METHOD I. - The GPlates Web Service
# Will need the geojsonsf and httr2 packages!
# install.packages(c("geojsonsf", "httr2"))

# A. Reconstruction of plates
# The partitioning polygons as they are, default model=MERDITH2021
poly <- reconstruct("static_polygons", age=0)
poly

# plotting
plot(poly$geometry)

# Actual reconstruction
plates200 <- reconstruct("static_polygons", age=200)
plot(plates200$geometry, col="gray", border=NA)

# present day boundaries on top
admin200 <- reconstruct("coastlines", age=200)
admin200
plot(admin200$geometry, add=TRUE)

# Exercise: plot a 66 Million-year map!



# B. Putting points on the map
erlangen <- c(10.97, 49.58)
sydney <- c(151.19, -33.86)
cities <- rbind(erlangen,sydney)

# 1. Present day:
plot(poly$geometry)
points(cities, pch=3, col="red")

# 2. past
cities200 <- reconstruct(cities, 200)
plot(plates200$geometry, col="gray", border=NA)
points(cities200, pch=3, col="red")

# C. Other models
?reconstruct

# same as above!
plates200Mull<- reconstruct("static_polygons", age=200, model="MULLER2022")
cities200Mull <- reconstruct(cities, age=200, model="MULLER2022")
x11()
plot(plates200Mull$geometry, col="gray", border=NA)
points(cities200Mull, pch=3, col="red")

# Compare mantle and paleomag reference frame
plot(plates200Mull$geometry, col="gray", border=NA)
plot(plates200$geometry, col="#FF000055", border=NA, add=TRUE)


# compare Erlangen's past
ages <- seq(500,0, -50)
bothSeries <- reconstruct(cities, age=ages)
bothSeriesMR <- reconstruct(cities, age=ages, model="MULLER2022")
bothSeriesPM <- reconstruct(cities, age=ages, model="PALEOMAP")

# extract Erlangen's latitude
erLat<- unlist(lapply(bothSeries, function(x) x["erlangen", 2]))
erLatMR<- unlist(lapply(bothSeriesMR, function(x) x["erlangen", 2]))
erLatPM <- unlist(lapply(bothSeriesPM, function(x) x["erlangen", 2]))

library(divDyn)
data(stages)
tsplot(stages, boxes="sys",ylim=c(-90,90))
abline(h=0, lty=2)
lines(ages, erLat, type="o", pch=16)
lines(ages, erLatMR, type="o", col="red", pch=16)
lines(ages, erLatPM, type="o", col="blue", pch=16)
legend("topleft", legend=c("MERDITH2021", "MULLER2022", "PALEOMAP"), col=c("black","red", "blue"), lwd=1, pch=16)



# The gws dat object includes informatio on the available models,
# and what features can be extracted from them
data(gws)

# Exercise: plot the positions of the cities with the PALEOMAP model @ 50Ma!

# Try to repeat the same using the mollweide projection!
# See package tutorials if you are lost! :)

##########################################################
# METHOD II. Offline - faster for lots of data
# Requires the chronosphere package
# Requires the GPlates application!
# install.packages("chronosphere")
library(chronosphere)

# a plate tectonic model: the paleomap model above - with more features!
mod <- chronosphere::fetch(src="paleomap", ser="model")

# A. Basics
# the same as above
plates200 <- rgplates::reconstruct("static_polygons", age=200, model=mod)
plot(plates200$geometry, col="gray", border=NA)

# as above
cities200 <- reconstruct(cities, 200, model=mod)
points(cities200, pch=3, col="red")


# B. PBDB data
library(divDyn)

# binned example data!
data(corals)
data(stages)

# collection information
collections <- unique(corals[, c("collection_no", "lng", "lat", "stg")])

# filtering of weird points...
collections <- na.omit(collections)

########################################----------------------------------------
# I. One stage at a time
nStg <- 80

# sources of data
# data -> collections$stg
# target age -> stages$mid

# plate reconstruction
targetAge <- stages$mid[nStg]
platesStg <- rgplates::reconstruct("static_polygons", age=targetAge, model=mod)

# the points
collStg <- collections[which(collections$stg==nStg),]
coords <- collStg[, c("lng", "lat")]
coordsStg <- rgplates::reconstruct(coords, age=targetAge, model=mod)

# plotting
plot(platesStg$geometry, col="gray", border=NA)
points(coordsStg, pch=3, col="red")


########################################----------------------------------------
# II. multiple stages
# Good strategy
# 1. One loop for the Calculation
# 2. One loop for the plotting

# 1. Calculate everything
# all the maps
lPlates <- list()

# calculate the reconstruction for every stage!
for(i in 1:nrow(stages)){
	# list of plates
	lPlates[[i]] <- rgplates::reconstruct("static_polygons", model=mod, age=stages$mid[i])
	# loop counter
	cat(i, "\r")
	flush.console()
}

# Shorthand: vectorized for ages!
# lPlates2 <- rgplates::reconstruct("static_polygons", model=mod, age=stages$mid)

# Target ages, every collection has to have one!
collections$targetAge <- stages$mid[collections$stg]

# calculate the paleocoordinates for every collection 
coordsPaleo <- rgplates::reconstruct(
	collections[c("lng", "lat")], 
	age=collections$targetAge,
	model=mod,
	enumerate=FALSE)

# the new column names
colnames(coordsPaleo) <- c("plng", "plat")

# add it to the rest
collections <- cbind(collections, coordsPaleo)


########################################
# 2. Plotting  the locations of the collections

pdf("coral_stages.pdf", width=20, height=10)

for(i in 1:nrow(stages)){
	# get the data of this stage
	collStg <- collections[which(collections$stg==i),]

	# make plot only if there is any data!
	if(nrow(collStg)>0){
		#get the relevant map 
		platesStg <- lPlates[[i]] # lPlates is derived from `stages`
		# plot map
		title <- paste0(stages$stage[i], ", stg: ", i)
		plot(platesStg$geometry, col="gray", border=NA, main=title)
		points(collStg[, c("plng", "plat")], pch=3, col="red")
	}

}

dev.off()















