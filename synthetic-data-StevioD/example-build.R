

# This file builds a fake data set that simulates 
# the number of traffic accidents on Lyndale between Franklin and Lake
# streets in Minneapolis (normalized per 10K trips). Explanatory variables that influence
# crashes are time of day, weather, and day of week. 
#
# Goal is to average about 5 on weekdays with good weather, 2 on weekends. 

library(tidyverse)

num.rows <- 1000

# Use set.seed to make your results reproducible.
set.seed(20210218)

# Make the data
fake.data <- tibble(row=1:num.rows)

# Add some categorical variables
fake.data <- fake.data %>% 
  mutate(weekday = sample(x=c("M","Tu","W","Th","Fr","Sa","Su"),
                          size=num.rows,
                          replace=T),
         weather = sample(x=c("sunny","rainy","snowy"),
                          size=num.rows,
                          replace=T,prob=c(0.5,0.2,0.3)),
         time = sample(x=c("overnight","morning rush","midday","evening rush"),
                       size=num.rows,
                       replace=T))


# Add some continuous variables
fake.data <- fake.data %>% 
  mutate(temperature = if_else(weather=="snowy",
                               rnorm(n=num.rows,mean=10,sd=5),
                               rnorm(n=num.rows,mean=70,sd=10)),
         pedestrian_level=rpois(num.rows,lambda=5),
         police_presence = sample(x=1:4,size=num.rows,replace=T,prob=4:1),
         consumer_satisfaction = rnorm(num.rows,mean=50,sd=15))


# Let's build some models. We need to convert our categorical
# data to numerical to get the impact on traffic accidents. This 
# next section builds lookup tables of coefficients and joins them
# onto the data set. 

weekday.coefs <- tibble(weekday=c("M","Tu","W","Th","Fr","Sa","Su"),
                        wd_coef=c(3.5,2,1.5,1.5,4,1,0.5))

weather.coefs <- tibble(weather = c("sunny","rainy","snowy"),
                        wx_coef = c(-1,1,2))

time.coefs <- tibble(time=c("overnight","morning rush","midday","evening rush"),
                     t_coef=c(2,1,-0.5,1.5))


# Join on the coefs
fake.data <- fake.data %>% 
  left_join(weekday.coefs,by="weekday") %>% 
  left_join(weather.coefs,by="weather") %>% 
  left_join(time.coefs,by="time")


#########################################################################
#              Example Models                                           #
#########################################################################
# 
# I'll do three of these models, just so you can see different flavors, but
# you only need to do one!

# This model only has categorical terms.
# Now make the response. It'll be the coefs plus some error
fake.data <- fake.data %>% 
  mutate(accidents_per_10K_1 = wd_coef + 
           wx_coef + 
           t_coef +
           3 * pedestrian_level + 
           rnorm(num.rows,
                 mean=0, # this must be set to 0
                 sd=2),
         accidents_per_10K_1 = pmax(accidents_per_10K_1,0)) # ensure positive


# now model 2, only continuous data
fake.data <- fake.data %>% 
  mutate(accidents_per_10K_2 = 
           -0.2 * temperature + 
           3 * pedestrian_level + 
           rnorm(num.rows,
                 mean=0, # this must be set to 0
                 sd=2),
         accidents_per_10K_2 = pmax(accidents_per_10K_2,0)) # ensure positive

# model 3, categorical and continuous with an interaction term
fake.data <- fake.data %>% 
  mutate(accidents_per_10K_3 = 
           -0.2 * temperature + 
           t_coef +
           wx_coef + 
           -0.2 * wx_coef * temperature + 
           rnorm(num.rows,
                 mean=0, # this must be set to 0
                 sd=2),
         accidents_per_10K_3 = pmax(accidents_per_10K_3,0)) # ensure positive



# Drop the coefficients
fake.data <- fake.data %>% 
  select(-contains("coef"))

write_tsv(fake.data,"fake_traffic_accident_data.txt")

# Who can resist checking the model? 
arm::display(lm(accidents_per_10K_1 ~ weather + weekday + time,data=fake.data))
anova(lm(accidents_per_10K_1 ~ weather + weekday + time,data=fake.data))

arm::display(lm(accidents_per_10K_2 ~ temperature + pedestrian_level,data=fake.data))
anova(lm(accidents_per_10K_2 ~ temperature + pedestrian_level,data=fake.data))

