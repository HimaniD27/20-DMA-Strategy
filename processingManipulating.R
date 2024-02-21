library(tidyverse)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)

GenFunc_FileManipulate <- function(inputFolder, outputFolder)
{
  folder_path <- file.path("./",inputFolder)
  files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  #print(files)
  data_frame_new <- list()
  for (csv_file in files) 
  { #reading files
    cat("Reading file:", csv_file, "\n")
    d <- read.csv(csv_file)
    data_frame_new[[csv_file]] <- d
    #manipulating files
    d$Date <- as.Date(d$Date,format = "%Y-%m-%d",na.rm=T)
    d$CMP <- d$Close
    d <- d %>%
      arrange(Date) %>%
      mutate(DMA20 = zoo::rollmean(Close, k = 20, align = "right", fill = NA,na.rm=T))
    d$PercentageChange<- ((d$CMP-d$DMA20)/d$DMA20)*100
    
    newCol1 <- "ShopType"
    d[newCol1] <- inputFolder
    newCol2 <- "Name"
    d[newCol2] <- basename(csv_file)
    #d$Name <- sub(".NS_data\\.csv$", "", d$Name)
    d$Name <- sub(".NS_data.csv", "", d$Name)
    
    data_frame_new[[csv_file]] <- d
    # d <- d %>%
    #   select(ShopType,Name,Date,Open,High,Low,Close,Volume,CMP,DMA20,PercentageChange)
    d <- d %>%
      select(ShopType,Name,Date,CMP,DMA20,PercentageChange)
    
    d <- na.omit(d)
    
    #writing new files
    output_path <- file.path("./",outputFolder)
    dir.create(output_path, showWarnings = FALSE)
    output_file <- file.path(output_path, paste0("manipulated_", basename(csv_file)))
    write.csv(d, output_file, row.names = FALSE)
  }
  #return(lapply(data_frame_new, View))
  return(data_frame_new)
}

GenFunc_FileManipulate("equity_Etfs","manipulated_equityEtfs")
GenFunc_FileManipulate("jewellery_Etfs","manipulated_jewelleryEtfs")
GenFunc_FileManipulate("nifty50_Etfs","manipulated_nifty50Etfs")





GenFunc_Combining <- function(input_folder,output_folder) 
{
  folder_path <- file.path("./",input_folder)
  files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)
  #print(files)
  data_frame <- lapply(files, read.csv)
  combined_df <- bind_rows(data_frame)
  combined_df <- combined_df %>%
    arrange(-desc(Date))
  #View(combined_df)
  
  output_path <- file.path("./",output_folder)
  # dir.create(output_path, showWarnings = FALSE)
  # output_file <- file.path(output_path)
  write.csv(combined_df,output_path, row.names = FALSE)
}

GenFunc_Combining("manipulated_equityEtfs", "equityEtfs_ready.csv") 
GenFunc_Combining("manipulated_jewelleryEtfs","jewelleryEtfs_ready.csv") 
GenFunc_Combining("manipulated_nifty50Etfs","nifty50Etfs_ready.csv")





