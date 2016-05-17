# Prepare data to upload in Stream Story
# by Joao Pita Costa 2016

# AquaStreamData <- read.csv("~/Documents/CODE/AquaSmartAnalytics/AquaStreamStory/AquaStreamData.csv", sep=";")
# View(AquaStreamData)
# format miliseconds column to numerical

Data<-AquaStreamData

L<-1
N<-0
batch<-AquaStreamData[L,5]
while (L<nrow(AquaStreamData)+1) {
  if (AquaStreamData[L,5]==batch) {
    L<-L+1
    AquaStreamData[L,1]<-AquaStreamData[L,1]+N
  } else { 
    batch<-AquaStreamData[L,5]
    N<-N+10000000000000
  }
}
AquaStreamData<-AquaStreamData[1:nrow(AquaStreamData)-1,]
write.csv(AquaStreamData, file = "AquaStreamData_upload.csv")  

