# Exploratory Data Analysis on English Premier League: Project Overview 
- [x] Used the dataset and compared the performance of two soccer clubs (Liverpool and Manchester City). 
- [x] Built a Poisson Regression model to predict a number of scored/conceded goals.
- [x] Checked the model by comparing the last game week.

## Code and Resources Used
- **Technology:** PostgreSQL, Tableau, R.
- **Data Source:** Used the results of [Premier League](https://www.footballdata.co.uk/mmz4281/1819/E0.csv) season 2018-2019.
- **Packages:** tidyverse, ggplot2, skellam. 

## Data Cleaning
PostgreSQL helped to work with queries. First, I load the dataset in the pgAdmin 4 Database and extract the table with information about the home... 
![](https://github.com/IsmailovKamil/GMU_Final_Projects/blob/master/EDA%20on%20English%20Premier%20League/images/Home%20Team%20Performance.png)
...and away team performance
![](https://github.com/IsmailovKamil/GMU_Final_Projects/blob/master/EDA%20on%20English%20Premier%20League/images/Away%20Team%20Performance.png)

## Model Building
Poisson distribution is one of the earliest statistical methods of forecasting sports events because it is discrete probability distribution which can be used to model data that the number of events within a specific time period (e.g. 90 minutes per game) with a known average rate of occurrence and independently of the time since the last event
<p align="center"> 
<code> poisson_model <- glm(Goals ~ Home + Team + Opponent, family=poisson(link=log), data=model) </code>
</p>
  
## Model performance
Simulated the last 10 games using the prediction model and compared it with the real results to check the accuracy of the Poisson model.

<p align="center"> 
<img src="https://github.com/IsmailovKamil/GMU_Final_Projects/blob/master/EDA%20on%20English%20Premier%20League/images/Predicted_gameweek%20.png" title="Predicted results"/> 
</p> 

<p align="center"> Predicted results </p>

<p align="center"> 
<img src="https://github.com/IsmailovKamil/GMU_Final_Projects/blob/master/EDA%20on%20English%20Premier%20League/images/Actual_Results.png"/>
</p>

<p align="center"> Actual results </p>
