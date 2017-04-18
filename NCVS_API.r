########################################
## National Crime Victimization Survey (NCVS)
## https://www.bjs.gov/developer/ncvs/index.cfm
## https://www.bjs.gov/developer/ncvs/developers.cfm
## api base_ulr = http://www.bjs.gov:8080
## Years: 1993 to 2015
########################################

## Acceptable paths
# /bjs/ncvs/v2        Returns a list of available datasets and data types they are available in.
# /bjs/ncvs/v2/personal/{year}        Returns the personal counts of reported incidents.
# /bjs/ncvs/v2/personal/population/{year}        Returns the personal population of reported incidents.
# /bjs/ncvs/v2/personal/fields/        Returns a description of the fields/columns used returned in the personal data sets.
# /bjs/ncvs/v2/household/{year}        Returns the household counts of reported incidents.
# /bjs/ncvs/v2/household/population/{year}        Returns the personal population of reported incidents.
# /bjs/ncvs/v2/household/fields/        Returns a description of the fields/columns used returned in the household data sets.

## Acceptable Options
# ?format=json (or xml or csv)

## Example url
# http://www.bjs.gov:8080/bjs/ncvs/v2/personal/2010?format=json

library(RCurl)
library(tidyverse)
library(jsonlite)

ncvs_list <- as.data.frame(fromJSON("http://www.bjs.gov:8080/bjs/ncvs/v2/?format=json"))

ncvs_personal <- as.data.frame(fromJSON("http://www.bjs.gov:8080/bjs/ncvs/v2/personal/2010?format=json"))

ncvs_pers_pop <- as.data.frame(fromJSON("http://www.bjs.gov:8080/bjs/ncvs/v2/personal/population/2010?format=json"))

ncvs_pers_fields <- as.data.frame(fromJSON("http://www.bjs.gov:8080/bjs/ncvs/v2/personal/fields/?format=json"))

ncvs_household <- as.data.frame(fromJSON("http://www.bjs.gov:8080/bjs/ncvs/v2/household/2010?format=json"))
  
ncvs_hous_pop <- as.data.frame(fromJSON("http://www.bjs.gov:8080/bjs/ncvs/v2/household/population/2010?format=json"))
  
ncvs_hous_fields <- as.data.frame(fromJSON("http://www.bjs.gov:8080/bjs/ncvs/v2/household/fields/?format=json"))
