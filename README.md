# Breast-cancer-diagnostics-prediction

Cancer.R file: 
Prediction of breast cancers diagnostics in Wisconsin.
I compare the prediction performance of three methods: Random Forests, SVM and Logistic Regression.
I present a way to get the truly best model by looking at accuracy distribution and IQR.

Data.csv file:
Contains the data, originally found here https://www.kaggle.com/uciml/breast-cancer-wisconsin-data. It contains 569 observations and 32 independent variables. The dependent variable, diagnosis, is binary: malign cancer=1 or benign cancer=0. 

Logistic Regression performs best, both in average accuracy and in the distribution of the accuracy. 
