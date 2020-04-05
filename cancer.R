setwd("C:/Users/st-am/OneDrive/Documents/Data analytics/Breast cancer")
library(ggplot2)
library(corrplot)
library(randomForest)
library (e1071)
library(Amelia)
library(devtools)
library(ggbiplot)

#Import data
df = read.csv("data.csv")
df$diagnosis =  ifelse(df$diagnosis=="M", gsub("M", 1, df$diagnosis), gsub("B", 0, df$diagnosis))

#Look at missing data and Remove useless columns
missmap(df, col = c("blue", "red"), legend = FALSE)

df = df[,c(-33,-1)]
sum(is.na(df))

#Plots
ggplot(df,aes(x=diagnosis))+geom_bar(stat="count",fill ="steelblue",width =0.6)+scale_x_discrete(labels=c("Benign","Malign"))+ 
  labs(title = "Proportion of diagnosis") + theme_gray(base_size = 19) +
  theme(axis.text=element_text(size=12),axis.title=element_text(size=12,face="bold"))

for (i in 1:31){
  plot(df[,i], ylab = names(df[i]), main = names(df[i]))
}

sum(df$diagnosis)

#Correlation 
df$diagnosis = as.numeric(df$diagnosis)
C = cor(df)
corrplot(C, method = "circle")


#Y as factor
df$diagnosis = as.factor(df$diagnosis)


###############################
# TUNING 
###############################

#FORESTS --------------------------
rf=randomForest(diagnosis~.,data=mydata.train,ntree=250, mtry = 8)
rf

predrf=predict(rf,newdata=mydata.valid)
forest_accuracy = mean(predrf==mydata.valid$diagnosis)

#variable importance
vimp = importance(rf)
varImpPlot(rf)


#How many trees are needed
n.arbre=seq(1,2000,by=50)
erreur=NULL
for (i in n.arbre)
{
  rf=randomForest(diagnosis~.,data=mydata.valid,ntree=i)
  erreur=c(erreur,sum(rf$err.rate[,1])/rf$ntree)
}
erreur
plot(n.arbre, erreur,type="l")


tuneRF(mydata.train, y=mydata.train$diagnosis, ntreeTry = 250, plot = TRUE, mtryStart = 1,
       stepFactor = 2, doBest = FALSE, improve = 0.0001)

# SVM ------------------------------
#Find the best parameters
mytune=tune(svm ,diagnosis~., data=mydata.train ,kernel ="polynomial",
            ranges =list(cost=c(0.1, 0.5, 1, 2,5)))
summary(mytune$best.model)



# LOGISTIC REGRESSION -----------------
#High correlation for some variables causes problems in converging. We use PCA
df.pca = prcomp(df[,2:31], center = TRUE, scale. =TRUE)
summary(df.pca)
pcadata = as.data.frame(df.pca$x[,1:9])
pcadata$diagnosis = df$diagnosis

ggibplot(pcadata)

pcatrain = pcadata[1:300,]
pcatest = pcadata[301:569,]

logistic = glm(pcatrain$diagnosis~., data = pcatrain, family = binomial)
summary(logistic)

pred = round(predict(logistic, type = "response", newdata=pcatest))
logistic_accuracy = mean(pred==pcatest$diagnosis)




##########################
# RESULT SECTION
##########################
result_matrix = matrix(nrow = 50, ncol = 3)

for (i in 1:50){
  
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
  rf
  
  predrf=predict(rf,newdata=mydata.valid)
  accuracy_forest = mean(predrf==mydata.valid$diagnosis)
  
  result_matrix[i,1] =accuracy_forest
  
  ######## SUPPORT VECTOR MACHINE #########
  mysvm = svm(diagnosis~., data = mydata.train, kernel="polynomial", cost=5, degree=3)
  pred_svm_optimal = predict(mysvm, mydata.valid)
  accuracy_svm = mean(pred_svm_optimal==mydata.valid$diagnosis)
  
  result_matrix[i,2] = accuracy_svm
  
  ######## LOGISTIC REGRESSION #########
  n=nrow(pcadata)
  size.train=floor(n*0.50)
  size.valid=floor(n*0.50)
  
  id.train=sample(1:n,size.train,replace=FALSE)
  id.valid=sample(setdiff(1:n,id.train),size.valid,replace=FALSE)
  
  mydata.train=pcadata[id.train,]
  mydata.valid=pcadata[id.valid,]
  
  logistic = glm(mydata.train$diagnosis~., data = mydata.train, family = binomial)
  pred = round(predict(logistic, type = "response", newdata=mydata.valid))
  accuracy_logistic = mean(pred==mydata.valid$diagnosis)
  
  result_matrix[i,3] = accuracy_logistic
  
}

accuracy_forest = mean(result_matrix[,1])
accuracy_svm = mean(result_matrix[,2])
accuracy_logistic = mean(result_matrix[,3])



#Logistic regression wins













