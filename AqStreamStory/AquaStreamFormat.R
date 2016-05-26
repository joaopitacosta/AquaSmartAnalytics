# Prepare data to upload in Stream Story
# by Joao Pita Costa 2016


rm(AquaStreamData)
AquaStreamData <- ss_andrBassSamplingClean

AquaStreamData$Mortality.perc <- AquaStreamData$Mortality.No/AquaStreamData$Opening.Fish.No
AquaStreamData$Transfer.perc <- AquaStreamData$Transfer....No./AquaStreamData$Opening.Fish.No
AquaStreamData$Fasting.perc <- AquaStreamData$Fastings.No/AquaStreamData$Opening.Fish.No
AquaStreamData$Harvest.perc <- AquaStreamData$Harvest..No./AquaStreamData$Opening.Fish.No

AquaStreamData$From <- NULL
AquaStreamData$To <- NULL
AquaStreamData$LTD.Mortality.No <- NULL
AquaStreamData$LTD.Mortality.. <- NULL
AquaStreamData$LTD.Econ..FCR <- NULL
AquaStreamData$Transfer....Kg. <- NULL
AquaStreamData$Transfer....Kg..1 <- NULL
AquaStreamData$Transfer....No. <- NULL
AquaStreamData$Transfer....No..1 <- NULL
AquaStreamData$Sampling..No. <- NULL
AquaStreamData$Harvest..No. <- NULL
AquaStreamData$Mortality.No <- NULL
AquaStreamData$Mortality.Deviation.... <- NULL
AquaStreamData$Model.Mortality.No <- NULL

# View(AquaStreamData)

write.csv(AquaStreamData, file = "formated/ss_andrBassSamplingClean.csv")