# Bootstrapping Regression Statistics

This assignment asks you to use the bootstrap technique we've discussed
to generate bootstrap statistics and compare those to the standard estimates
from R. The details are in `reg_boot.rmd`. Cheers!

## Feedback

Your RMD has a vector printed to the screen. It's where you write 
`as.factor(d$assigned_sex)` but don't assign it anywhere. `lm` is treating
sex like a factor, so you're covered, so you can safely just delete the 
line. Or if you'd like to be explicit, assign it as so: 
```
d$assigned_sex <- as.factor(d$assigned_sex)
```

You write
> If you identify as neither gender in the company your satisfaction scored on averge are 0.37 ponits less than female given the same year of tenure is very highly significant.

The p-value on that term isn't significant. When you are including a categorical variable in a regression model, there's no notion of 
dropping one of the levels. (You probably know this, but the write-up is slightly ambiguous and I 
want to make sure you know it.) The test for significance for a categorical variable comes out of 
`anova(model.obj, test="Chisq")`. As such, I typically avoid too much discussion of "significance" 
for the individual levels and just talk about how precise the estimate is. Then I'll talk about 
the overall significance of the term.

It's very cool that you used the `boot` package, and that's definitely the way to do 
this when you have to do it "in the wild". For our purposes, I'd probably 
like to see you do it by hand, as we have the previous assignments, although that's
not required. What _is_ required is to fully interpret the bootstrap values rather
than just printing them to the screen. See this as a written report, where I expect
to learn from the words you write and the figures you make. Just printing to the screen
is fine for reports that are only going to be seen by you, but not enough in a more
professional setting. All the information is on here, but I expect you to spell it
out for the reader. Similarly, spend  a little more time on the comparison to the
`lm` standard errors. 

## Feedback 2

You write
> The interception: Females who has 0 tenure on average scored 3.18 more than the rest of the group.
> 

This interpretation isn't correct. (You're also using "interception" when you mean "intercept".) Are you
saying that females have a 3.18 higher satisfaction than other employees? 

You write
> If you identify as neither gender in the company your satisfaction scored on averge are 0.37 ponits less than female given the same year of tenure is very highly significant.
> 

How do you know this term is highly significant? Convince me, don't just say it.

Don't just write 
> We are 90% confident that the interval contains the true means of the resampling data.
> 

This doesn't really say anything. You print this: 

```
## BOOTSTRAP CONFIDENCE INTERVAL CALCULATIONS
## Based on 1000 bootstrap replicates
## 
## CALL : 
## boot.ci(boot.out = results, conf = 0.9, type = "bca", index = 3)
## 
## Intervals : 
## Level       BCa          
## 90%   (-0.8170,  0.0129 )  
## Calculations and Intervals on Original Scale
```

What variable is this? How does this CI compare to what we get from the original model? Repeat that for every variable. 
