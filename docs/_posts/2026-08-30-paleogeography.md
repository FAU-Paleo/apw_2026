---
title: "Module 6: GIS and Paleogeography"
layout: "post" 
date: 2024-08-30
permalink: "paleogeography/"
---

# Module 6: GIS and Paleogeography 



| When   | What                                                                   |
|--------|------------------------------------------------------------------------|
| Aug 30 | Introduction to GIS in R. Tectonic and Paleogeographic reconstructions |
|--------|------------------------------------------------------------------------|

<br>

- - -

<br>

## Morning 


### Basic GIS and handling spatial data in R

- [Intro to GIS Slideshow]({{site.baseurl}}/data/paleogeography/2026-08-30_GIS_basics.pdf)
- [1. Vector examples]({{site.baseurl}}/data/paleogeography/1_vectors.zip)
- [2. Raster examples]({{site.baseurl}}/data/paleogeography/2_rasters.zip)
- [3. Icosahedral grids]({{site.baseurl}}/data/paleogeography/3_icosa.zip)


## Afternoon 

### Paleo-GIS

- [Intro to tectonic models by Liz Dowding]({{site.baseurl}}/data/paleogeography/DowdingAug2026APW.pptx)
- [4. Tectonic reconstructions with `rgplates`]({{site.baseurl}}/data/paleogeography/4_tectonic_reconstruction.R)
- [5. Static data products]({{site.baseurl}}/data/paleogeography/5_derived_reconstructions.zip)

### Data

- Previous result from Module 2: [`pbdb_processed_2026-08-09.rds`](https://www.dropbox.com/scl/fi/0bdexp2mxwrol84q4aor6/pbdb_processed_2026-08-09.rds?rlkey=f0iqnx9l07s5me4irk3rrfu0o&st=n8klt3wz&dl=1)
## Links 

- [GPlates](https://www.gplates.org/)
- [GPlates tutorial for undergrades](https://fau-paleo.github.io/se3-gplates/)
- [Full GPlates tutorials](https://sites.google.com/site/gplatestutorials/)
- [`rgplates` website](https://gplates.github.io/rgplates/)
- [`icosa` website](https://icosa-grid.github.io/R-icosa/)
- [Dowding and Kocsis, In Press (preprint)]({{site.baseurl}}/data/paleogeography/DowdingandKocsis_PPE_Prep-Print-1.pdf)


## Downloading layers from the the BRIDGE website

This small chunk of text describes how you can download original data from [Valdes et al. 2021](https://www.paleo.bristol.ac.uk/ummodel/users/Valdes_et_al_2021/new2/) results.

- Go to 'Analysis Pages'. Here you can select the group of layers, which forms a comprehensive list, and not everything is really available. As an example, select 'Ocean Single level fields', and click the gray 'Submit' button. The page will refresh.
- Then you can scroll down and in the blue 'OPTIONS FOR FIRST PLOT' section you can select the climate model run with the 'First Experiement' field (default is `texqe`). Every run has a unique code, and you can frequently see a date next to it. The date refers to the mid of the stage that it describes (what the forcing variables (CO~2~) represent. The dem used in the model is the one that is closest to it (one is made for every 5My). As an example, go and select `texpr2 (086_7_MaBP)`. This will be based on the 85 Ma Paleomap DEM. 
- Then you can select the variable that you are interested in. If the data are stored with other variables, this will be less relevant, but you do have to check whether you want annual means or monthly data. Not all are available - you will see this when you ask for the results. Let's leave these with`Ocean Top Level Temperature` and `annual mean` for now.
- Then scroll down and look for the **Format**. This defaults to JavaScript, which will create a plot for you, but what you want is `NETCDF0 file`. This will download the cube in which the data are present. `NETCDF1` will download only the selected variable, which is sometimes available, even when the `NETCDF0` does not give you anything.
- Then click on **Get Chart** and download the file!




