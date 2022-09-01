
# use base R except where instructed otherwise


# Q1.  what version of R are you using?

sessionInfo()
# R version 4.1.2 (2021-11-01)
# Platform: x86_64-w64-mingw32/x64 (64-bit)
# Running under: Windows 10 x64 (build 22000)

Sys.info()
# sysname           release           version          nodename 
# "Windows"          "10 x64"     "build 22000" "DESKTOP-CD1V4US" 
# machine             login              user    effective_user 
# "x86-64"           "Moira"           "Moira"           "Moira"

devtools::session_info()
# setting  value
# version  R version 4.1.2 (2021-11-01)
# os       Windows 10 x64 (build 22000)
# system   x86_64, mingw32
# ui       RStudio
# language (EN)
# collate  English_United States.1252
# ctype    English_United States.1252
# tz       America/New_York
# date     2022-08-28
# rstudio  2022.07.1+554 Spotted Wakerobin (desktop)
# pandoc   NA

# ---

# import csv or txt files using base r

# Q2  a.	After importing the data frame, run it through the functions str() 
# and summary(). What are these showing you?

df <- read.csv('https://raw.githubusercontent.com/moira-du-monde/stats_consulting/main/tutorials/Sample_Dataset_2019.csv', header = T, na.strings=c('','NA'))
 
str(df) # output is a table with variable names and their data types (e.g., int, num, chr)

summary(df) # for integer and number variables, output is the min, max, median, mean, 25th and 75th percentiles, and number of NAs

# Q2 b. How many missing values are there for variable State?

sum(is.na(df$State)) #26

# ---

# import csv using readr::read_csv and leave stringsAsFactors = TRUE

# Q3 b. Which function did you use to do this?

library(readr) # versus readr::read_csv, latter used to load single internal function

args(read_csv) #no stringsasfactors arg, so convert with added step base R and dplyr

df <- read_csv('https://raw.githubusercontent.com/moira-du-monde/stats_consulting/main/tutorials/Sample_Dataset_2019.csv', na=c('','NA'))

library(dplyr) # load dplyr

df <- df %>% 
  mutate_if(is.character, factor) #convert strings to factors

# Q3 c. After importing the data frame, run it through the functions str() and summary(). What are these showing you?

str(df) # also shows data type of each variable, in this case numbers, factors, dates, and 'hms' num

summary(df) # min, max, median, mean, 25th, 75th percentiles, # of NAs

# Q3 d. How do the results of str() and summary() compare to the data frame you imported with read.csv?

# dates are converted from characters to date times and factored, other characters are factored and summed

# Q3 e.	How many missing values are there for variable State? A: 26 (no need to do any extra calculations)

# ---

# Import the SPSS *.sav data file using haven::read_spss() # I ended up uploading this into the environment

df_spss <- haven::read_spss("C:/Users/Moira/Downloads/Sample_Dataset_2019.sav")

# Q4 b.	After importing the data frame, run it through the functions str() and summary(). What are these showing you?

str(df_spss) # summary hashable format.spss document with each variable's data type

summary(df_spss) # min, max, mean, median, 25th and 75th percentiles, NAs **just like base R**

# Q4 c.	How do the results of str() and summary() compare to the data frame you imported with read.csv, readr::read_csv(), and haven::read_spss()?

# A: suggest it's importing as a tibble, which is a really crude kind of df

# ---

# Import the Excel *.xlsx data file using readxl::read_excel()

df_xl <- readxl::read_excel("C:/Users/Moira/Downloads/Sample_Dataset_2019.xlsx")

# Q5 b.	After importing the data frame, run it through the functions str() and summary(). What are these showing you?

str(df_xl) # summary table document with each variable's data type

summary(df_xl) # min, max, mean, median, 25th and 75th percentiles, NAs **just like base R**

# Q5 c.	How do the results of str() and summary() compare to the data frame you imported with read.csv, readr::read_csv(), and haven::read_spss()?

# A: Similar to importing with base R

# ---


# 6.	Create a frequency table for variable State.
# a.	Create a frequency table that explicitly shows the number of missing values.
# b.	How would you add marginal frequencies (i.e., row/column totals) to the table?
# c.	How would you display the proportions for this table? (Note: you do not need to have the frequencies and proportions printed side-by-side to answer this question)

df <- read.csv('https://raw.githubusercontent.com/moira-du-monde/stats_consulting/main/tutorials/Sample_Dataset_2019.csv', header = T, na.strings=c('','NA'))

df <- df %>% 
  mutate_if(is.character, factor)

mytable <- table(df$State, exclude = "no")

# alt : df_table <- table(df$State,useNA="always")

mytable$ttl <- c(margin.table(mytable))

mytable

df_table <- table(df$State,useNA="always")

df_table$prop <- c(prop.table(df_table))

df_table

# ---

