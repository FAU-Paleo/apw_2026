#Lee Hsiang Liow Tutorial for Erlangen
#Tutorial 1 revised June 2024

#Applies to all tutorials - please let me know if something doesn't "work". Or if there is something
#that is weird or you don't understand. It will help me improve my notes!

#Try changing the code to check what happens, 
#I find that is a good way to learn about the functions etc. and to do sanity checks

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

#Download canidae data from PBDB (or use chronosphere if you like!)
library(paleobioDB)

#check this for more specifics https://paleobiodb.org/data1.1/occs/list for the function pbdb_occurrences; not sure how
#update it is, so please verify information
canidae=pbdb_occurrences( limit="all", vocab= "pbdb", base_name="Canidae")

#Q(c) how many canidae genera are represented in pbdb and what are they? 
#clue: check what the data looks like and massage it a little to get the answer!

#Q(c)how many species are represented?

#Q(c) What are the mean and median number of observations for canidae genera and species in pbdb?

#Q(c) What are the mean and median number of observations in temporal bins you define for genera and species?
# clue, you have to "decide" what the bins/intervals are

#Q(v) how gappy is the canidae record as represented in the PBDB? Do you think the function xxx represents what is close 
#to the "true" range of candidae? do you think if we sampled intensively if we can fill the temporal gaps?


#Q(c) Choose any taxon you are interested in yourself (genus level upwards) and repeat these exercises/questions. 
#Q(v) Do the distributions/numbers looks similar or different from canidae? why?

