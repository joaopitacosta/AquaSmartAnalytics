print.plot.Results <- function(model)
{
  
  #------------------ Variable Importance 
  png("VariableImportance_SVM.RBF_EQ1.png", width = 640, height = 480)

  vimport <- data.frame( "Features" = rownames(model$Variable.Importance),
                         "Importance" = round(model$Variable.Importance$Overall, digits=2) )

  p <- ggplot(vimport, aes(x = reorder(Features, -Importance), y = Importance)) +
            geom_bar(stat = "identity", fill="steelblue") +
            geom_text(aes(label=Importance), hjust=-0.1, color="black", size=3.5) + xlab("Features") +
            ylab("Importance (%)") + theme_minimal()
  p <- p + coord_flip()
  print(p)
  dev.off()


  # Store test dataset with full details plus SVM prediction, Relative Error and Class 
  #
  Class <- ifelse( abs(model$Dset.Ts.Preds$Rel.Err) <= 10, "Expected", "Unexpected" )
   
  Dataset.Test.Pred <- data.frame(cbind(dset[-trainIndex,],
                          model$Dset.Ts.Preds$SVM.RBF.Preds, 
                           model$Dset.Ts.Preds$Rel.Err, Class))
  names(Dataset.Test.Pred) <- c(names(dset), "SVM.RBF.Preds", "Rel.Err", "Class" )
  
  write.csv2(Dataset.Test.Pred, file='Dataset.TEST.Pred_EQ1.csv',row.names=TRUE )
  
   
  #------------------ Barplot Test cases vs Relative Error (ggplot)
  ds <- data.frame(rownames(model$Dset.Ts.Preds), round(model$Dset.Ts.Preds$Rel.Err,digits=2),
                   Dataset.Test.Pred$Class)
  colnames(ds) <- c("ID", "Relative_Error", "Class")
   
  png("barplot_SVM.RBF_TEST_BQ1.png", width = 800, height = 640)
  bp <- ggplot(ds, aes(x=ID, y=Relative_Error, fill=Class)) + 
        geom_bar(stat="identity", position=position_dodge()) +
        scale_fill_brewer(palette="Set1") +
        xlab("ID Test Cases") + ylab("Relative Error") +
        geom_text(aes(label=Relative_Error), hjust=1.0, color="black", size=2.5) +
        theme(axis.text = element_text(size = 6))
  bp <- bp + coord_flip()
  print(bp)
  dev.off()

  #------------------ Bubble plot TEST cases

  png("bubbleplot_SVM.RBF_TEST_BQ1.png", width = 800, height = 640)
  bp <- ggplot(Dataset.Test.Pred, aes(x=Econ.FCR.Period, y=SVM.RBF.Preds, label=Unit), guide=FALSE )
  bp <- bp + geom_point(aes(size=Period.Feed.Qty, color=abs(Feed.Deviation.Perc), fill=abs(Feed.Deviation.Perc)), shape = 21)
  bp <- bp + scale_size_area(max_size = 15) +
    scale_x_continuous(name="Econ FCR Period") +
    scale_y_continuous(name="SVM FCR prediction") +
    geom_text(hjust = 1.5, size = 3) + theme_bw()
  print(bp)
  dev.off()


  #----------------------------------------------------
  # Using training set to estimate FCR by SVM model
  #

  Class.TR <- ifelse( abs(model$Dset.Tr$Rel.Err.TR) <= 10, "Expected", "Unexpected" )

  Dataset.Train.Pred <- data.frame(cbind(dset[trainIndex,],
                                        model$Dset.Tr$SVM.RBF.Preds.TR,
                                        model$Dset.Tr$Rel.Err.TR, Class.TR))
  names(Dataset.Train.Pred) <- c(names(dset), "SVM.RBF.Preds.TR", "Rel.Err.TR", "Class.TR" )

  write.csv2(Dataset.Train.Pred, file='Dataset.TRAIN.Pred_EQ1.csv',row.names=TRUE )


  #------------------ Barplot TRAIN cases vs Relative Error (ggplot)

  ds.TR <- data.frame(rownames(model$Dset.Tr), round(model$Dset.Tr$Rel.Err.TR, digits=2),
                   Dataset.Train.Pred$Class.TR, Dataset.Train.Pred$From.Month)
  colnames(ds.TR) <- c("ID", "Relative_Error.TR", "Class.TR", "From.Month")

  ds.TR.Spring <- ds.TR %>% filter( From.Month %in% c("March","April","May") )
  png("barplot_SVM.RBF_TRAIN.Spring.png", width = 800, height = 640)
  bp <- ggplot(ds.TR.Spring, aes(x=ID, y=Relative_Error.TR, fill=Class.TR)) +
    geom_bar(stat="identity", position=position_dodge()) +
    scale_fill_brewer(palette="Set1") +
    xlab("ID TRAIN Cases") + ylab("Relative Error TRAIN") + ggtitle("March To May") +
    geom_text(aes(label=Relative_Error.TR), hjust=1.0, color="black", size=2.5) +
    theme(axis.text = element_text(size = 6))
  bp <- bp + coord_flip()
  print(bp)
  dev.off()

  ds.TR.Summer <- ds.TR %>% filter( From.Month %in% c("June","July","August") )
  png("barplot_SVM.RBF_TRAIN.Summer.png", width = 800, height = 640)
  bp <- ggplot(ds.TR.Summer, aes(x=ID, y=Relative_Error.TR, fill=Class.TR)) +
    geom_bar(stat="identity", position=position_dodge()) +
    scale_fill_brewer(palette="Set1") +
    xlab("ID TRAIN Cases") + ylab("Relative Error TRAIN") + ggtitle("June To July") +
    geom_text(aes(label=Relative_Error.TR), hjust=1.0, color="black", size=2.5) +
    theme(axis.text = element_text(size = 6))
  bp <- bp + coord_flip()
  print(bp)
  dev.off()

  ds.TR.Autumn <- ds.TR %>% filter( From.Month %in% c("September","October","November" ) )
  png("barplot_SVM.RBF_TRAIN.Autumn.png", width = 800, height = 640)
  bp <- ggplot(ds.TR.Autumn, aes(x=ID, y=Relative_Error.TR, fill=Class.TR)) +
    geom_bar(stat="identity", position=position_dodge()) +
    scale_fill_brewer(palette="Set1") +
    xlab("ID TRAIN Cases") + ylab("Relative Error TRAIN") + ggtitle("September To November") +
    geom_text(aes(label=Relative_Error.TR), hjust=1.0, color="black", size=2.5) +
    theme(axis.text = element_text(size = 6))
  bp <- bp + coord_flip()
  print(bp)
  dev.off()

  ds.TR.Winter <- ds.TR %>% filter( From.Month %in% c("December","January","February" ) )
  png("barplot_SVM.RBF_TRAIN.Winter.png", width = 800, height = 640)
  bp <- ggplot(ds.TR.Winter, aes(x=ID, y=Relative_Error.TR, fill=Class.TR)) +
    geom_bar(stat="identity", position=position_dodge()) +
    scale_fill_brewer(palette="Set1") +
    xlab("ID TRAIN Cases") + ylab("Relative Error TRAIN") + ggtitle("December To February") +
    geom_text(aes(label=Relative_Error.TR), hjust=1.0, color="black", size=2.5) +
    theme(axis.text = element_text(size = 6))
  bp <- bp + coord_flip()
  print(bp)
  dev.off()

} 