library(tidyverse)
library(readr)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)


GenFunc_buying <- function(input_file, selling_list_file, output_file) {

  input_data <- read.csv(input_file, stringsAsFactors = FALSE)
  selected_rows <- data.frame()


  if (file.exists(selling_list_file)) {
    selling_table <- read.csv(selling_list_file, stringsAsFactors = FALSE)
  } else {
    selling_table <- data.frame()
  }


  for (current_date_data in input_data %>%
       group_split(buy_date)) {
    if (nrow(selected_rows) == 0) {
      selected_rows <- bind_rows(
        selected_rows,
        current_date_data %>%
          group_by(shop_type) %>%
          filter(percentage_change == min(percentage_change)) %>%
          slice_head(n = 1) %>%
          ungroup()
      )
    } else {
      excluded_names <- selected_rows$name
      filtered_data <- current_date_data %>%
        filter(!name %in% excluded_names) %>%
        group_by(shop_type) %>%
        arrange(percentage_change) %>%
        slice_head(n = 1) %>%
        ungroup()
      if (nrow(filtered_data) > 0) {
        selected_rows <- bind_rows(selected_rows, filtered_data)
      }
    }
  }

  if (!("sell_price" %in% names(selected_rows))) {
    selected_rows$sell_price <- NA
  }

  if (!("sell_date" %in% names(selected_rows))) {
    selected_rows$sell_date <- NA
  }

  for (i in 1:nrow(selected_rows)) {
    name <- selected_rows$name[i]
    buy_date <- selected_rows$buy_date[i]
    target_price <- selected_rows$target_price[i]

    sell_candidates <- selling_table[selling_table$Name == name & selling_table$Date > buy_date, ]
    sell_index <- which(sell_candidates$CMP >= target_price)[1]

    if (!is.na(sell_index)) {
      selected_rows$sell_price[i] <- sell_candidates$CMP[sell_index]
      selected_rows$sell_date[i] <- sell_candidates$Date[sell_index]
      selling_table <- selling_table[selling_table$Name != name, ]
    }
  }

  write.csv(selected_rows, output_file, row.names = FALSE)
  #View(selected_rows)
}

GenFunc_buying("buying_list.csv", "selling_list.csv", "buy.csv")
