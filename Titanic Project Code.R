#Setting working directory
setwd("C:\\Data Analytics\\Data Analytics Course Material\\Week 9- Machine Learning 2-Titanic_dataset")

#Loading packages
library(randomForest) #classification algorithm
library(ggplot2) #visualization
library(dplyr)  #data manipulation
library(ggthemes) #data visualization

#loading data set
train <- read.csv('train1.csv', stringsAsFactors = FALSE)
test <- read.csv('test1.csv', stringsAsFactors = FALSE)

#checking head of train and test data
head(train)
head (test)



#combining both datasets to see complete data set
complete <- bind_rows(train, test)
str(complete)
#exploratory analysis
#summary of complete dataset
summary (complete)


#finding columns with missing values
sapply(complete, function(x) sum(is.na(x)))


#Missing values:
#Survived = 418
#Age = 263
#Fare = 1
#Embarked = 2
#Cabin = 1014

#Exploring relationship between Age and Survival
# Age vs Survived
ggplot(complete[1:891,], aes(Age, fill = factor(Survived))) + 
  geom_histogram(bins=30) + 
  theme_few() +
  xlab("Age") +
  scale_fill_discrete(name = "Survived") + 
  ggtitle("Age vs Survived")

#Sex v/s survived
ggplot(complete[1:891,], aes(Sex, fill = factor(Survived))) + 
  geom_bar(stat = "count", position = 'dodge')+
  theme_few() +
  xlab("Sex") +
  ylab("Count") +
  scale_fill_discrete(name = "Survived") + 
  ggtitle("Sex vs Survived")

tapply(complete[1:891,]$Survived, complete[1:891,]$Sex,mean)

#Sex vs Survived vs Age 
ggplot(complete [1:891,], aes(Age, fill = factor(Survived))) + 
  geom_histogram(bins=30) + 
  theme_few() +
  xlab("Age") +
  ylab("Count") +
  facet_grid(.~Sex)+
  scale_fill_discrete(name = "Survived") + 
  theme_few()+
  ggtitle("Age vs Sex vs Survived")

# Pclass vs Survived

tapply(complete[1:891,]$Survived,complete[1:891,]$Pclass,mean)

ggplot(complete [1:891,], aes(Pclass, fill = factor(Survived))) + 
  geom_bar(stat = "count")+
  theme_few() +
  xlab("Pclass") +
  facet_grid(.~Sex)+
  ylab("Count") +
  scale_fill_discrete(name = "Survived") + 
  ggtitle("Pclass vs Sex vs Survived")

# Extracting Title from Complete dataset
complete$Title <- gsub('(.*, )|(\\..*)', '', complete$Name)

#Tabulate Title count by Sex
table(complete$Title, complete$Sex)

#The most common titles found: Master, Miss, Mr, Mrs
#Reassigning other less frequent titles to salut_title
salut_title <- c("Capt", "Col", "Don", "Dona", "Dr",
                 "Jonkheer", "Lady", "Major", "Rev", "Sir", "the Countess")

#The French titles are combined to popular English title
complete$Title[complete$Title == 'Mlle'] <- 'Miss' 
complete$Title[complete$Title == 'Ms']  <- 'Miss'
complete$Title[complete$Title == 'Mme']  <- 'Mrs' 

#Assigning salut_title to the complete dataset
complete$Title [complete$Title %in% salut_title] <- "Salutation Title"

#compare Title versus survived
ggplot(complete [1:891,], aes(Title, fill = factor(Survived))) + 
  geom_bar(stat = "count")+
  theme_few() +
  xlab("Title") +
  ylab("Count") +
  scale_fill_discrete(name = "Survived") + 
  ggtitle("Title vs Survived")


#Extracting family name
complete$Family_Name <- sapply (complete$Name, function (x)
                               strsplit(x, split = "[, .]")[[1]][1])


#Getting count of unique family Name
nlevels(factor(complete$Family_Name))

# Create a family size variable including the passenger themselves
complete$Fsize <- complete$SibSp + complete$Parch + 1

