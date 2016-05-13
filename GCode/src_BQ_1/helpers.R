# Fucntion helpers.R
#     --> Contains helper functions
# ---------------------------------------------------------
#
# load libraries
library("readxl") 
library("lubridate")
library("ggplot2")
library("plyr")
library("dplyr")
library("RColorBrewer")
library("car")
library("caret")
library("glmnet")
library("gam")
library("mgcv")


# --------------------------------------------------------
# Transform dataset
# --------------------------------------------------------
transform.dataset.andro <- function(dataset){

  data <- data.frame("Region" = dataset$Region,
                     "Site" = dataset$Site,
                     "Unit" = dataset$Unit,
                     "Batch" = dataset$Batch,
                     "Species" = dataset$Species,
                     "Start.Fish.Density" = dataset$"Start Fish Density",
                     "End.Fish.Density"= dataset$"End Fish Density",
                     "Hatchery"  = dataset$Hatchery,
                     "Lot.Quality"= dataset$"Lot Quality", 
                     "Origin.Year"= dataset$"Origin Year",
                     "Origin.Month"= dataset$"Origin Month",
                     "From"= ymd(as.Date(dataset$From, origin="1899-12-30")),
                     "From.Month" = month(dataset$From,label = TRUE, abbr = FALSE),
                     "From.Year" = year(dataset$From),
                     "To"= ymd(as.Date(dataset$To, origin="1899-12-30")),
                     "To.Month" = month(dataset$To,label = TRUE, abbr = FALSE),
                     "To.Year" = year(dataset$To),
                     "Diff.Days" = interval(as.Date(dataset$From, origin="1899-12-30"), as.Date(dataset$To, origin="1899-12-30") )%/%days(1),
                     "Start.Av.Weight"= dataset$"Start Av. Wt.",
                     "End.Av.Weight"= dataset$"End Av.Wt.",
                     "Model.End.Av.Wt.Act.Feed" = dataset$"Model End Av. Wt. Act. Feed",
                     "Av.Wt.Deviation.Perc" = dataset$"Av. Wt. Deviation (%)",
                     "Av.Wt.Before.Sampl" = dataset$"Av. Wt. Before Sampl.",
                     "Model.End.Av.Wt.Sugg.Feed" = dataset$"Model End Av. Wt. Sugg. Feed",
                     "Actual.Feed" = dataset$"Actual Feed", 
                     "Feed.Category" = dataset$"Feed Category",
                     "Supplier" = dataset$Supplier,
                     "Proteins.Av" = dataset$Proteins_Avg,
                     "Lipids.Av" = dataset$Lipids_Avg,
                     "Vitamin.Mineral.Premix" = dataset$Vitamin_Mineral_Premix,
                     "Digestible.Energy" = dataset$Digestible_Energy,
                     "Period.Feed.Qty" = dataset$"Period Feed Qty",
                     "Model.Feed.Qty" = round(as.numeric(dataset$"Model Feed Qty"),digits=2),
                     "Feed.Deviation.Perc" = dataset$"Feed Deviation (%)",
                     "Opening.Fish.No"  = dataset$"Opening Fish No",
                     "Opening.Biomass" = round(as.numeric(dataset$"Opening Biomass"),digits=2),
                     "Closing.Fish.No"  = dataset$"Closing Fish No",
                     "Closing.Biomass" = round(as.numeric(dataset$ "Closing Biomass"),digits=2),
                     "Harvest.Biomass" = round(as.numeric(dataset$"Harvest Biomass"),digits=2),              
                     "Transfer.Minus.Kg"  = dataset$"Transfer - (Kg)",
                     "Transfer.Plus.Kg" = dataset$"Transfer + (Kg)",
                     "Biomass.Produced" = round(as.numeric(dataset$"Biomass Produced"),digits=2),
                     "Biomass.Produced.Before.Sampl." = round(as.numeric(dataset$"Biomass Produced Before Sampl."),digits=2),
                     "Econ.FCR.Period" = round(as.numeric(dataset$"Econ. FCR Period"),digits=2),
                     "Econ.FCR.Period.Before.Sampl" = round(as.numeric(dataset$"Econ FCR Period Before Sampl."),digits=2),
                     "Mortality.No" = dataset$"Mortality No",
                     "Model.Mortality.No" = dataset$"Model Mortality No",
                     "Mortality.Deviation.Perc" = dataset$"Mortality Deviation (%)",
                     "SFR.Period.Perc"= dataset$"SFR Period (%)",
                     "SFR.Period.Perc.Before.Sampl" = dataset$"SFR Period (%) Before Sampl.",
                     "SGR.Period.Perc" = dataset$"SGR Period (%)",
                     "Max.Feed.Qty"= dataset$"Max Feed Qty",  
                     "Food.Price" = dataset$"Food Price",
                     "Current.Grading" = dataset$"Current Grading",
                     "Feeding.Policy"= dataset$"Feeding Policy",
                     "Group.Tag" = dataset$"Group Tag",
                     "Vaccinated"= dataset$Vaccinated,
                     "Feeder" = dataset$Feeder, 
                     "Feeding.Rate" = dataset$"Feeding Rate (Kg / Hour)", 
                     "Fastings.No" = dataset$"Fastings No",                  
                     "Avg.Temp"= dataset$"Avg. Temp.",
                     "Avg.Oxygene" = dataset$"Avg. Oxygene",
                     "Transfer.Minus.No" = dataset$"Transfer - (No)", 
                     "Transfer.Plus.No" = dataset$ "Transfer + (No)",
                     "Harvest.No" = dataset$"Harvest (No)",
                     "Sampling.No" = dataset$"Sampling (No)",
                     "LTD.Mortality.No"= dataset$"LTD Mortality No",
                     "LTD.Mortality.Perc"  = round(as.numeric(dataset$"LTD Mortality %"),digits=2),
                     "LTD.Econ.FCR" = round(as.numeric(dataset$"LTD Econ. FCR"),digits=2),
                     "Period.Day.Degrees" = dataset$"Period Day Degrees",
                     "Start.Av.Weight.Category" = dataset$"Start Av. Weight Category",
                     "End.Av.Weight.Category" = dataset$"End Av. Weight Category",
                     "Product.Type"  = dataset$"PRODUCT TYPE",
                     "Grouping.Prod.BGT" = dataset$"GROUPING PROD. BGT"
  )
  
  return(data)

}
# --------------------------------------------------------
transform.dataset.ardag <- function(dataset){
  
  data <- data.frame("Region" = dataset$Region,
                     "Site" = dataset$Site,
                     "Unit" = dataset$Unit,
                     "Batch" = dataset$Batch,
                     "Species" = dataset$Species,
                     "Start.Fish.Density" = dataset$"Start Fish Density",
                     "End.Fish.Density"= dataset$"End Fish Density",
                     "Hatchery"  = dataset$Hatchery,
                     "Lot.Quality"= dataset$"Lot Quality", 
                     "Origin.Year"= dataset$"Origin Year",
                     "Origin.Month"= dataset$"Origin Month",
                     "From"= ymd(as.Date(dataset$From, origin="1899-12-30")),
                     "From.Month" = month(dataset$From,label = TRUE, abbr = FALSE),
                     "From.Year" = year(dataset$From),
                     "To"= ymd(as.Date(dataset$To, origin="1899-12-30")),
                     "To.Month" = month(dataset$To,label = TRUE, abbr = FALSE),
                     "To.Year" = year(dataset$To),
                     "Diff.Days" = interval(as.Date(dataset$From, origin="1899-12-30"), as.Date(dataset$To, origin="1899-12-30") )%/%days(1),
                     "Start.Av.Weight"= dataset$"Start Av. Wt.",
                     "End.Av.Weight"= dataset$"End Av.Wt.",
                     "Model.End.Av.Wt.Act.Feed" = dataset$"Model End Av. Wt. Act. Feed",
                     "Av.Wt.Deviation.Perc" = dataset$"Av. Wt. Deviation (%)",
                     "Av.Wt.Before.Sampl" = dataset$"Av. Wt. Before Sampl.",
                     "Model.End.Av.Wt.Sugg.Feed" = dataset$"Model End Av. Wt. Sugg. Feed",
                     "Actual.Feed" = dataset$"Actual Feed", 
                     "Feed.Category" = dataset$"Feed Category",
                     "Supplier" = dataset$Supplier,
                     "Period.Feed.Qty" = dataset$"Period Feed Qty",
                     "Model.Feed.Qty" = round(as.numeric(dataset$"Model Feed Qty"),digits=2),
                     "Feed.Deviation.Perc" = dataset$"Feed Deviation (%)",
                     "Opening.Fish.No"  = dataset$"Opening Fish No",
                     "Opening.Biomass" = round(as.numeric(dataset$"Opening Biomass"),digits=2),
                     "Closing.Fish.No"  = dataset$"Closing Fish No",
                     "Closing.Biomass" = round(as.numeric(dataset$ "Closing Biomass"),digits=2),
                     "Harvest.Biomass" = round(as.numeric(dataset$"Harvest Biomass"),digits=2),              
                     "Transfer.Minus.Kg"  = dataset$"Transfer - (Kg)",
                     "Transfer.Plus.Kg" = dataset$"Transfer + (Kg)",
                     "Biomass.Produced" = round(as.numeric(dataset$"Biomass Produced"),digits=2),
                     "Biomass.Produced.Before.Sampl." = round(as.numeric(dataset$"Biomass Produced Before Sampl."),digits=2),
                     "Econ.FCR.Period" = round(as.numeric(dataset$"Econ. FCR Period"),digits=2),
                     "Econ.FCR.Period.Before.Sampl" = round(as.numeric(dataset$"Econ FCR Period Before Sampl."),digits=2),
                     "Mortality.No" = dataset$"Mortality No",
                     "Model.Mortality.No" = dataset$"Model Mortality No",
                     "Mortality.Deviation.Perc" = dataset$"Mortality Deviation (%)",
                     "SFR.Period.Perc"= dataset$"SFR Period (%)",
                     "SFR.Period.Perc.Before.Sampl" = dataset$"SFR Period (%) Before Sampl.",
                     "SGR.Period.Perc" = dataset$"SGR Period (%)",
                     "Max.Feed.Qty"= dataset$"Max Feed Qty",  
                     "Food.Price" = dataset$"Food Price",
                     "Current.Grading" = dataset$"Current Grading",
                     "Feeding.Policy"= dataset$"Feeding Policy",
                     "Group.Tag" = dataset$"Group Tag",
                     "Vaccinated"= dataset$Vaccinated,
                     "Feeder" = dataset$Feeder, 
                     "Feeding.Rate" = dataset$"Feeding Rate (Kg / Hour)", 
                     "Fastings.No" = dataset$"Fastings No",                  
                     "Avg.Temp"= dataset$"Avg. Temp.",
                     "Avg.Oxygene" = dataset$"Avg. Oxygene",
                     "Transfer.Minus.No" = dataset$"Transfer - (No)", 
                     "Transfer.Plus.No" = dataset$ "Transfer + (No)",
                     "Harvest.No" = dataset$"Harvest (No)",
                     "Sampling.No" = dataset$"Sampling (No)",
                     "LTD.Mortality.No"= dataset$"LTD Mortality No",
                     "LTD.Mortality.Perc"  = round(as.numeric(dataset$"LTD Mortality %"),digits=2),
                     "LTD.Econ.FCR" = round(as.numeric(dataset$"LTD Econ. FCR"),digits=2),
                     "Period.Day.Degrees" = dataset$"Period Day Degrees",
                     "Start.Av.Weight.Category" = dataset$"Start Av. Weight Category",
                     "End.Av.Weight.Category" = dataset$"End Av. Weight Category"
                     # "Product.Type"  = dataset$"PRODUCT TYPE",
                     # "Grouping.Prod.BGT" = dataset$"GROUPING PROD. BGT"
  )
  
  return(data)
  
}

