library(ggplot2)
library(randomForest)
library (e1071)
library(devtools)
library(ggbiplot)

#Import data
df = read.csv("data.csv")

#Y as factor
df$diagnosis =  ifelse(df$diagnosis=="M", gsub("M", 1, df$diagnosis), gsub("B", 0, df$diagnosis))
df$diagnosis = as.factor(df$diagnosis)

#Remove useless columns
df = df[,c(-33,-1)]

#Distribution of dependent variable
ggplot(df,aes(x=diagnosis))+geom_bar(stat="count",fill ="steelblue",width =0.6)+scale_x_discrete(labels=c("Benign","Malign"))+ 
  labs(title = "Proportion of diagnosis") + theme_gray(base_size = 19) +
  theme(axis.text=element_text(size=12),axis.title=element_text(size=12,face="bold"))

####################################
# LOOP to get accuracy distribution
####################################

result_matrix = matrix(nrow = 200, ncol = 3)
for (i in 1:200){
  
  set.seed(i)
  
  n=nrow(df)
  size.train=floor(n*0.50)
  size.valid=floor(n*0.50)
  id.train=sample(1:n,size.train,replace=FALSE)
  id.valid=sample(setdiff(1:n,id.train),size.valid,replace=FALSE)
  mydata.train=df[id.train,]
  mydata.valid=df[id.valid,]
  
  ######## RANDOM FOREST #########
  rf=randomForest(diagnosis~.,data=mydata.train,ntree=250, mtry = 8)
  predrf=predict(rf,newdata=mydata.valid)
  accuracy_forest = mean(predrf==mydata.valid$diagnosis)
  result_matrix[i,1] =accuracy_forest
  
  ######## SUPPORT VECTOR MACHINE #########
  mysvm = svm(diagnosis~., data = mydata.train, kernel="polynomial", cost=5, degree=3)
  pred_svm_optimal = predict(mysvm, mydata.valid)
  accuracy_svm = mean(pred_svm_optimal==mydata.valid$diagnosis)
  result_matrix[i,2] = accuracy_svm
  
  ######## LOGISTIC REGRESSION #########
  logistic = glm(mydata.train$diagnosis~., data = mydata.train, family = binomial)
  pred = round(predict(logistic, type = "response", newdata=mydata.valid))
  accuracy_logistic = mean(pred==mydata.valid$diagnosis)
  result_matrix[i,3] = accuracy_logistic
  
}

accuracy_forest = mean(result_matrix[,1])
accuracy_svm = mean(result_matrix[,2])
accuracy_logistic = mean(result_matrix[,3])

#####################
# DATA VISUALIZATION
#####################

#Accuracy distributions for all models
a=density(result_matrix[,1])

#Getting the plot
plot(a, xlim=c(0.92, 1), ylim=c(0, 60), col='blue', lwd=2, main='Accuracy distribution of all models',
     xlab='Accuracy')
lines(density(result_matrix[,2]), col='red', lwd=2)
lines(density(result_matrix[,3]), col='green', lwd=2)
legend(x=0.975, y=59,legend = c("Random Forest", "SVM", "Logistic Regression"), col = c("blue","red", 'green'), lty = c(1,1))

#Boxplots
boxplot(result_matrix, use.cols = TRUE, 
       main='Boxplot by algorithm', 
       ylab='Accuracy', xaxt = "n", col=c('blue', 'red', 'green'))
axis(1, at=1:3, labels=c('Random Forests', 'SVM', 'Logistic Regression'))

#IQR
IQR(result_matrix[,1])
IQR(result_matrix[,2])
IQR(result_matrix[,3])













