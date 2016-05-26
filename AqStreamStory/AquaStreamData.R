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
Y<-AquaStreamData[L,11]
batch<-AquaStreamData[L,5]
while (L<nrow(AquaStreamData)) {
  if (AquaStreamData[L,5]==batch) {
    AquaStreamData[L,1]<-AquaStreamData[L,1]+N
    AquaStreamData[L,11]<-Y
    L<-L+1
  } else { 
    batch<-AquaStreamData[L,5]
    N<-N+10000000000000
    Y<-Y+1
    AquaStreamData[L,1]<-AquaStreamData[L,1]+N
    AquaStreamData[L,11]<-Y
    L<-L+1
  }
}
#AquaStreamData <- AquaStreamData[order(AquaStreamData$Middle),]
#View(AquaStreamData)

write.csv(AquaStreamData, file = "output/ss_cmpaBreamSamplingClean.csv")  

