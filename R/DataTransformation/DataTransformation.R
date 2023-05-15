library(tidyverse)
library(glue)
library(sqldf)

glimpse(mtcars) # หาชื่อ column ใน data
head(mtcars, 3)
tail(mtcars, 2)

# sql
# run sql query with R dataframe

sqldf("select * from mtcars 
      where mpg > 30")

sqldf("select mpg, wt, hp 
      from mtcars 
      where wt < 2")

sqldf("select avg(mpg), sum(mpg) 
      from mtcars")

# glue เอา string มาเรียงต่อกัน 
# string template

my_name <- "Nam"
my_age <- 22

glue("Hello my name is {my_name}") # ใส่ {} ไว้ดึงตัวแปลที่ต้องการ

# tidyverse 
# dplyR => data tranformation
# 1. select
# 2. filter
# 3. mutate
# 4. arrange
# 5. summarise + group_by

# select columns
select(mtcars, mpg, hp, wt)

select(mtcars, contains("a")) # columns ชื่อที่มีตัว a
select(mtcars, starts_with("a")) # columns ชื่อขึ้นต้นด้วย a
select(mtcars, ends_with("a")) # columns ลงท้าย a

# %>% Pipe Operator
# data pipeline in R
mtcars %>% 
  select(mpg, hp, wt, am) %>%
  filter(mpg > 30 | am == 1) %>%
# filter ได้หลายเงื่อนไข ใส่ & และ | หรือ

mtcars %>%
  rownames_to_column() %>% #สร้าง column ใหม่
  select(model = rowname,
         milePerGallon = mpg,
         horsePower = hp,
         weigh = wt) %>%
  head()

mtcars <- mtcars %>%
  rownames_to_column()
  
mtcars <- mtcars %>%
  rename(model = rowname) #เปลี่ยนชื่อ column

# filter model names
mtcars %>% 
  select(model, mpg, hp, wt) %>%
  filter(grepl("^M", model)) #ชื่อขึ้นต้นด้วย M ใช้ grepl หา
# n$ ลงท้ายด้วย n 

# mutate create new columns
df <- mtcars %>%
  select(model, mpg, hp) %>%
  head() %>%
  mutate(mpg_double = mpg*2,
         mpg_log = log(mpg),
         hp_double = hp*2) 

# arrange sort data
mtcars %>%
  select(model, mpg, am) %>%
  arrange(am, desc(mpg)) %>%
  head(10)

# mutate create label
# am (0=auto, 1=manual)

mtcars <- mtcars %>%
  mutate(am = ifelse(am==0, "Auto", "Manual"))

# create dataframe from scratch
df <- data.frame(
  id = 1:5,
  country = c("Thailand", "Korea", "Japan", "USA", "Belgium")
)

df %>% 
  mutate(region = case_when(
    country %in% c("Thailand", "Korea", "Japan") ~ "Asia",
    country == "USA" ~ "America",
    country == "Belgium" ~ "Europe"
  ))

# %in% แปลว่า อยู่ใน ~ แปลว่า Then

df2 <- data.frame(id = 6:8,
                   country = c("Germany", "Italy", "Sweden"))

full_df <- df %>% bind_rows(df2) # เชื่อม 2 dataframe

df3 <- data.frame(id = 9:10,
                  country = c("Canada", "Malaysia"))

# เชื่อม dataframe เข้าด้วยกัน
df %>%
  bind_rows(df2) %>%
  bind_rows(df3)

list_df <- list(df, df2, df3)
full_df <- bind_rows(list_df)

# case when in R
full_df %>%
  mutate(region = case_when(
    country %in% c("Thailand", "Korea", "Japan", "Malaysia") ~ "Asia",
    country %in% c("Canada", "USA") ~ "America",
    TRUE ~ "Europe"
  ))

# case when in sql
library(sqldf)
sqldf("select *, case 
                  when country in ('USA', 'Canada') then 'America'
                  when country in ('Thailand', 'Korea', 'Japan', 'Malaysia') 
      then 'Asia'
                  else 'Europe'
                  end as region
                  from full_df
      ")

# summarise + group_by
# aggregate function
result <- mtcars %>% 
  mutate(vs = ifelse(vs== 0, "v-shaped",
                     "straight")) %>%
  group_by(am, vs) %>%
  summarise(avg_mpg = mean(mpg),
            sum_mpg = sum(mpg),
            min_mpg = min(mpg),
            max_mpg = max(mpg),
            n = n() ) # count(mpg)
View(result)

write_csv(result, "result.csv")

read_csv("result.csv")

# missing values
# NA (not available)

v1 <- c(5, 10, 15, NA, 25)

is.na(v1)

data("mtcars")
mtcars[5, 1] <- NA
mtcars %>%
  filter(is.na(mpg))

mtcars %>%
  select(mpg, hp, wt) %>%
  filter(is.na(mpg))

mtcars %>%
  select(mpg, hp, wt) %>%
  filter(! is.na(mpg))

mtcars %>%
  summarise(avg_mpg = mean(mpg, na.rm=TRUE)) 
# na.rm = remove NA 

mtcars %>%
  filter(! is.na(mpg)) %>% # filter NA
  summarise(avg_mpg = mean(mpg),
            sum_mpg = sum(mpg))

mean_mpg <- mtcars %>%
  summarise(mean(mpg, na.rm=T)) %>%
  pull() # ดึงค่าเอาแค่ตัวเลขออกมาใช้

mtcars %>%
  select(mpg) %>%
  mutate(mpg2 = replace_na(mpg, mean_mpg)) 
# replace_na แทนที่ mean_mpg เข้าไปใน na

# apply loop over dataframe

data("mtcars") 
mtcars
apply(mtcars, 2, mean) # mean ของทุก columns 2=columns 1=rows

# join dataframe
# standard joins in SQL
# inner, left, right, full

band_members
band_instruments

left_join(band_members, band_instruments)

band_members %>%
  inner_join(band_instruments, by="name")

band_members %>%
  right_join(band_instruments, by="name")

band_members %>%
  full_join(band_instruments, by="name")

band_members %>%
  rename(memberName = name) -> band_members2

band_members2 %>%
  left_join(band_instruments, by = c("memberName" = "name"))
# ชื่อ columns ไม่ตรงกัน ก็ join ได้

library(nycflights13)

glimpse(flights) # หา rows columns บอกจำนวนด้วย
View(flights)

flights %>%
  filter(year==2013 & month == 9) %>%
  count(carrier) %>% # นับสายการบิน
  arrange(desc(n)) %>% # เรียงจากมากไปน้อย
  head(5) %>%
  left_join(airlines, by = "carrier")


# static website

library(rvest)
library(tidyverse)

url <- "https://www.imdb.com/search/title/?groups=top_100&sort=user_rating,desc"

movie_name <- url %>%
  read_html() %>%
  html_nodes("h3.lister-item-header") %>%
  html_text2() # remove characters

rating <- url %>%
  read_html() %>%
  html_elements("div.ratings-imdb-rating") %>%
  html_text2() %>%
  as.numeric()

votes <- url %>%
  read_html() %>%
  html_elements("p.sort-num_votes-visible") %>%
  html_text2()

df <- imdb_df <- data.frame(
  movie_name,
  rating,
  votes
)

View(df)

df %>%
  separate(votes, sep = "|", into=c("votes", "gross", "tops"))

# ฝึกดึงข้อมูล homework
# IMDB, static website







