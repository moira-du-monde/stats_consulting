df <- read.csv('simulated_survey_data.csv', header = T, na.strings=c('','NA'), stringsAsFactors = TRUE)

str(df)

summary(df)


df2 <- readr::read_csv('simulated_survey_data.csv', skip = 3, col_names=FALSE)


help("read_csv")


summary(df2)
head(df)
head(df2)

