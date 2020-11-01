#### Preamble ####
# Purpose: Prepare and clean the survey data downloaded from Democracy Fund + UCLA Nationscape ¡®Full Data Set¡¯
# Author: Michael Huang, Jiawei Wang, Huaqing Zhang, Qiushu Zhou
# Data: 2 November 2020
# Contact: qiushu.zhou@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have downloaded the data from X and save the folder that you're 
# interested in to inputs/data 
# - Don't forget to gitignore it!



#### Workspace setup ####
library(plyr)
library(haven)
library(tidyverse)

# Read in the raw data (You might need to change this if you use a different dataset)
setwd("C:/Sarah/third-Fall/STA304/PS3")
raw_data <- read_dta("ns20200625/ns20200625.dta")
# Add the labels
raw_data <- labelled::to_factor(raw_data)
# Just keep some variables
reduced_s_data <- 
  raw_data %>% 
  select(age,
         gender,
         race_ethnicity,
         census_region,
         vote_2020
         )
summary(reduced_s_data)

reduced_s_data <-
  reduced_s_data%>%
  filter(vote_2020 != "I am not sure/don't know") %>%
  filter(vote_2020 != "I would not vote")%>%
  filter(vote_2020 != "Someone else")%>%
  filter(vote_2020 != is.na(vote_2020))

reduced_s_data <- 
  reduced_s_data%>%
  mutate(regions = census_region)


reduced_s_data<-
  reduced_s_data %>%
  mutate(vote_trump = 
           ifelse(vote_2020=="Donald Trump", 1, 0))

reduced_s_data<-
  reduced_s_data %>%
  mutate(sex = 
           ifelse(gender=="Male", "male", "female"))
reduced_s_data<-
  reduced_s_data %>%
  mutate(race_voter= 
           ifelse(race_ethnicity=="Asian (Chinese)" | race_ethnicity=="Asian (Japanese)" | race_ethnicity=="Asian (Korean)" | race_ethnicity=="Asian (Asian Indian)" | 
                    race_ethnicity=="Asian (Filipino)" | race_ethnicity=="Asian (Vietnamese)" | race_ethnicity=="Asian (Other)", "Asian", ifelse(race_ethnicity=="White"
                                , "white", ifelse(race_ethnicity=="Black, or African American", "black/african american/negro","other"))))
reduced_s_data <- 
  reduced_s_data %>% 
  select(age,
         sex,
         race_voter,
         regions,
         vote_trump)




# Saving the survey/sample data as a csv file in my
# working directory
write_csv(reduced_s_data, "survey_data.csv")

