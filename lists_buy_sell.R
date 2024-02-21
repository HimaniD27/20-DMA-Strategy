library(tidyverse)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)

user_input_01 <- function(prompt) 
{
  cat(prompt)
  readline()
}


GenFunc_Buying <- function(total_investment_capital,parts,ceiling_limit,target,bid_level)
{
  ######################## main table parameters #########################
  total_investment_capital <- as.numeric(user_input_01("total_investment_capital="))
  parts <- as.numeric(user_input_01("parts="))
  ceiling_limit <- as.numeric(user_input_01("ceiling_limit="))
  target <- as.numeric(user_input_01("target="))
  bid_level <- as.numeric(user_input_01("bid_level="))
  investment_per_stock <- total_investment_capital / parts  
  amount_per_bid <- 1/10*investment_per_stock
  #print(investment_per_stock)
  #print(amount_per_bid)
  
  ####################### dates #########################
  start_date_string <- user_input_01("Start date (yyyy-mm-dd): ")
  end_date_string <- user_input_01("End date (yyyy-mm-dd): ")
  start_date <- as.Date(start_date_string, format = "%Y-%m-%d")
  end_date <- as.Date(end_date_string, format = "%Y-%m-%d")
  
  if (is.na(start_date) || is.na(end_date)) {
    cat("Invalid date format. Please enter dates in the format yyyy/mm/dd.\n")
  } else {
    start_date_formatted <- format(start_date, "%Y-%m-%d")
    end_date_formatted <- format(end_date, "%Y-%m-%d")
    cat("Start date:", start_date_formatted, "\n")
    cat("End date:", end_date_formatted, "\n")
  }  
  cat("total_investment_capital: ", total_investment_capital, "\n")
  cat("parts: ", parts, "\n")
  cat("investment_per_stock: ", investment_per_stock, "\n")
  cat("amount_per_bid: ", amount_per_bid, "\n")
  cat("ceiling_limit: ", ceiling_limit, "\n")
  cat("target: ", target, "\n")
  cat("bid_level: ", bid_level, "\n")
  
  ##################### getting scripts ready datewise ###################
  file1 <- data.frame(read.csv("equityEtfs_ready.csv",stringsAsFactors = F))
  file2 <- data.frame(read.csv("jewelleryEtfs_ready.csv",stringsAsFactors = F))
  file3 <- data.frame(read.csv("nifty50Etfs_ready.csv",stringsAsFactors = F))
  
  ##################### for buying ###################
  resultingFile1 <- file1 %>%
    filter(Date >= start_date_formatted, Date <= end_date_formatted) %>%
    group_by(Date) %>%
    arrange(PercentageChange) %>%
    slice_min(PercentageChange, n = 3) %>% 
    ungroup()  
  #View()
  resultingFile2 <- file2 %>%
    filter(Date >= start_date_formatted, Date <= end_date_formatted) %>%
    group_by(Date) %>%
    arrange(PercentageChange) %>%
    slice_min(PercentageChange, n = 3) %>%  
    ungroup() 
  #View()
  resultingFile3 <- file3 %>%
    filter(Date >= start_date_formatted, Date <= end_date_formatted) %>%
    group_by(Date) %>%
    arrange(PercentageChange) %>%
    slice_min(PercentageChange, n = 3) %>%  
    ungroup() 
  #View()
  
  folder_path <- "./scriptwise_sorted"
  if (!file.exists(folder_path)) {
    dir.create(folder_path, recursive = TRUE)
  }
  file_path1 <- file.path(folder_path, "equity_top5scripts.csv")
  file_path2 <- file.path(folder_path, "jewellery_top3scripts.csv")
  file_path3 <- file.path(folder_path, "nifty50_top3scripts.csv")
  write.csv(resultingFile1, file_path1, row.names = FALSE)
  write.csv(resultingFile2, file_path2, row.names = FALSE)
  write.csv(resultingFile3, file_path3, row.names = FALSE)
  cat("Data frame saved to:", file_path1, "\n")
  cat("Data frame saved to:", file_path2, "\n")
  cat("Data frame saved to:", file_path3, "\n")
  
  ######################## creating buying table #########################
  folder_path <- file.path("./scriptwise_sorted")
  files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  print(files)
  data_frame <- lapply(files, read.csv, stringsAsFactors=F)
  #data_frame
  #View(data_frame[[1]])
  #View(data_frame[[2]])
  #View(data_frame[[3]])
  #equity_script <- data_frame[[1]]
  #View(equity_script)
  #jewellery_script <- data_frame[[2]]
  #View(jewellery_script) 
  #nifty50_script <- data_frame[[3]]
  #View(nifty50_script)
  buying_list <- data.frame()
  for (i in 1:3) {
    
    current_script <- data_frame[[i]]
    shop_type <- current_script$ShopType
    buy_date <- as.Date(current_script$Date)
    name <- current_script$Name
    percentage_change <- current_script$PercentageChange
    buy_price <- current_script$CMP
    buy_qty <- ceiling(investment_per_stock / current_script$CMP)
    invested_amount <- buy_price * buy_qty
    target_price <- buy_price*(100+target)/100
    
    table_for_buying <- data.frame(shop_type, buy_date, name, percentage_change, buy_price, buy_qty, invested_amount, target_price,bid_level)
    buying_list <- rbind(buying_list, table_for_buying)
    
    
    ##################### for selling ###################
    resultingFile01 <- file1 %>%
      filter(Date >= start_date_formatted, Date <= end_date_formatted) %>%
      group_by(Date) %>%
      mutate(Date = as.Date(Date, format = "%Y-%m-%d"))
    #View
    resultingFile02 <- file2 %>%
      filter(Date >= start_date_formatted, Date <= end_date_formatted) %>%
      group_by(Date) %>%
      mutate(Date = as.Date(Date, format = "%Y-%m-%d"))
    #View
    resultingFile03 <- file3 %>%
      filter(Date >= start_date_formatted, Date <= end_date_formatted) %>%
      group_by(Date) %>%
      mutate(Date = as.Date(Date, format = "%Y-%m-%d")) 
    #View
    selling_list <- bind_rows(resultingFile01, resultingFile02, resultingFile03)
  }
  View(buying_list)
  View(selling_list)
  write.csv(buying_list, "buying_list.csv", row.names = FALSE)
  write.csv(selling_list, "selling_list.csv", row.names = FALSE)
}


GenFunc_Buying()
