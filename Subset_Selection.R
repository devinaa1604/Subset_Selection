setwd("/Users/devinaamangal/SMU/Subset_Selection")

install.packages("ISLR")
library(ISLR)

housing.df <- read.csv("WestRoxbury.csv", header = TRUE)  # load data
# Variable labels
t(t(names(housing.df)))
class(housing.df$TOTAL.VALUE)
class(housing.df$REMODEL)
levels(housing.df$REMODEL)
housing.df <- housing.df[,-2]
t(t(names(housing.df)))

# Option 2: use model.matrix() to convert all categorical variables in the data frame into a set of dummy variables. We must then turn the resulting data matrix back into 
# a data frame for further work.
REMODEL_new <- model.matrix(~ 0 + REMODEL, data = housing.df)
REMODEL_new <- as.data.frame(REMODEL_new)

head(REMODEL_new)
REMODEL_cut <- REMODEL_new[, -1]  # drop one of the dummy variables. 
# In this case, drop REMODELNone.
head(REMODEL_cut)
housing2.df <- cbind(housing.df[, -13],REMODEL_cut)
housing2.df <- cbind(housing.df[, -13],REMODEL_cut)
t(t(names(housing2.df)))

# Now we partition the housing2 data set.
# use set.seed() to get the same partitions when re-running the R code.
set.seed(1)

## partitioning into training (60%) and validation (40%)
# randomly sample 60% of the row IDs for training; the remaining 40% serve as the
# validation data
train.rows <- sample(rownames(housing2.df), dim(housing2.df)[1]*0.6)
# collect all the columns with training row ID into training set:
train.data <- housing2.df[train.rows, ]
head(train.data)
# assign row IDs that are not already in the training set, into validation 
valid.rows <- setdiff(rownames(housing2.df), train.rows) 
valid.data <- housing2.df[valid.rows, ]
head(valid.data)

# Here we start using the regsubset command in the leaps package to do our subset analysis.
library(leaps)
regfit.full <- regsubsets(TOTAL.VALUE ~ ., data = train.data, nvmax=11)
summary(regfit.full)
reg.summary <- summary(regfit.full)
names(reg.summary)
reg.summary$rsq

#plot rsq
install.packages("ggvis")
library(ggvis)
rsq <- as.data.frame(reg.summary$rsq)
names(rsq) <- "R2"
rsq %>% 
  ggvis(x=~ c(1:nrow(rsq)), y=~R2 ) %>%
  layer_points(fill = ~ R2 ) %>%
  add_axis("y", title = "R2") %>% 
  add_axis("x", title = "Number of variables")

# Here we get the dimensions of subset models chosen by the adjr2, cp, and bic criteria.
reg.summary$adjr2
reg.summary$cp
reg.summary$bic

# Here are some fancy plots showing the optimal choice of dimension using the various criteria.
# par(mfrow=c(2,2))
plot(reg.summary$rss ,xlab="Number of Variables ",ylab="RSS",type="l")
plot(reg.summary$adjr2 ,xlab="Number of Variables ", ylab="Adjusted RSq",type="l")
# which.max(reg.summary$adjr2)
points(9,reg.summary$adjr2[9], col="red",cex=2,pch=20)
plot(reg.summary$cp ,xlab="Number of Variables ",ylab="Cp", type='l')
# which.min(reg.summary$cp )
points(7,reg.summary$cp [7],col="red",cex=2,pch=20)
plot(reg.summary$bic ,xlab="Number of Variables ",ylab="BIC",type='l')
# which.min(reg.summary$bic )
points(7,reg.summary$bic [7],col="red",cex=2,pch=20)

# A set of plots showing the variables chosen by the various criteria.
plot(regfit.full,scale="adjr2")
plot(regfit.full,scale="Cp")
plot(regfit.full,scale="bic")

# Use the training data set to obtain the coefficients of the competing models.
lmfull <- lm(TOTAL.VALUE ~ ., data=train.data)
summary(lmfull)
lmadjr2 <- lm(TOTAL.VALUE ~ LOT.SQFT + GROSS.AREA + LIVING.AREA + FLOORS +  ROOMS
              + FULL.BATH + HALF.BATH + KITCHEN  + FIREPLACE + REMODELOld + REMODELRecent, data=train.data)
summary(lmadjr2)
lmcp <- lm(TOTAL.VALUE ~ LOT.SQFT + GROSS.AREA + LIVING.AREA + FLOORS +  ROOMS
           + FULL.BATH + HALF.BATH + KITCHEN  + FIREPLACE + REMODELOld + REMODELRecent, data=train.data)
summary(lmcp)
lmbic <- lm(TOTAL.VALUE ~ LOT.SQFT + GROSS.AREA + LIVING.AREA + FLOORS +  ROOMS
            + FULL.BATH + HALF.BATH + KITCHEN  + FIREPLACE + REMODELRecent, data=train.data)
summary(lmbic)

# Use accuracy() to compute accuracy measures for competing regressions 
# on the validation data set.
library(forecast)
# Use predict() to make predictions on the Validation Data Set
full.pred <- predict(lmfull,valid.data)
accuracy(full.pred,valid.data$TOTAL.VALUE)
adjr2.pred <- predict(lmadjr2,valid.data)
accuracy(adjr2.pred,valid.data$TOTAL.VALUE)
cp.pred <- predict(lmcp,valid.data)
accuracy(cp.pred,valid.data$TOTAL.VALUE)
bic.pred <- predict(lmbic,valid.data)
accuracy(bic.pred,valid.data$TOTAL.VALUE)

