library(lubridate)
library(tidyverse)

date_df <- data.frame(
  x = c(
    "2023-02-25",
    "2023-02-26",
    "2023-02-27",
    "2023-02-28",
    "2023-03-01"))

class(date_df$x)

date_df %>%
  mutate(date_x = ymd(x),
         year = year(date_x),
         month = month(date_x, label = TRUE, abbr = FALSE),
         day = day(date_x),
         wday = wday(date_x, label = TRUE, abbr = FALSE),
         week = week(date_x))

## Excel default USA date
date_df <- data.frame(
  x = c(
    "02/25/2023",
    "02/26/2023",
    "02/27/2023",
    "02/28/2023",
    "09/09/2023")) ## MM/DD/YYYY

date_df %>%
  mutate(date_x = mdy(x),
         year = year(date_x),
         month = month(date_x, label = TRUE, abbr = FALSE),
         day = day(date_x),
         wday = wday(date_x, label = TRUE, abbr = FALSE),
         week = week(date_x))


















