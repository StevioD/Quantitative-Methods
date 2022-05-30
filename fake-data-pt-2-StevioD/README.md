# Fake Data Analysis, Part 2

This assignment asks you continue to work with the synthetic data
set from the previous assignment. If you didn't do that assignment but would like to work 
on this one, that's fine, but you'll need to build a quick regression model on the data
in order to do the first part of this. You have two weeks to submit your first
draft on this assignment. 

## Tasks

You have two tasks in this assignment. One is to use a holdout sample to estimate
your prediction error rate. The other task is to try fitting a tree model to your
data using `rpart`. 

1. Repeat the analysis from the previous assignment (building a regression model). Before
you fit your model, split the data with 80% going into a training data set and 20% going 
into an assessment data set. Build your model on the training data set. Predict the values
of the assessment data set and compare those to the actual values of the response data set. 
Report some measures of accuracy that you think make sense, such as RMSE or accuracy.

2. Build a regression tree to analyze the data. Again, just use the training set to fit
a model with `rpart`. Once again, estimate the accuracy on your assessment data set. Which
model fits the data better? 

