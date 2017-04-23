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
library(dplyr)

## Originally we did:
bls <- fromJSON("https://api.bls.gov/publicAPI/v2/timeseries/data/SMU19197802023800001")
bls2 <- bls[4]
bls3 <- as.data.frame(bls2)
bls4 <- as.data.frame(bls3[2])
bls5 <- matrix(unlist(bls4),ncol=27,byrow=TRUE)

## Easy way
payload <- list('seriesid'="SMU19197802023800001",
                'startyear'=2014,
                'endyear'=2014)
response <- blsAPI(payload,return.data.frame = TRUE)
json <- fromJSON(response)

## creating the seriesid

# read state codes
get_state_code <- function() {
  myhtml <- read_html("https://download.bls.gov/pub/time.series/sm/sm.state")
  state_table <- html_text(myhtml)
  state_table <- read_delim(state_table,"\\t")
  state_table <- separate(state_table,`state_code	state_name`,c("state_code","state_name"),"\\t")
  return(state_table)
}

# State and Area Employment, Hours, and Earnings
# Series ID    SMU19197802023800001 
# Positions       Value           Field Name
# 1-2             SM              Prefix
# 3               U               Seasonal Adjustment Code 
# 4-5             19              State Code
# 6-10            19780           Area Code
# 11-18           20238000        SuperSector and Industry Code
# 19-20           01             	Data Type Code
s_pre <- 'SM'
s_sac <- 'U'
s_sc <- 1
s_ac <- '00000' #00000 is state-wide data
s_ssc <- '00' #00 is all non-farm
s_ic <- '00000000' #00000000 is all non-farm

