#install packages first


library(rpart)
library(Hmisc)
library(rpart.plot)
library(PRROC)


#Import dataset
grad <- read.csv("NewCombinedFile.csv")
head(grad)

#run descritpive stats
describe(grad)  #In the Hmisc package or just use summary if Hmisc doesn't work for you.
summary(grad)


#Create a training and testing dataset
#This takes number of rows and divides by two for a 50/50 split
bound <- floor((nrow(grad)/2))

#This randomly shuffles the entire dataset
grad <- grad[sample(nrow(grad)),]

#Create a new dataframe called grad.train that contains record #1 to "bound"
grad.train <- grad[1:bound, ]

#Create a new dataframe called grad.test that contains record "bound" to the end of the dataframe
grad.test <- grad[(bound+1):nrow(grad), ]



#create decision tree using rpart
#This is your model!
fit <- rpart(Admit ~ GRE + GPA, method="class", data=grad.train)

#This line of code assigns the variable called depvariable to the name of the dependent variable
#in the model above.  We will use this variable below in the ROC curve code.  Change "Admit" to the 
#name of your dependent variable.
depvariable <- "Admit"

#Important:  Please read this.
#At this point, check the fit variable in RStudio.  If it is >=14 then you are good.
#If it is 12 or less then you did not build a tree.  Basically R doesn't think that that the tree can
#be split based on the x-variables you used.  At this point you must change your model before you 
#can continue


#Display decision tree
plot(fit, uniform = TRUE, margin=.05)
text(fit, use.n=TRUE, all=TRUE, cex=0.6)

#A fancy plot if you prefer this one instead
prp(fit, type=2, extra=104)


#predict the outcome using the test dataset
pred1 <- predict(fit, grad.test, type="class")

#Place the prediction variable back in the test dataset
grad.test$pred1 <- pred1

#Display Confusion Matrix - this is the correct display of the table. 
#Change the name of Admit to the dependent variable
rtable<-table(grad.test$Admit,grad.test$pred1, dnn=c("Actual", "Predicted"))
rtable

#Display accuracy rate
#Change the name of Admit to the dependent variable
sum(grad.test$Admit==pred1)/length(pred1)

#true positive rate:
tpr <- sum(rtable[2,2])/sum(rtable[2,])

#false positive rate:
fpr <- sum(rtable[1,2])/sum(rtable[1,])



######
#ROC Curve
#The only think you need to change below is: 
#1) the name of your datasets. For example, grad.test$ below should be the name of your testing dataset.  
#2) On lines 99 and 100, the 1 and 0 should reflect the values of your depedent variable.
######

# for ROC curve we need probabilties so we can sort grad.test
grad.test$probs <- predict(fit,grad.test, type="prob")[,2] # returns prob of both cats, just need 1

roc.data <- data.frame(cutoffs = c(1,sort(unique(grad.test$probs),decreasing=T)),
                       TP.at.cutoff = 0,
                       TN.at.cutoff = 0)

for(i in 1:dim(roc.data)[1]){
  this.cutoff <- roc.data[i,"cutoffs"]
  roc.data$TP.at.cutoff[i] <- sum(grad.test[grad.test$probs >= this.cutoff,depvariable] == 1)
  roc.data$TN.at.cutoff[i] <- sum(grad.test[grad.test$probs < this.cutoff,depvariable] == 0)
}
roc.data$TPR <- roc.data$TP.at.cutoff/max(roc.data$TP.at.cutoff) 
roc.data$Specificity <- roc.data$TN.at.cutoff/max(roc.data$TN.at.cutoff) 
roc.data$FPR <- 1 - roc.data$Specificity

with(roc.data,
     plot(x=FPR,
          y=TPR,
          type = "l",
          xlim=c(0,1),
          ylim=c(0,1),
          main="ROC Curve'")     
)
abline(c(0,1),lty=2)
######End ROC code


