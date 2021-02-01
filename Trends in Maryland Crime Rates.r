## 1. Maryland crime data
# Load the packages
library(tidyverse)

# Set directory and read in the crime data
setwd("~/Dropbox/GMU/Spring 2020/SYST 568 Applied Predictive Analytics/Final Project/Trends in Maryland Crime Rates/datasets")
crime_raw <- read_csv("Violent_Crime___Property_Crime_by_County__1975_to_Present.csv")

# Select and mutate columns the needed columns
crime_use <- crime_raw %>% 
    select(JURISDICTION, YEAR, POPULATION, crime_rate = `VIOLENT CRIME RATE PER 100,000 PEOPLE`)

head(crime_use)

## 2. Data preparation and exploratory analysis
# Plot the data as lines and linear trend lines
ggplot(crime_use, aes(x = YEAR, y = crime_rate, group = JURISDICTION)) + 
  geom_line() + 
  stat_smooth(method = "lm", se = FALSE, size = 0.5)

# Mutate data to create another year column, YEAR_3
crime_use <-
  crime_use %>% mutate(YEAR_2 = YEAR - min(YEAR))

head(crime_use)

## 3. Linear mixed-effects regression model (LMER)
# load the lmerTest package
library(lmerTest)

# Build a lmer and save it as lmer_crime
lmer_crime <- lmer(crime_rate ~ YEAR_2 + (YEAR_2|JURISDICTION), crime_use)

## 4.	Output interpretations 
# Examine the model outputs using summary
summary(lmer_crime)

# This is for readability 
noquote("**** Fixed-effects ****")

# Use fixef() to view fixed-effects
fixef(lmer_crime)

# This is for readability 
noquote("**** Random-effects ****")

# Use ranef() to view random-effects
ranef(lmer_crime)

# Add the fixed-effect to the random-effect and save as county_slopes
county_slopes <- fixef(lmer_crime)["YEAR_2"] + ranef(lmer_crime)$JURISDICTION["YEAR_2"]

# Add a new column with county names and population
pop_2017 <- crime_use %>% select(POPULATION,YEAR) %>% filter (YEAR == 2017)

county_slopes <-
  county_slopes %>% rownames_to_column("county") %>% mutate(POPULATION = pop_2017$POPULATION)
head(county_slopes)


## 5. Maryland map data
# Load usmap package
library(usmap)

# load and filter map data
county_map <- us_map(regions = "counties", include = "MD")
head(county_map)

### Matching county names
# See which counties are not in both datasets
county_slopes %>% anti_join(county_map, by = "county")
county_map %>% anti_join(county_slopes, by = "county")

# Rename crime_names county
county_slopes  <- county_slopes  %>% 
  mutate(county = ifelse(county == "Baltimore City", "Baltimore city", county))

### Merging data frames
# Merge the map and slope data frames
both_data <- full_join(county_map,county_slopes) 

# Peek at the data
head(both_data)

### Mapping trends
# Set the notebook's plot settings
options(repr.plot.width=10, repr.plot.height=5)

# Plot the results 
crime_map <- 
  ggplot(both_data, aes(x,y, group = county, fill = YEAR_2)) +
  geom_polygon() + 
  scale_fill_continuous(name = expression(atop("Change in crime rate","(Number year"^-1*")")),
                        low = "gold", high = "purple")

# Look at the map
crime_map

# Plot options
options(repr.plot.width=10, repr.plot.height=5)

# Polish figure
crime_map_final <- crime_map + 
  theme_minimal() + xlab("") + ylab("") +
  theme(axis.line = element_blank(), axis.text = element_blank(),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.border = element_blank(), panel.background = element_blank())

# Look at the map
print(crime_map_final)

# Plot the population 
pop_map <- 
  ggplot(both_data, aes(x,y, group = county, fill = POPULATION)) +
  geom_polygon() + 
  scale_fill_continuous(name = expression(atop("Population")),
                        low = "skyblue", high = "blue")
pop_map

pop_map_final <- pop_map + 
  theme_minimal() + xlab("") + ylab("") +
  theme(axis.line = element_blank(), axis.text = element_blank(),
        panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
        panel.border = element_blank(), panel.background = element_blank())
pop_map_final

require(gridExtra)
grid.arrange(crime_map_final, pop_map_final, ncol=2)
