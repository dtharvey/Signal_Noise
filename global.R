# global.R file for Signals and Noise

# packages to load
library(shiny)
library(shinythemes)

# set colors
palette("Okabe-Ito")

# create filters for Savitzky-Golay filtering
sg5 = c(-3,12,17,12,-3)/35
sg7 = c(-2,3,6,7,6,3,-2)/21
sg9 = c(-21,14,39,54,59,54,39,14,-21)/231
sg11 = c(-36,9,44,69,84,89,84,69,44,9,-36)/429
sg13 = c(-11,0,9,16,21,24,25,24,21,16,9,0,-11)/143
sg15 = c(-78,-13,42,87,122,147,162,167,162,147,122,87,42,-13,-78)/1105
sg17 = c(-21,6,7,18,27,34,39,42,43,42,39,34,27,18,7,-6,-21)/323
sg19 = c(-136,-51,24,89,144,189,224,249,264,269,264,249,224,189,144,
         89,24,-51, -136)/2261
sg21 = c(-171,-76,9,84,149,204,249,284,309,324,329,324,309,284,249,204,
         149,84,9,-76,-171)/3059
sg23 = c(-42,-21,-2,15,30,43,54,63,70,75,78,79,78,75,70,63,54,43,30,15,
         -2,-21,-42)/805
sg25 = c(-253,-138,-33,62,147,222,287,322,387,422,447,462,467,462,447,
         422,387,322,287,222,147,62,-33,-138-253)/5175
sgfilters = list(NA,NA,NA,NA,sg5,NA,sg7,NA,sg9,NA,sg11,NA,sg13,NA,
                 sg15,NA,sg17,NA,sg19,NA,sg21,NA,sg23,NA,sg25)

# load spectra for the blue dye
spectra = read.csv(file = "data/blue_singlescans.csv")

# set seed for random data
set.seed(13)
