library("XML")
library("httr")
library("RMySQL")

source("~/Desktop/Creds.R")

MYcon <- dbConnect(
  MySQL(), host = MySQLCreds$dbhostname ,
  port = 3306, user = MySQLCreds$username, password = MySQLCreds$password, 
  dbname = MySQLCreds$database
)


for (i in 1:10) {
  Sys.sleep(5)
  fx <- GET(
  "http://rates.fxcm.com/RatesXML"
)
fxContent <- content(fx)
fxDF <- xmlToDataFrame(fxContent)
#GBPJPY set here
GBPJPY <- fxDF[10,]
bid <- as.numeric(as.character(GBPJPY$Bid))
ask <- as.numeric(as.character(GBPJPY$Ask))
time <- as.POSIXct(paste(as.character(Sys.Date()), as.character(GBPJPY$Last)))

trade <- data.frame(bid = bid, ask = ask, time = time)

dbWriteTable(MYcon, value = trade, name = "GBPJPY", append = TRUE, row.names = FALSE) 
print(paste("Wrote 1 Record GBP/JPY", as.character(Sys.time())))
}







