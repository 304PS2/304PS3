#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from IPUMS USA
# Author: Michael Huang, Jiawei Wang, Huaqing Zhang, Qiushu Zhou
# Data: 2 November 2020
# Contact: qiushu.zhou@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the ACS data and saved it to inputs/data
# - Don't forget to gitignore it!


#### Workspace setup ####
library(haven)
library(tidyverse)
library(plyr)
# Read in the raw data.
setwd("C:/Sarah/third-Fall/STA304/PS3")
raw_data <- read_dta("usa_00001.dta")



# Add the labels
raw_data <- labelled::to_factor(raw_data)

# Just keep some variables that may be of interest (change 
# this depending on your interests)
reduced_data1 <- 
  raw_data %>% 
  select(region, sex,age, race)


#### What's next? ####

## Here we are splitting cells by age, sex, race and region


reduced_data1 <-
  reduced_data1 %>% 
  mutate(regions = region)
reduced_data1$regions <- 
  revalue(reduced_data1$regions, c("east south central div"="South"))
reduced_data1$regions <- 
  revalue(reduced_data1$regions, c("mountain division"="West"))
reduced_data1$regions <- 
  revalue(reduced_data1$regions, c("west south central div"="South"))
reduced_data1$regions <- 
  revalue(reduced_data1$regions, c("pacific division"="West"))
reduced_data1$regions <- 
  revalue(reduced_data1$regions, c("west north central div"="Midwest"))
reduced_data1$regions <- 
  revalue(reduced_data1$regions, c("middle atlantic division"="Northeast"))
reduced_data1$regions <- 
  revalue(reduced_data1$regions, c("south atlantic division"="South"))
reduced_data1$regions <- 
  revalue(reduced_data1$regions, c("east north central div"="Midwest"))
reduced_data1$regions <- 
  revalue(reduced_data1$regions, c("new england division"="Northeast"))

reduced_data1 <-
  reduced_data1 %>% 
  mutate(race_voter = race)
reduced_data1$race_voter <- 
  revalue(reduced_data1$race_voter, c("american indian or alaska native"="other"))
reduced_data1$race_voter <- 
  revalue(reduced_data1$race_voter, c("two major races"="other"))
reduced_data1$race_voter <- 
  revalue(reduced_data1$race_voter, c("other race, nec"="other"))
reduced_data1$race_voter <- 
  revalue(reduced_data1$race_voter, c("other asian or pacific islander"="Asian"))
reduced_data1$race_voter <- 
  revalue(reduced_data1$race_voter, c("chinese"="Asian"))
reduced_data1$race_voter <- 
  revalue(reduced_data1$race_voter, c("japanese"="Asian"))
reduced_data1$race_voter <- 
  revalue(reduced_data1$race_voter, c("three or more major races"="other"))


reduced_data1 <- 
  reduced_data1 %>% 
  select(age,
         sex,
         race_voter,
         regions)

reduced_data1 <- 
  reduced_data1 %>%
  dplyr::count(age,sex,race_voter,regions) %>%
  group_by(age,sex,race_voter,regions) 

reduced_data1 <- 
  reduced_data1 %>% 
  filter(age != "less than 1 year old") %>%
  filter(age != "90 (90+ in 1980 and 1990)")

reduced_data1$age <- as.integer(reduced_data1$age)


# Saving the census data as a csv file in my
# working directory
write_csv(reduced_data1, "census_data.csv")



         