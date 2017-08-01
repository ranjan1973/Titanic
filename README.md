# Titanic
Predict which passenger survived the biggest ocean tragegy
Here, I come Kaggle!  Seeing Jack getting frozen in the cold sea and Rose just seeing him losing his breaths one by one made me wonder how many other ill-fated travellers actually survived the biggest ship mishap in the history of mankind.  I have gone through a few more R scripts created by my fellow expert kagglers to learn the trick of the art and be able to make my predictions as close to the actual as I can.  I will first explore the datasets, visualize the datasets, and then will try to build a model with the help of randomForest algorithm to predict survivals from the ill-fated maiden voyage of Titanic.  Please don’t hesitate to give your precious feedbacks (I would love positive ones and appreciate negative ones) to help me better my Machine Learning curve.

My script will be basically divided into the following parts:
•	Data exploration
  o Loading  and checking data
  o Feature engineering
  o	Missing value imputation
  o	Data visualization
•	Model Building
•	Evaluation of model
•	Predicting survivals	

Data Exploration
I first began my project by loading all the required packages that I would need to finally be able to create an efficient algorithm to help me predict survivals more accurately.  I will be using ‘data.table’ package to read my dataset fast. I will also be using ‘dplyr’ and ‘sqldf’ packages to manipulate my data. I will be using the very efficient data visualization packages, ‘ggplot2’, ‘ggthemes’, and ‘scales’ to present my findings in an interactive way. I will also be using ‘mice’ and ‘Hmisc’ packages to help me impute missing values efficiently. Finally, I will be using ‘caret’ and ‘randomForest’ packages to help me select the most important variables, create the model, predict the survivals, and evaluate the model.
