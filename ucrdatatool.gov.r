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

library(RCurl)
library(jsonlite)
## Can we use curl to download?
#curl "https://www.ucrdatatool.gov/Search/Crime/Local/DownCrimeOneYearofData.cfm/LocalCrimeOneYearofData.csv" -H "Cookie: CFID=147036723; CFTOKEN=3a3175db06f6d0e3-BA7B07A2-A882-C74C-22815496814C8B4B; BIGipServerbjs_http_pool=940669706.20480.0000; topItem=-1c" -H "Origin: https://www.ucrdatatool.gov" -H "Accept-Encoding: gzip, deflate, br" -H "Accept-Language: en-US,en;q=0.8" -H "Upgrade-Insecure-Requests: 1" -H "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36" -H "Content-Type: application/x-www-form-urlencoded" -H "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" -H "Cache-Control: max-age=0" -H "Referer: https://www.ucrdatatool.gov/Search/Crime/Local/RunCrimeOneYearofData.cfm" -H "Connection: keep-alive" -H "DNT: 1" --data "CrimeCrossId=6665^%^2C6671^%^2C6674^%^2C6687^%^2C6690^%^2C6695^%^2C6696^%^2C6714^%^2C6734^%^2C6753^%^2C6757^%^2C6774^%^2C6787^%^2C6788^%^2C6802^%^2C6809^%^2C6829^%^2C6831^%^2C6837^%^2C6850^%^2C6851^%^2C6854^%^2C6874^%^2C6889^%^2C6903^%^2C6908^%^2C6923^%^2C6940^%^2C6951^%^2C6955^%^2C6970^%^2C22787^%^2C6985^%^2C6993^%^2C6995^%^2C7009^%^2C7011^%^2C7021^%^2C7048^%^2C7056^%^2C7059^%^2C7063^%^2C7066^%^2C7076^%^2C7081^%^2C7086^%^2C7100^%^2C7116^%^2C7119^%^2C7121^%^2C7142^%^2C7144^%^2C7145^%^2C7146^%^2C7151^%^2C7158^%^2C7187^%^2C7213^&YearStart=2014^&YearEnd=2014^&DataType=1^%^2C2^%^2C3^%^2C4" --compressed
test_html <- postForm("https://www.ucrdatatool.gov/Search/Crime/Local/DownCrimeOneYearofData.cfm/LocalCrimeOneYearofData.csv",
          .opts = list(  
            postfields = "CrimeCrossId=6665^%^2C6671^%^2C6674^%^2C6687^%^2C6690^%^2C6695^%^2C6696^%^2C6714^%^2C6734^%^2C6753^%^2C6757^%^2C6774^%^2C6787^%^2C6788^%^2C6802^%^2C6809^%^2C6829^%^2C6831^%^2C6837^%^2C6850^%^2C6851^%^2C6854^%^2C6874^%^2C6889^%^2C6903^%^2C6908^%^2C6923^%^2C6940^%^2C6951^%^2C6955^%^2C6970^%^2C22787^%^2C6985^%^2C6993^%^2C6995^%^2C7009^%^2C7011^%^2C7021^%^2C7048^%^2C7056^%^2C7059^%^2C7063^%^2C7066^%^2C7076^%^2C7081^%^2C7086^%^2C7100^%^2C7116^%^2C7119^%^2C7121^%^2C7142^%^2C7144^%^2C7145^%^2C7146^%^2C7151^%^2C7158^%^2C7187^%^2C7213^&YearStart=2014^&YearEnd=2014^&DataType=1^%^2C2^%^2C3^%^2C4",
            httpheader = c('Cookie' = "CFID=147036723; CFTOKEN=3a3175db06f6d0e3-BA7B07A2-A882-C74C-22815496814C8B4B; BIGipServerbjs_http_pool=940669706.20480.0000; topItem=-1c",
                           'Origin' = "https://www.ucrdatatool.gov",
                           'Accept-Encoding' = "gzip, deflate, br",
                           'Accept-Language' = "en-US,en;q=0.8",
                           'Upgrade-Insecure-Requests' = "1",
                           'User-Agent' = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/57.0.2987.133 Safari/537.36",
                           'Content-Type' = "application/x-www-form-urlencoded",
                           'Accept' = "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8",
                           'Cache-Control' = "max-age=0",
                           'Referer' = "https://www.ucrdatatool.gov/Search/Crime/Local/RunCrimeOneYearofData.cfm",
                           'Connection' = "keep-alive",
                           'DNT' = "1")
          )
        )
