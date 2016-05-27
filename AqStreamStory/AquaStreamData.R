# Order data to upload in Stream Story
# by Joao Pita Costa 2016

# AquaStreamData <- read.csv("~/Documents/CODE/AquaSmartAnalytics/AquaStreamStory/input/AquaStreamData.csv", sep=";")
# View(AquaStreamData)
# format miliseconds column to numerical
# rm(AquaStreamData,Data)
# AquaStreamData <- ss_cmpaBreamSamplingClean
# Data<-AquaStreamData
rm(AquaStreamData)
AquaStreamData <- ss_cmpaBreamSamplingClean
AquaStreamData <- AquaStreamData[order(AquaStreamData$Batch),]
# View(AquaStreamData)
L<-1
N<-0
T<-1000*60*60*24*356.25
# Y<-AquaStreamData[L,11]
batch<-AquaStreamData[L,5]
while (L<nrow(AquaStreamData)+1) {
  if (AquaStreamData[L,5]==batch) {
    AquaStreamData[L,1]<-AquaStreamData[L,1]+N
    #AquaStreamData[L,11]<-Y
    L<-L+1
  } else { 
    batch<-AquaStreamData[L,5]
    N<-N+T
    #Y<-Y+1
    AquaStreamData[L,1]<-AquaStreamData[L,1]+N
    #AquaStreamData[L,11]<-Y
    L<-L+1
  }
}
#AquaStreamData <- AquaStreamData[order(AquaStreamData$Middle),]
#View(AquaStreamData)

AquaStreamData$Mortality.perc <- AquaStreamData$Mortality.No/AquaStreamData$Opening.Fish.No
AquaStreamData$Transfer.perc <- AquaStreamData$Transfer....No./AquaStreamData$Opening.Fish.No
AquaStreamData$Fasting.perc <- AquaStreamData$Fastings.No/AquaStreamData$Opening.Fish.No
AquaStreamData$Harvest.perc <- AquaStreamData$Harvest..No./AquaStreamData$Opening.Fish.No

write.csv(AquaStreamData, file = "output/ss_cmpaBreamSamplingClean.csv")  

