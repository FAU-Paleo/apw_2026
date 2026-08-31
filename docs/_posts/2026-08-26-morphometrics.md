---
title: "Module 5: Geometric morphometrics"
layout: "post" 
date: 2026-08-26
permalink: "morphometrics/"
---

Welcome to Module 5: Geometric Morphometrics! Across these two days, we'll focus on why and how to collect different types of shape data and the challenges of analysing high-dimensional trait data. 


| When   | What                                                                 |
|--------|----------------------------------------------------------------------|
| August 26 | Intro and Outline-based GMM                                       |
| August 27 | Landmark-based GMM, Morphospace, and Hypothesis testing           |


<br>

#### Purpose
- Learn how to collect 2D landmark and 2D outline data
- Learn how to explore geometric morphometric data 
- Learn how to test hypotheses with GMM data
- Learn how to visualize shape change

### Slideshows
- [1. A Brief History of Morphometrics]({{site.baseurl}}/data/morphometrics/powerpoints/1_A_Brief_History_of_Morphometrics.pdf)
- [2. Outline Data Analysis]({{site.baseurl}}/data/morphometrics/powerpoints/2_Outline_Analysis.pdf)
- [3. Advanced Topics in GMM]({{site.baseurl}}/data/morphometrics/powerpoints/3_Advanced_GMM.pdf)

### R code

- [1. Setup]({{site.baseurl}}/data/morphometrics/exercises/01_setup_script.html)
- [2. Collecting Outline data]({{site.baseurl}}/data/morphometrics/exercises/02_Outline_Data_Collection.html)
- [3. Analyzing Outline data]({{site.baseurl}}/data/morphometrics/exercises/03_Analyzing_Outline_Data.html)
- [4. Collecting and Manipulating Landmark Data]({{site.baseurl}}/data/morphometrics/exercises/04_collecting_and_manipulating_landmarks.html)
- [5. Practice and Synthesis]({{site.baseurl}}/data/morphometrics/exercises/05_Practicing_with_3D_Landmark_Data.html)
- [6. Morphospace: Exploring your data]({{site.baseurl}}/data/morphometrics/exercises/06_Morphospace_plots.html)
- [7. Hypothesis Testing and Evolutionary Rates]({{site.baseurl}}/data/morphometrics/exercises/07_Shape_evolution.html)


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
