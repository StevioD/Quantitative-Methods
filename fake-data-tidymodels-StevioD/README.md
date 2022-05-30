# Fake Data Analysis, Part 3

This assignment asks you continue to work with the synthetic data
set from the previous two assignments. This assignment will _really_ benefit
from doing the "Part 2" assignment, so I recommend completing that first before
doing this one. 

You have two weeks to submit your first draft on this assignment. 

## Tasks

In the first part of the fake data analysis you built a linear regression
model and reported the results. In the second part, you used a hold-out
sample to estimate the error of your regression model and fit a tree model
using `rpart`. 

In this assignment, I ask you to do the same tasks as part 2, but using tidymodels
syntax. Your linear regression should be defined with a call to `linear_reg` and the
tree should be set with `decision_tree` (or `random_forest` if you'd like to play with that). 
Both will use `set_engine` and feel free to use `lm` and `rpart` respectively. 

Use `initial_split` to do your training and assessment splits. Use a line, like
this one from the lecture, to measure the accuracy: 
```
metrics(d.test,truth=air_quality_index,estimate=pred_lm)
```

As always, take a bit of time to interpret your results. The linear regression
model commentary can be pulled directly from the previous assignment. Make
sure your HTML is well formatted and that your report reads like an actual
document rather than a screen dump. 



