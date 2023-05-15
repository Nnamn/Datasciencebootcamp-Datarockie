library(tidyverse)

## data visualization
## ggplot => grammar of graphic

## base R visualization
plot(mtcars$mpg, mtcars$hp, pch=16, col="red")

boxplot(mtcars$mpg)

hist(mtcars$mpg)

t1 <- table(mtcars$am)
barplot(t1) # ไม่ค่อยใช้

## ggplot => grammar of graphic

## one variable numeric
ggplot(data = mtcars, mapping = aes(x=mpg)) + 
  geom_histogram(bins = 10)

ggplot(data = mtcars, mapping = aes(x=mpg)) + 
  geom_density()

ggplot(data = mtcars, mapping = aes(x=mpg)) + 
  geom_freqpoly()

p1 <- ggplot(mtcars, aes(mpg)) +
  geom_histogram(bins = 5)

mtcars %>%
  filter(hp <= 100) %>%
  count()

mtcars %>%
  count(am)

## approach 01 - summary table before make bar chart

mtcars <- mtcars %>%
  mutate(am= ifelse(am==0, "Auto", "Manual"))

mtcars %>%
  mutate(am= ifelse(am==0, "Auto", "Manual")) %>%
  count(am) %>%
  ggplot(aes(am, n)) + 
  geom_col() # ใช้กับ summary เท่านั้น

## approach 02 - geom_bar()
ggplot(mtcars, aes(am)) + 
  geom_bar() # ใช้ที่ยังไม่รวมก็ได้

## two variable, numeric
## scatter plot

ggplot(mtcars, aes(hp, mpg)) + 
  geom_point(col="red", size = 5)

## dataframe => diamonds
diamonds
View(diamonds)

glimpse(diamonds)

diamonds %>%
  count(cut, color, clarity)

## ordinal factor ลำดับได้ว่าอันไหนดีกว่า
temp <- c("high", "med", "low", "high")
temp <- factor(temp, levels = c("low", "med", "high"), ordered = T)

## categorical factor
gender <- c("m", "f", "m")
gender <- factor(gender)

## sample
set.seed(42) # ล็อคผลลัพธ์ random
diamonds %>%
  sample_n(5)

diamonds %>%
  sample_frac(0.1)

diamonds %>%
  slice(1:5) # row

## relationship (pattern)
p3 <- ggplot(diamonds %>% sample_n(500), aes(carat, price)) + 
  geom_point() + 
  geom_smooth() +
  geom_rug()

## setting vs. mapping

## setting
ggplot(diamonds, aes(price)) +
  geom_histogram(bins = 100, fill= ("#c7eed4"))

ggplot(diamonds %>% sample_n(500),
       aes(carat, price)) +
  geom_point(size=5, alpha=0.5, col="red")

## mapping
ggplot(diamonds %>% sample_n(500), 
       mapping = aes(carat, price, col = cut)) +
  geom_point(size=5, alpha=0.5) +
  theme_minimal()

## add label
ggplot(diamonds %>% sample_n(500), 
       mapping = aes(carat, price, col = cut)) +
  geom_point(size=5, alpha=0.5) +
  theme_minimal() +
  labs(
    title = "Relationship between carat and price",
    x = "carat",
    y = "price USD",
    caption = "datasource: diamonds ggplot2"
  ) + 
  scale_color_manual(values = c("red","green","blue","gold","salmon"))


ggplot(diamonds %>% sample_n(500), 
       mapping = aes(carat, price, col = cut)) +
  geom_point(size=5, alpha=0.5) +
  theme_minimal() +
  labs(
    title = "Relationship between carat and price",
    x = "carat",
    y = "price USD",
    caption = "datasource: diamonds ggplot2"
  ) + 
  scale_color_viridis_d(direction = -1)

ggplot(diamonds %>% sample_n(500), 
       mapping = aes(carat, price, col = cut)) +
  geom_point(size=5, alpha=0.5) +
  theme_minimal() +
  labs(
    title = "Relationship between carat and price",
    x = "carat",
    y = "price USD",
    caption = "datasource: diamonds ggplot2"
  ) + 
  scale_color_brewer(type = "qual", palette = 1)

## map color scale
ggplot(mtcars, mapping=aes(hp, mpg, col = wt))+
  geom_point(size=5, alpha=0.7)+
  theme_minimal() +
  scale_color_gradient(low="gold", high="purple")

## facet
ggplot(diamonds %>% sample_n(5000), aes(carat, price))+
  geom_point(alpha=0.7)+
  geom_smooth(col="red")+
  theme_minimal()+
  facet_wrap( ~cut, ncol = 5)

ggplot(diamonds %>% sample_n(5000), aes(carat, price))+
  geom_point(alpha=0.7)+
  geom_smooth(col="red")+
  theme_minimal()+
  facet_grid(cut ~color)

## combine chart
library(patchwork)
library(ggplot2)

p1 <- qplot(mpg, data = mtcars, grom="histogram", bins=10)
p2 <- qplot(hp, mpg, data = mtcars, geom="point")
p3 <- qplot(hp, data=mtcars, geom="density")
p1 + p2 + p3
(p1 + p2) / p3

## quick plot
ggplot(mtcars, aes(hp, mpg)) + 
  geom_point()

























