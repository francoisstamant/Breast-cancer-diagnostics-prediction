# Breast-cancer-diagnostics-prediction
Prediction of breast cancers diagnostics in Wisconsin.
I compare the prediction performance of three methods: Random Forests, SVM and Logistic Regression.
The data.csv file contains the data, while the cancer.R file contains the code used to create models and make predictions. Code was written in R. 

The data, originally found here https://www.kaggle.com/uciml/breast-cancer-wisconsin-data, contains 569 observations and 32 independent variables. The dependent variable, diagnosis, is binary: malign cancer=1 or benign cancer=0. 

The combination of Logistic Regression with PCA (Principal component analysis) performs best, obtaining 98.4% on the validation set. 