# --------------------------------------------------------------------------------------------------------------

# --------------------------------------------------------
# Preprocess dataset
# --------------------------------------------------------
preprocess <- function(dataset)
{
  
  # Handle missing values or zero values into AvgTemp feature
  ds <- data.frame( dataset$Site, dataset$From.Month, dataset$Avg.Temp )
  names(ds) <- c("Site", "From.Month", "Avg.Temp")
  
  if ( length(which(is.na(ds$Avg.Temp)) != 0) || length(which(ds$Avg.Temp == 0)) != 0 )
  {  
      ds.nozero <- ds[ ds$Avg.Temp != 0 ,]
      if ( nrow(ds.nozero) != 0 )
      {
        grouped_AvgTemp <- ddply(ds.nozero, c("Site", "From.Month"), summarise, grp.avg.Temp=mean(Avg.Temp))
    
        nr = nrow(dataset)
        for ( i in 1:nr )
        {
          if (dataset[i,"Avg.Temp"] == 0){
            dataset[i,"Avg.Temp"] <- grouped_AvgTemp[which(dataset[i,"Site"] == grouped_AvgTemp$Site &
                                                             dataset[i,"From.Month"] == grouped_AvgTemp$From.Month),
                                                     "grp.avg.Temp"]
          }
        }
      }
  }
  
  # Remove records with Diff.Days <= 10
  dataset <- dataset[ dataset$Diff.Days>10,]
  
  # Remove records with Econ.FCR.Period < 0.5 & Econ.FCR.Period > 5
  dataset <- dataset %>% filter( Econ.FCR.Period >= 0.5 & Econ.FCR.Period <= 5 )
  
  return(dataset)
  
}


  