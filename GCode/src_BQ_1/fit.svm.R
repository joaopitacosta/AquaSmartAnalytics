# Support Vector Machines with Radial Basis Function Kernel
#
fit.svm.rbf <- function(df, predictors, response.var, trainIndex, preproc)
{
  
  fmla <- as.formula( paste(response.var, paste(predictors, collapse="+"), sep="~") )
  
  # Partition dataset into Train and Test 
  df.train <- df[ trainIndex, names(df) %in% c(predictors, response.var)]
  df.test <- df[ -trainIndex, names(df) %in% c(predictors, response.var)]
 

  fitControl <- trainControl(method = "repeatedcv",
                              ## 10-fold CV...
                              number = 10,
                              ## repeated  times
                              repeats = 20
                           )
  if ( preproc == TRUE ) 
  {                     
      svm.rbf.fit <- train( fmla, data=df.train, method="svmRadial", metric="RMSE",
                            preProc = c("center", "scale"), tuneLength = 10, trControl = fitControl )
  }else
  {
      svm.rbf.fit <- train( fmla, data=df.train, method="svmRadial", metric="RMSE",  
                          tuneLength = 10, trControl = fitControl )
  }
  
  # Calculate the variable importance of the model and mapping to 100 (percentage)
  varImp.svm <- varImp(svm.rbf.fit, scale=FALSE)
  variables.Importance.svm <- varImp.svm$importance * 100/sum(varImp.svm$importance)
   
  #------------------------------ Testing phase
  # Test Cages
  nr = nrow(df.test)
  testPred <- predict( svm.rbf.fit, df.test[ , predictors] )
  RMSE.TS <- sqrt( sum( (testPred - df.test[ , response.var])^2 )/nr )
   
  df.test$SVM.RBF.Preds = testPred 
  df.test$Rel.Err = ( (testPred - df.test[ , response.var])*100/df.test[ , response.var] )
   
   
  # Train Cages
  # 
  nr = nrow(df.train)
  trainPred <- predict( svm.rbf.fit, df.train[ , predictors] )
  RMSE.TR <- sqrt( sum( (trainPred - df.train[ , response.var])^2 )/nr )
  
  df.train$SVM.RBF.Preds.TR = trainPred 
  df.train$Rel.Err.TR = ( (trainPred - df.train[ , response.var])*100/df.train[ , response.var] )
  
  
  results.SVM.RBF <- list("SVM.RBF.Model" = svm.rbf.fit, "RMSE.Test"=RMSE.TS,"RMSE.Train"=RMSE.TR,
                          "Variable.Importance" = variables.Importance.svm,
                          "Dset.Tr" = df.train, "Dset.Ts.Preds" = df.test)
   
  return(results.SVM.RBF)
   
}


#----------------------------------------------------------------------------------------

fit.svm.rbf_period <- function( df.train, df.test, predictors, response.var, preproc )
{
  
  fmla <- as.formula( paste(response.var, paste(predictors, collapse="+"), sep="~") )
  
  # Partition dataset into Train and Test 
  df.train <- df.train[ , names(df.train) %in% c(predictors, response.var)]
  df.test <- df.test[ , names(df.test) %in% c(predictors, response.var)]
  
  # Preprocess Train and Test data
  if ( preproc == TRUE )
  {
    preProcValues.TR <- preProcess(df.train, method = c("center", "scale"))
    scaled.df.train <- predict(preProcValues.TR, df.train)
    
    preProcValues.TS <- preProcess(df.test, method = c("center", "scale"))
    scaled.df.test <- predict(preProcValues.TS, df.test)
    
  
  View(scaled.df.train)
  df.train <- scaled.df.train
  View(scaled.df.test)
  df.test <- scaled.df.test
  }
  
  fitControl <- trainControl(method = "repeatedcv",
                             ## 10-fold CV...
                             number = 10,
                             ## repeated  times
                             repeats = 15
  )
  if ( preproc == TRUE )
  {                     
    svm.rbf.fit <- train( fmla, data=df.train, method="svmRadial", metric="RMSE",  preProc = c("center", "scale"),
                          tuneLength = 10, trControl = fitControl )
  }else
  {
    svm.rbf.fit <- train( fmla, data=df.train, method="svmRadial", metric="RMSE",  
                          tuneLength = 10, trControl = fitControl )
  }
  
  variables.Importance.svm <- varImp(svm.rbf.fit, scale=FALSE)
  
  #------------------------------ Testing phase
  # Test Cages
  nr = nrow(df.test)
  testPred <- predict( svm.rbf.fit, df.test[ , predictors] )
  RMSE.TS <- sqrt( sum( (testPred - df.test[ , response.var])^2 )/nr )
  
  df.test$SVM.RBF.Preds = testPred 
  df.test$Rel.Err = ( (testPred - df.test[ , response.var])*100/df.test[ , response.var] )
  
  
  # Train Cages
  # 
  nr = nrow(df.train)
  trainPred <- predict( svm.rbf.fit, df.train[ , predictors] )
  RMSE.TR <- sqrt( sum( (trainPred - df.train[ , response.var])^2 )/nr )
  
  df.train$SVM.RBF.Preds.TR = trainPred 
  df.train$Rel.Err.TR = ( (trainPred - df.train[ , response.var])*100/df.train[ , response.var] )
  
  
  results.SVM.RBF <- list("SVM.RBF.Model" = svm.rbf.fit, "RMSE.Test"=RMSE.TS,"RMSE.Train"=RMSE.TR,
                          "Variable.Importance" = variables.Importance.svm,
                          "Dset.Tr" = df.train, "Dset.Ts.Preds" = df.test)
  
  return(results.SVM.RBF)
  
}





