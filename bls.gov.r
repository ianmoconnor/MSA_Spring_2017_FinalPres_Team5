########################################
## 
## 
########################################


https://api.bls.gov/publicAPI/v2/timeseries/data/
  
library(RCurl)
library(tidyverse)
library(jsonlite)

#bls <- fromJSON("https://api.bls.gov/publicAPI/v2/timeseries/data/SMU19197802023800001")
bls <- fromJSON("https://api.bls.gov/publicAPI/v2/timeseries/data/SMU19197802023800001")
bls2 <- bls[4]
bls3 <- as.data.frame(bls2)
bls4 <- as.data.frame(bls3[2])
bls5 <- matrix(unlist(bls4),ncol=27,byrow=TRUE)
