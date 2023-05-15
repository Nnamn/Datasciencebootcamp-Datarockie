library(tidyverse)
library(RSQLite)
library(RPostgreSQL)
library(lubridate)
library(janitor)

## connect database
con <- dbConnect(SQLite(), "chinook.db")

## list table name 
dbListTables(con)


## list fielde in a table 
dbListFields(con, "customers")

## write SQL queries
df <- dbGetQuery(con, "select * from customers limit 10")

df %>%
  select(FirstName, LastName)

clean_df <- clean_names(df) # ชื่อ columns
View(clean_df)

## write JOIN syntax
df2 <- dbGetQuery(con, "select * from albums, artists
                where albums.artistID = artists.artistID") %>%
  clean_names()
View(df2)

## write a table เพิ่ม columns เข้าไปใน table
dbWriteTable(con, "cars", mtcars)
dbListTables(con)

dbGetQuery(con, "select * from cars limit 5;")

# Delete columns in table 
dbRemoveTable(con, "cars")

## close connection
dbDisconnect(con)














