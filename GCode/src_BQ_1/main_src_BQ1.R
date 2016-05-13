# Analysis of Business Question 1 -- Evaluation of fish management
#
# Created 29/03/2016
#
# Author: Gerasimos Antzoulatos - i2s
#
source('helpers.R')
source('fit.svm.R')
source("print.plot.Results.R")

#------------------------------------------------------------------------
# Load Datasets
# 
# Dataset from Andromeda 
#pathname = paste(getwd(), "Data_Andro_SpAut.xlsx", sep="/")
#Dataset.Andro <- read_excel(pathname, sheet = 1, col_names = TRUE, na='na') 

# Dataset from Ardag
pathname = paste(getwd(), "Data_Ardag_Bream_Mar_Oct.xlsx", sep="/")
Dataset.Ardag <- read_excel(pathname, sheet = 1, col_names = TRUE, na='na')

#------------------------------------------------------------------------
# Preprocess Datasets
# 
#dset <- transform.dataset.andro(Dataset.Andro) 
#dset <- preprocess(dset)

dset <- transform.dataset.ardag(Dataset.Ardag)
dset <- preprocess(dset)

#------------------------------------------------------------------------
# Subsetting a dataset, choose features for analysis
# 
df <- data.frame("Unit" = dset$Unit, "Batch" = dset$Batch,
                "Econ.FCR.Period" = dset$Econ.FCR.Period,
                 "SFR.Period"=dset$SFR.Period.Perc,
                 "SGR.Period"=dset$SGR.Period.Perc,
                 "Avg.Temp" = dset$Avg.Temp,
                 "Start.Av.Weight"=dset$Start.Av.Weight,
                 "End.Av.Weight" = dset$End.Av.Weight,
                 "Period.Feed.Qty" = dset$Period.Feed.Qty,
                 "Feed.Deviation.Perc" = dset$Feed.Deviation.Perc,
                 "Diff.Days" = dset$Diff.Days,
                 "End.Fish.Density"=dset$End.Fish.Density,
                 "Start.Fish.Density"=dset$Start.Fish.Density,
                 "Mortality"=dset$Mortality.No,
                 "Fastings.No" = dset$Fastings.No,
                 "Origin.Month" = dset$Origin.Month,
                 "Origin.Year" = dset$Origin.Year,
                 "From.Month" = dset$From.Month,
                 "From.Year" = dset$From.Year,
                 "To.Month" = dset$To.Month,
                 "To.Year" = dset$To.Year)

#---------------------------------------------------------------------------------
# 
# Choose predictors (independent) variables and response (dependent) variable
#
#---> for Andromeda
#predictors <- c("Start.Av.Weight","Start.Fish.Density", "SFR.Period", "Avg.Temp", "From.Month", "From.Year", "Diff.Days") 
#response.var <- "Econ.FCR.Period"

#---> for Ardag
predictors <- c("Start.Av.Weight","SFR.Period", "Avg.Temp", "From.Month", "From.Year", "Diff.Days") 
response.var <- "Econ.FCR.Period"

#---------------------------------------------------------------------------------
# Partition dataset to train and test
#
perc = 0.80
trainIndex <- createDataPartition(df$Unit, p = perc, list = FALSE, times = 1)
# 
# # --------------------------------------------------------------- SVMs
# # Support Vector Machines with Radial Basis Function Kernel
# 
preproc = TRUE  # preProcessing is on
res.svm.rbf <- fit.svm.rbf( df, predictors, response.var, trainIndex, preproc )


print.plot.Results(res.svm.rbf) 


#---------------------------------------
save(res.svm.rbf, file = "BQ1_results")
