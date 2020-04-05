# Breast-cancer-diagnostics-prediction
Prediction of breast cancers diagnostics in Wisconsin

I used the following dataset https://www.kaggle.com/uciml/breast-cancer-wisconsin-data. It contains 569 observations and 32 independent variables. 
The dependent variable, diagnosis, is binary: malign cancer=1 or benign cancer=0. 

I compare the prediction performance of three methods: Random Forests, SVM and Logistic Regression. 

The combination of Logistic Regression with PCA (Principal component analysis) performs best, obtaining 98.4% on the validation set. 