# Create a family variable 
complete$Family <- paste(complete$Family_Name, complete$Fsize, sep='-')
complete$Family

# Use ggplot2 to visualize the relationship between family size & survival
ggplot(complete [1:891,], aes(x = Fsize, fill = factor(Survived))) +
  geom_bar(stat='count', position='dodge') +
  scale_x_continuous(breaks=c(1:11)) +
  labs(x = 'Family Size') +
  theme_few()

# Divide the family size into three categories
complete$FsizeD [complete$Fsize == 1] <- 'Single'
complete$FsizeD [complete$Fsize < 5 & complete$Fsize > 1] <- 'Small'
complete$FsizeD [complete$Fsize > 4] <- 'Big'
complete$FsizeD
complete$Fsize
table (complete$FsizeD)

#plotting family size against survival
mosaicplot(table(complete$FsizeD, complete$Survived), 
           main='Family Size by Survival', shade=TRUE)


#Missing value imputation

#Embarked
median(complete$Embarked, na.rm = TRUE)

#Imputing missing Embarked value with "S"
complete$Embarked[which(is.na(complete$Embarked))] <-"S"

str (complete)

#Cabin has just too many missing values, so we will create a dummy variable
complete$In_Cabin <- ifelse(is.na (complete$Cabin), 0, 1)
table(complete$In_Cabin)

#Fare missing value imputation
which(is.na(complete$Fare))
complete[1044, ]

#Will replace with median of PClass = 3
tapply(complete$Fare, complete$Pclass,median, na.rm=TRUE)
complete$Fare[1044] <- median(complete[complete$Pclass == '3', ]$Fare, na.rm = TRUE)
complete$Fare[1044]

#Age imputation
tapply(complete$Age, complete$Pclass,median, na.rm=TRUE)
tapply(complete$Age, complete$Title,median, na.rm=TRUE)

#create a new variable title.age
title.age <- aggregate(complete$Age, by = list(complete$Title), 
                       FUN = function(x) median(x, na.rm = T))

complete[is.na(complete$Age), "Age"] <- apply(complete[is.na(complete$Age), ]
                    , 1, function(x) title.age[title.age[, 1]==x["Title"], 2])

#Na value count
sum(is.na(complete$Age))

#Distribute Age into 2 categories, Child and Adult
complete$Age_Cat <- ifelse(complete$Age < 18, "Child", "Adult")

# Find total numbers of Child and Adult passengers
table(complete$Age_Cat)

# Age Category versus Survived
table(complete$Age_Cat, complete$Survived)

# Structure of complete dataset
str (complete)

#converting into factors
complete$Age_Cat  <- factor(complete$Age_Cat)
complete$Sex  <- factor(complete$Sex)
complete$Embarked  <- factor(complete$Embarked)
complete$Title  <- factor(complete$Title)
complete$Pclass  <- factor(complete$Pclass)
complete$FsizeD  <- factor(complete$FsizeD)
str(complete)

#Making a subset of complete dataset
complete_sub <- complete [, c(1, 2, 3, 5, 6, 10, 12, 13, 15, 17, 18, 19)]
str(complete)

# Creating training and test variables from subset
train <- complete_sub [1:891, ]
test <- complete_sub [892:1309,]


#creating randomForest model

set.seed (3)

rf1<- randomForest(as.factor(Survived) ~.,data=train,ntrees=200,mtry=6,
                   importance=TRUE,strata=train$Survived,
                   sampsize=c(300,300),trace=TRUE,normalize = TRUE,
                   na.action=na.exclude)

#OOB Estimate and confusion matrix
print (rf1)

#Getting the most important variables
varImpPlot(rf1, main = "Random Forest Model")


#Prediction
prediction <- predict (rf1, test)
prediction

# Solution for submission
Survived_List <- data.frame(PassengerID = test$PassengerId, Survived = prediction)
head (Survived_List)

# write csv
write.csv(Survived_List, file = 'submission.csv', row.names = F)