# 7.	Create a frequency table for variable Rank.
# a.	Create a frequency table for the variable Rank. Notice that it prints the data values 1, 2, 3, 4.
# b.	Like SAS, SPSS, and Stata, R has the ability to assign labels to numeric values (R treats these as a special type(s) of variable) and treat the resulting variables as nominal or ordinal. What base R function(s) do this? ________________
# c.	After finding and applying the base R function(s) to assign labels to the numeric values, rerun the frequency table.

rank_data <- table(df$Rank, exclude = "no")

rank_data

#use factor() function for nominal data

# use ordered() function for ordinal data
df$desc <- ordered(df$Rank,
                   levels = c(1,2,3,4),
                   labels = c("Below 25th", "Above 25th", "Above 50th", "Above 75th"))
table(df$desc)

# 8.	What proportion of students are overweight (BMI > 25)?
# a.	Compute BMI from weight (in pounds) and height (in inches) as a new variable in your dataframe.
# b.	Compute a new variable categorizing the numeric BMI values into ranges (can use the CDC guidelines to determine cutpoints) as a new variable in your dataframe.
# c.	Tabulate the new variable from step B and get proportions.


df <- df %>%
  mutate(BMI = df$Weight / (df$Height * df$Height)*703)

df$BMI <- df$Weight / ((df$Height * df$Height)*703)

summary(df)

overweight <- df %>%
  filter(BMI > 25)

count(overweight)

perc_overweight <- count(overweight) / ( 435 - 70 )
perc_overweight


df$category <- cut(df$BMI,breaks = c(18.5,25,30,40),labels = c("healthy","overweight", "obese"))

bmi_data <- table(df$category, exclude = "no")
bmi_prop <- c(prop.table(bmi_data))
bmi_prop

# 9.	Obtain descriptive statistics (mean/sd/confidence intervals, possibly by groups, and Pearson correlations; OR frequency tables/crosstabs/proportions) for the following sets/pairs of variables. (Note: The appropriate responses will not be ones that have all NA values)
# a.	Height and Weight
# b.	English, Reading, Math, Science
# c.	Mile and Athlete Y/N
# d.	State and LiveOnCampus
# e.	LiveOnCampus, HowCommute, CommuteTime

test <- cor.test(df$Height, df$Weight)
test

tabs <- xtabs(~ Mile + Athlete, df)
table(tabs)

subject_props <- c(prop.table(subject))
subject_props

# 10.	What is the Cronbach’s alpha for the extraversion scale? (Note: There isn’t a Cronbach’s alpha function in base R, as far as I know; there is one in package psych)
# a.	Check if any of the items need to be reverse-coded before doing this.
# b.	After obtaining the Cronbach’s alpha value, compute a new variable containing the subjects’ composite scores by averaging their responses to the Likert items. Note: Simply using the mean() function alone will not achieve this.




# 11.	If you do a linear regression of SleepTime (Y) on StudyTime (X), are the assumptions of linear regression met?
# a.	What is the base R function to run a linear regression?
# b.	How can you print the “classic” table of regression parameter estimates, t-statistics, p-values from this linear regression?
# c.	How can you plot the residuals from this linear regression?
# d.	Re-do the linear regression after mean-centering the independent variable.

linearmodel <- lm(df$StudyTime ~ df$SleepTime)

library(jtools)

summ(linearmodel)
summary(linearmodel)


linearmodel.lm = lm(df$SleepTime ~ df$StudyTime)
linearmod.res = resid(linearmodel.lm)

mod <- predict(linearmodel.lm)
plot(mod,linearmod.res,
     ylab = "resid", xlab = "pred")
abline(0,0)


# df[is.na(df)] <- 0
df <- na.omit(df)

summary(df$StudyTime)

df <- df %>%
  mutate(st = df$StudyTime - mean(df$StudyTime))
summary(df$st)

linearmodel.lm = lm(df$SleepTime ~ df$st)
linearmod.res = resid(linearmodel.lm)


mod <- predict(linearmodel.lm)
plot(mod,linearmod.res,
     ylab = "resid", xlab = "pred")
abline(0,0)

# 12.	If you do a linear regression of SleepTime (Y) on StudyTime and Rank (X), are the assumptions of linear regression met? 
# Linear relationship.
# Multivariate normality.
# No or little multicollinearity.
# No auto-correlation.
# Homoscedasticity.

df <- read.csv('https://raw.githubusercontent.com/moira-du-monde/stats_consulting/main/tutorials/Sample_Dataset_2019.csv', header = T, na.strings=c('','NA'))

df <- df %>% 
  mutate_if(is.character, factor)

fit <- lm(df$SleepTime ~ df$StudyTime + df$Rank)
summary(fit)

# a.	Run the model with Rank as a numeric variable. What terms are in the model?
# b.	Run the model with Rank as an “ordered” variable. What terms are in the model?
# c.	Run the model with Rank as a “factor” variable. What terms are in the model?
# d.	What are the differences between these 3 approaches?
# e.	Re-do the regression after group-mean centering variable StudyTime about the means of the class rank groups.
