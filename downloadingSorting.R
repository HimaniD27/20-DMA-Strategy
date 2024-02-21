library(tidyverse)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
#install.packages("quantmod")
library(quantmod)
#install.packages("tseries")
library(tseries)

#library(lubridate)
#install.packages("alphavantager")
#library(alphavantager)


myGenericDownloadFunc = function(vector,folderName)
{
  if(!dir.exists(folderName)){
    dir.create(folderName, recursive = TRUE)
  }
  
  start_date <- "2017-01-01"
  end_date <- "2023-12-31"
  
  for (etf in vector) {
    tryCatch(
      expr = {
        filename <- paste(etf, "_data.csv", sep = "")
        file_path <- file.path(folderName, filename)
        
        if(!file.exists(file_path))
        {
          # content <- getSymbols(etf, auto.assign = FALSE)
          content <- getSymbols(etf, from = start_date, to = end_date, auto.assign = FALSE)
          dates <- index(content)
          stock_data <- data.frame(Date = as.Date(dates), Price = content)
          # print(paste("downloading data" ),filename)
          
          colnames(stock_data)[colnames(stock_data) == paste("Price.",etf,".Open", sep = "")] <- "Open"
          colnames(stock_data)[colnames(stock_data) == paste("Price.",etf,".High", sep = "")] <- "High"
          colnames(stock_data)[colnames(stock_data) == paste("Price.",etf,".Low", sep = "")] <- "Low"
          colnames(stock_data)[colnames(stock_data) == paste("Price.",etf,".Close", sep = "")] <- "Close"
          colnames(stock_data)[colnames(stock_data) == paste("Price.",etf,".Volume", sep = "")] <- "Volume"
          colnames(stock_data)[colnames(stock_data) == paste("Price.",etf,".Close", sep = "")] <- "Close"
          
          column_to_remove <- paste("Price.",etf,".Adjusted", sep = "")
          
          # Delete the specified column
          if (column_to_remove %in% colnames(stock_data)) {
            stock_data <- subset(stock_data, select = -which(colnames(stock_data) == column_to_remove))
          }
          write.csv(stock_data,file_path, row.names = FALSE)
          # write.csv(content, file = file_path, row.names = FALSE)
        }else
        {
          print(paste("Not downloading data. because file already exists ", file_path))
        }
      },
      error= function(error)
      {
        print( paste("some error occurred for : " , etf , "||||" , folderName, error))
      }
    )    
  }
}


equity_etfs <- c('AXISTECETF.NS' , 'ICICIB22.NS' , 'ABSLBANETF.NS' , 'CPSEETF.NS' , 'HNGSNGBEES.NS' , 'HDFCSML250.NS' , 'HDFCNIFTY.NS' , 'HDFCSENSEX.NS' , 'ICICI500.NS' , 'ICICIALPLV.NS' , 'ICICILOVOL.NS' , 'ICICINXT50.NS' , 'ICICINIFTY.NS' , 'ICICIBANKN.NS' , 'ICICITECH.NS' , 'ICICIBANKP.NS' , 'ICICISENSX.NS' , 'KOTAKBKETF.NS' , 'KOTAKIT.NS' , 'KOTAKALPHA.NS' , 'KOTAKNIFTY.NS' , 'KOTAKPSUBK.NS' , 'NIFTYETF.NS' , 'BFSI.NS' , 'MAFANG.NS' , 'MASPTOP50.NS' , 'MAHKTECH.NS' , 'MOM100.NS' , 'MON100.NS' , 'NIFTYBEES.NS' , 'JUNIORBEES.NS' , 'AUTOBEES.NS' , 'ITBEES.NS' , 'PHARMABEES.NS' , 'PSUBNKBEES.NS' , 'MID150BEES.NS' , 'CONSUMBEES.NS' , 'SETFNIFBK.NS' , 'SBIETFIT.NS' , 'SETFNN50.NS' , 'SETFNIF50.NS' , 'UTIBANKETF.NS' )

jewellery_etfs <- c('SILVER.NS' , 'AXISGOLD.NS' , 'GOLDBEES.NS' , 'HDFCGOLD.NS' , 'ICICIGOLD.NS' , 'ICICISILVE.NS' , 'KOTAKGOLD.NS' , 'SILVERBEES.NS' , 'SETFGOLD.NS' , 'GOLDSHARE.NS' )

nifty50_etfs <- c('HDFCBANK.NS'  , 'RELIANCE.NS' , 'ICICIBANK.NS' , 'INFY.NS' , 'ITC.NS' , 'TCS.NS' , 'AXISBANK.NS' , 'LT.NS' , 'KOTAKBANK.NS' , 'HINDUNILVR.NS' )


myGenericDownloadFunc(equity_etfs,"equity_Etfs")
myGenericDownloadFunc(jewellery_etfs,"jewellery_Etfs")
myGenericDownloadFunc(nifty50_etfs,"nifty50_Etfs")



