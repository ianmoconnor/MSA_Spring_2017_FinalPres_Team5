########################################
## 
## 
########################################


#https://api.bls.gov/publicAPI/v2/timeseries/data/
install.packages("blsAPI")  
library(RCurl)
library(tidyverse)
library(jsonlite)
library(rvest)
library(blsAPI)

## Originally we did:
bls <- fromJSON("https://api.bls.gov/publicAPI/v2/timeseries/data/SMU19197802023800001")
bls2 <- bls[4]
bls3 <- as.data.frame(bls2)
bls4 <- as.data.frame(bls3[2])
bls5 <- matrix(unlist(bls4),ncol=27,byrow=TRUE)

## Easy way
payload <- 'SMU19197802023800001'
response <- blsAPI(payload,return.data.frame = TRUE)
json <- fromJSON(response)
