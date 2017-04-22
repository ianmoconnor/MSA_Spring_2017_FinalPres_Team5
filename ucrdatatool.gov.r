########################################
## Uniform Crime Reporting Statistics
## Can't find an API? 
## Requires webscraping then?
## https://www.ucrdatatool.gov/
########################################

## An example pretty output is found at: https://www.socialexplorer.com/18f4fa9c60/explore

## Questions that could be asked:
# Are non-violent crimes related to population density?
# Are violent crimes related to population density?
# Do crime rates (per 100k people) change as the population increases?
# Etc. 

library(rvest)
library(XML)
library(readr)
library(dplyr)
library(lubridate)

## Can we use curl to download?
#curl "https://www.ucrdatatool.gov/Search/Crime/Local/DownCrimeOneYearofData.cfm/LocalCrimeOneYearofData.csv" -H "Cookie: CFID=147036723; CFTOKEN=3a3175db06f6d0e3-BA7B07A2-A882-C74C-22815496814C8B4B; BIGipServerbjs_http_pool=940669706.20480.0000; topItem=-1c" -H "Origin: https://www.ucrdatatool.gov" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US,en;q=0.8" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Cache-Control: max-age=0" -H "Referer: https://www.ucrdatatool.gov/Search/Crime/Local/RunCrimeOneYearofData.cfm" -H "Connection: keep-alive" -H "DNT: 1" --data "CrimeCrossId=6665^%^2C6671^%^2C6674^%^2C6687^%^2C6690^%^2C6695^%^2C6696^%^2C6714^%^2C6734^%^2C6753^%^2C6757^%^2C6774^%^2C6787^%^2C6788^%^2C6802^%^2C6809^%^2C6829^%^2C6831^%^2C6837^%^2C6850^%^2C6851^%^2C6854^%^2C6874^%^2C6889^%^2C6903^%^2C6908^%^2C6923^%^2C6940^%^2C6951^%^2C6955^%^2C6970^%^2C22787^%^2C6985^%^2C6993^%^2C6995^%^2C7009^%^2C7011^%^2C7021^%^2C7048^%^2C7056^%^2C7059^%^2C7063^%^2C7066^%^2C7076^%^2C7081^%^2C7086^%^2C7100^%^2C7116^%^2C7119^%^2C7121^%^2C7142^%^2C7144^%^2C7145^%^2C7146^%^2C7151^%^2C7158^%^2C7187^%^2C7213^&YearStart=2014^&YearEnd=2014^&DataType=1^%^2C2^%^2C3^%^2C4" --compressed
# test_html <- postForm("https://www.ucrdatatool.gov/Search/Crime/Local/DownCrimeOneYearofData.cfm/LocalCrimeOneYearofData.csv",
#           .opts = list(  
#             postfields = "CrimeCrossId=6665^%^2C6671^%^2C6674^%^2C6687^%^2C6690^%^2C6695^%^2C6696^%^2C6714^%^2C6734^%^2C6753^%^2C6757^%^2C6774^%^2C6787^%^2C6788^%^2C6802^%^2C6809^%^2C6829^%^2C6831^%^2C6837^%^2C6850^%^2C6851^%^2C6854^%^2C6874^%^2C6889^%^2C6903^%^2C6908^%^2C6923^%^2C6940^%^2C6951^%^2C6955^%^2C6970^%^2C22787^%^2C6985^%^2C6993^%^2C6995^%^2C7009^%^2C7011^%^2C7021^%^2C7048^%^2C7056^%^2C7059^%^2C7063^%^2C7066^%^2C7076^%^2C7081^%^2C7086^%^2C7100^%^2C7116^%^2C7119^%^2C7121^%^2C7142^%^2C7144^%^2C7145^%^2C7146^%^2C7151^%^2C7158^%^2C7187^%^2C7213^&YearStart=2014^&YearEnd=2014^&DataType=1^%^2C2^%^2C3^%^2C4",
#             httpheader = c('Cookie' = "CFID=147036723; CFTOKEN=3a3175db06f6d0e3-BA7B07A2-A882-C74C-22815496814C8B4B; BIGipServerbjs_http_pool=940669706.20480.0000; topItem=-1c",
#                            'Origin' = "https://www.ucrdatatool.gov",
#                            'Accept-Encoding' = "gzip, deflate, br",
#                            'Accept-Language' = "en-US,en;q=0.8",
#                            'Upgrade-Insecure-Requests' = "1",
#                            'User-Agent' = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36",
#                            'Content-Type' = "application/x-www-form-urlencoded",
#                            'Accept' = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
#                            'Cache-Control' = "max-age=0",
#                            'Referer' = "https://www.ucrdatatool.gov/Search/Crime/Local/RunCrimeOneYearofData.cfm",
#                            'Connection' = "keep-alive",
#                            'DNT' = "1")
#           )
#         )

