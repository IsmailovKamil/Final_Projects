# load library
library(dplyr)
library(ggplot2)
library(tidyr)
library(skellam)

# load data 
data <- read.csv("Premier League Season 2018-2019.csv")

# remove last 10 games to compare results with model
epl <- head(data,-10)
str(epl)

# build data frame for poisson model 
model <-  rbind(
  data.frame(Goals=epl$FTHG,
             Team=epl$HomeTeam,
             Opponent=epl$AwayTeam,
             Home=1),
  data.frame(Goals=epl$FTAG,
             Team=epl$AwayTeam,
             Opponent=epl$HomeTeam,
             Home=0))
head(model,10) 

# fit model and get a summary
poisson_model <- glm(Goals ~ Home + Team + Opponent, family=poisson(link=log), data=model)
summary(poisson_model)

#Simulate last gameweek
last_gameweek <- data[371:380, 3:4]

home_goals <- c(predict(poisson_model, data.frame(Home=1, Team="Brighton", Opponent="Man City"), type="response"), 
predict(poisson_model, data.frame(Home=1, Team="Burnley", Opponent="Arsenal"), type="response"),
predict(poisson_model, data.frame(Home=1, Team="Crystal Palace", Opponent="Bournemouth"), type="response"), 
predict(poisson_model, data.frame(Home=1, Team="Fulham", Opponent="Newcastle"), type="response"),
predict(poisson_model, data.frame(Home=1, Team="Leicester", Opponent="Chelsea"), type="response"), 
predict(poisson_model, data.frame(Home=1, Team="Liverpool", Opponent="Wolves"), type="response"),
predict(poisson_model, data.frame(Home=1, Team="Man United", Opponent="Cardiff"), type="response"), 
predict(poisson_model, data.frame(Home=1, Team="Southampton", Opponent="Huddersfield"), type="response"),
predict(poisson_model, data.frame(Home=1, Team="Tottenham", Opponent="Everton"), type="response"), 
predict(poisson_model, data.frame(Home=1, Team="Watford", Opponent="West Ham"), type="response"))


away_goals <- c(predict(poisson_model, data.frame(Home=0, Team="Man City", Opponent="Brighton"), type="response"),
predict(poisson_model, data.frame(Home=0, Team="Arsenal", Opponent="Burnley"), type="response"),
predict(poisson_model, data.frame(Home=0, Team="Bournemouth", Opponent="Crystal Palace"), type="response"),
predict(poisson_model, data.frame(Home=0, Team="Newcastle", Opponent="Fulham"), type="response"),
predict(poisson_model, data.frame(Home=0, Team="Chelsea", Opponent="Leicester"), type="response"),
predict(poisson_model, data.frame(Home=0, Team="Wolves", Opponent="Liverpool"), type="response"),
predict(poisson_model, data.frame(Home=0, Team="Cardiff", Opponent="Man United"), type="response"),
predict(poisson_model, data.frame(Home=0, Team="Huddersfield", Opponent="Southampton"), type="response"),
predict(poisson_model, data.frame(Home=0, Team="Everton", Opponent="Tottenham"), type="response"),
predict(poisson_model, data.frame(Home=0, Team="West Ham", Opponent="Watford"), type="response"))

last_gameweek <- last_gameweek %>% mutate(round(home_goals,0), round(away_goals,0))
last_gameweek
