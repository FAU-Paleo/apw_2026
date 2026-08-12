---
title: "Module 6: Geometric morphometrics"
layout: "post" 
permalink: "morphometrics/"
---

Welcome to Module 8: Geometric Morphometrics! Across these two days, we'll focus on why and how to collect different types of shape data and the challenges of analysing high-dimensional trait data. 


| When   | What                                                                 |
|--------|----------------------------------------------------------------------|
| August 29 | Intro and landmark-based GMM                                         |
| August 30 | Outline-based GMM and beyond                                                  |


<br>

#### Purpose
- Learn how to collect 2D landmark and 2D outline data
- Learn how to explore geometric morphometric data 
- Learn how to test hypotheses with GMM data
- Learn how to visualize shape change

### Slideshows
- [1. Introductions]({{site.baseurl}}/data/morphometrics/powerpoints/1_Who_Am_I.pdf)
- [2. A Brief History of Morphometrics]({{site.baseurl}}/data/morphometrics/powerpoints/2_A_Brief_History_of_Morphometrics.pdf)
- [3. Outline Data Analysis]({{site.baseurl}}/data/morphometrics/powerpoints/3_Outline_Analysis.pdf)
- [4. Advanced Topics in GMM]({{site.baseurl}}/data/morphometrics/powerpoints/4_Advanced_GMM.pdf)

### R code

- [0. Setup]({{site.baseurl}}/data/morphometrics/exercises/0_Setup.pdf)
- [1. Collecting Outline data]({{site.baseurl}}/data/morphometrics/exercises/1_Outline_Data_Collection.pdf)
- [2. Collecting and Analyzing 2D landmark data]({{site.baseurl}}/data/morphometrics/exercises/2_Collecting_and_Analyzing_Landmark_Data.pdf)
- [3. Conduct Ellipitcal Fourier Analysis]({{site.baseurl}}/data/morphometrics/exercises/3_Ellipitcal_Fourier.pdf)
- [3.5. Conduct Ellipitcal Fourier Analysis step2]({{site.baseurl}}/data/morphometrics/exercises/3.5_Ellipitcal_Fourier2.pdf)
- [4. Analyze EFA Data]({{site.baseurl}}/data/morphometrics/exercises/4_Analyzing_Outline_Data.html)
- [5. Morphospace: Exploring your data]({{site.baseurl}}/data/morphometrics/exercises/5_Morphospace_plots.html)
- [6. Practice and Synthesis]({{site.baseurl}}/data/morphometrics/exercises/6_Practicing_with_3D_Landmark_Data.pdf)

### Data Files

- [Raw Data- Belemnite Outlines]({{site.baseurl}}/data/morphometrics/Data/Belemnite_Data.txt)
- [Smoothed Data- Belemnite Outlines]({{site.baseurl}}/data/morphometrics/Data/Belemnite_SmoothedOutline.nts)
- [3D Mesh file- Canis lupis]({{site.baseurl}}/data/morphometrics/Data/Canis_lupus.ply)
- [3D Mesh file- Alligator mississipiensis]({{site.baseurl}}/data/morphometrics/Data/Alligator_mississippiensis.ply)
- [2D landmark scheme for mustelids]({{site.baseurl}}/data/morphometrics/Data/landmark_scheme.txt)
- [Links for 2D landmark scheme]({{site.baseurl}}/data/morphometrics/Data/links.csv)
- [3D landmarks on mammals]({{site.baseurl}}/data/morphometrics/Data/mammals.csv)
- [Landmark IDs for mammal 3D data]({{site.baseurl}}/data/morphometrics/Data/mammal_3d_fixed_points.csv)
- [3D landmarks on crocs]({{site.baseurl}}/data/morphometrics/Data/crocs.csv)
- [Croc Phylogeny]({{site.baseurl}}/data/morphometrics/Data/CrocTree2.nex)
- [ecology and taxonomy data for crocs]({{site.baseurl}}/data/morphometrics/Data/croc_ecology_data.csv)
- [Mammal Skull Images]({{site.baseurl}}/data/morphometrics/Mustelidae_skulls/mustelid_skulls.zip)
- [Belemnite Hook Images]({{site.baseurl}}/data/morphometrics/Data/BelemniteHooks.zip)

### R Functions

- [MorphoFiles_Function.r]({{site.baseurl}}/data/morphometrics/utility_functions/MorphoFiles_Function.r)
- [MorphometricExtraction_Functions.r]({{site.baseurl}}/data/morphometrics/utility_functions/MorphometricExtraction_Functions.r)
- [OutlineAnalysis_Functions.r]({{site.baseurl}}/data/morphometrics/utility_functions/OutlineAnalysis_Functions.r)