ucr_tool_st_data_year <- function(stateid,datatype,year) {
  ## try using rvest
  
  # the url that has the form to collect UCR data
  ucr_url <- "https://www.ucrdatatool.gov/Search/Crime/State/OneYearofData.cfm"
  
  #create a session
  ucrsession <- html_session(ucr_url)
  #find the form and make it possible to interact
  ucrform <- html_form(ucrsession)
  #set values to choose a state, Type of Crime Data, and year
  filledform <- set_values(ucrform[[1]],StateId=stateid,DataType=datatype,YearStart=year)
  
  #submit the form. For some reason this only accepts one input for state at a time. Boo.
  ucrresult <- submit_form(ucrsession,filledform) 
  
  #convert the results to a usable format and remove all the junk that was in there
  ucr_data <- read_html(ucrresult)
  ucr_table <- html_nodes(ucr_data,xpath = "/html/body/div[2]/table")
  xml_remove(html_node(ucr_table,xpath = "tr[1]"))
  xml_remove(html_node(ucr_table,xpath = "tr[1]"))
  xml_remove(html_node(ucr_table,xpath = "tr[1]"))
  xml_remove(html_node(ucr_table,xpath = "tr[1]"))
  
  #now that the data is clean turn it into a data frame and return it
  ucr_data  <- as.data.frame(html_table(ucr_table))
  return <- ucr_data
}


ucr_violent_crime_all_states <- function(year) {
  data_temp <- NULL
  #data_temp <- rbind(data_out,headers,deparse.level = 0)
  for(i in 1:52) {
    cat(year," property_crime_state_",i," ")
    data_temp<-rbind(data_temp,ucr_tool_st_data_year(i,1,year))
    Sys.sleep(.5)
  }
  colnames(data_temp) <- c("State","Population","Violent_Crime_Total","Murder_Nonnegligent_Manslaughter","Legacy_Rape","Revised_Rape","Robbery","Aggravated_Assault")
  data_out <- data_temp 
  return <- data_out
}

ucr_property_crime_all_states <- function(year) {
  data_temp <- NULL
  #data_temp <- rbind(data_out,headers,deparse.level = 0)
  for(i in 1:52) {
    cat(year," property_crime_state_",i," ")
    data_temp<-rbind(data_temp,ucr_tool_st_data_year(i,2,year))
    Sys.sleep(.5)
  }
  colnames(data_temp) <- c("State","Population","Property_Crime_Total","Burglary","Larceny_Theft","Motor_Vehicle_Theft")
  data_out <- data_temp 
  return <- data_out
}

ucr_violent_crime_rate_all_states <- function(year) {
  data_temp <- NULL
  #data_temp <- rbind(data_out,headers,deparse.level = 0)
  for(i in 1:52) {
    cat(year," property_crime_state_",i," ")
    data_temp<-rbind(data_temp,ucr_tool_st_data_year(i,3,year))
    Sys.sleep(.5)
  }
  colnames(data_temp) <- c("State","Population","Violent_Crime_Rate","Murder_Nonnegligent_Manslaughter_Rate","Legacy_Rape_Rate","Revised_Rape_Rate","Robbery_Rate","Aggravated_Assault_Rate")
  data_out <- data_temp 
  return <- data_out
}

ucr_property_crime_rate_all_states <- function(year) {
  data_temp <- NULL
  #data_temp <- rbind(data_out,headers,deparse.level = 0)
  for(i in 1:52) {
    cat(year," property_crime_state_",i," ")
    data_temp<-rbind(data_temp,ucr_tool_st_data_year(i,4,year))
    Sys.sleep(.5)
  }
  colnames(data_temp) <- c("State","Population","Property_Crime_Rate","Burglary_Rate","Larceny_Theft_Rate","Motor_Vehicle_Theft_Rate")
  data_out <- data_temp 
  return <- data_out
}

endYear <- 2014
beginYear <- 1994


collect_UCR_For_Years <- function(beginYear,endYear) {
  rm(year)
  UCR_df <- NULL
  for(year in beginYear:endYear) {
    UCR_temp <- NULL
    UCR_temp <- cbind(year,
                   ucr_violent_crime_all_states(year),
                   ucr_property_crime_all_states(year),
                   ucr_violent_crime_rate_all_states(year),
                   ucr_property_crime_rate_all_states(year))
    UCR_df <- rbind(UCR_df,UCR_temp)
  }
  return(UCR_df)
}

starttime <- now()

# Testing code (delete later)
# UCR_temp <- as.data.frame(matrix(1:3,nrow = 1))
# colnames(UCR_temp) <- c("A","B","C")
# UCR_df <- rbind(UCR_df,UCR_temp)
for(j in 2013:2013) {
  print("Starting data for year ",j)
  write_csv(collect_UCR_For_Years(j,j),paste0("UCR_",j,".csv"))
}

UCR_in <- read_csv("UCR_test.csv")
UCR_in <- select(UCR_in,
                 year:Aggravated_Assault,
                 Property_Crime_Total:Motor_Vehicle_Theft,
                 Violent_Crime_Rate:Aggravated_Assault_Rate,
                 Property_Crime_Rate:Motor_Vehicle_Theft_Rate)

write_csv(UCR_in,paste0("UCR_","1994","-","2014",".csv"))
