# Compare two different stage-level binning schemes and write out data.
# Adam Kocsis
# 2026-08-20

library(divDyn)
library(chronosphere)
library(fossilx) # in-development with https://github.com/adamkocsis/fossilx

# install with
# devtools::install_github("adamkocsis/fossilx")

data(stages)
# download whole pbdb from Zenodo
dat <- chronosphere::fetch("pbdb", ver="2026-08-09")

# example use
refined <- fossilx::pbdb_extend(dat,
	tax.level="genus",
	tax.combine="clgen",
	include=list("tax.marine_1.0"),
	env.categories="divDyn",
	strat=c("stg_1.0", "ten_1.0", "stb"),
	omit=list("env.nonmarine_1.0", "lithification1=unlithified")
)

################################################################################
# save file
saveRDS(datMerged, file="pbdb_processed_stb_2026-08-20.rds")

################################################################################
# Comparison of the two solutions (number of records)
sampStg<- binstat(dat, bin="stg", tax="clgen", coll="collection_no",
        duplicates=FALSE)
sampStb<- binstat(dat, bin="stb", tax="clgen", coll="collection_no",
        duplicates=FALSE)

# plot binning comparison
samplingStg <- merge(stages, sampStg, by="stg")
samplingStb <- merge(stagebins, sampStb, by="stb")

tsplot(stages, boxes="sys", shading="sys", xlim=4:95, ylim=c(0,30000),
    ylab="Number of Records")

lines(samplingStg$mid, samplingStg$occs, lwd=2)
lines(samplingStb$mid, samplingStb$occs, lwd=2, col="red")


legend("top", legend=c("'stg' (divDyn)", "'stb' (PBDB)"), col=c("black", "red"), lwd=1, bg="white", inset=c(0, 0.02))

################################################################################
# Comparison of the two solutions (rt-diversity)
ddStg<- divDyn(dat, bin="stg", tax="clgen")
ddStb<- divDyn(dat, bin="stb", tax="clgen")

# plot binning comparison
divStg <- merge(stages, ddStg, by="stg")
divStb <- merge(stagebins, ddStb, by="stb")

tsplot(stages, boxes="sys", shading="sys", xlim=4:95, ylim=c(0,4000),
    ylab="Range-through diversity")

lines(divStg$mid, divStg$divRT, lwd=2)
lines(divStb$mid, divStb$divRT, lwd=2, col="red")

legend("top", legend=c("'stg' (divDyn)", "'stb' (PBDB)"), col=c("black", "red"), lwd=1, bg="white", inset=c(0, 0.02))
