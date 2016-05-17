


Data <- read.csv("~/Documents/CODE/AquaSmartAnalytics/R-AquaSmartAnalytics/Dataset/Data_Andro_SpAut.csv", sep=";", na.strings="0")
View(Data)
Data[is.na(Data)]<-0
aqmat<- Data[,c(6:7,14:19,23:48,55:65,69)]
aquacor <- cor(aqmat)
View(aqmat)
aquacor[is.na(aquacor)]<-0
heatmap(aquacor)
aquacorpe <- cor(aqmat, method = "spearman")
aquacorpe[is.na(aquacorpe)]<-0
heatmap(aquacorpe)
aquacov <- cov(aqmat)
aquacov[is.na(aquacov)]<-0
heatmap(aquacov)

png(file="aquacor.png")
heatmap(aquacor)
dev.off()
write.table(aquacor, file="aquacor.txt", row.names=FALSE, col.names=FALSE)

png(file="aquacor2.png",width=800,height=650)
heatmap.2(aquacor)
dev.off()

png(file="aquacorpe.png")
heatmap(aquacorpe)
dev.off()
write.table(aquacorpe, file="aquacorpe.txt", row.names=FALSE, col.names=FALSE)

png(file="aquacorpe2.png",width=800,height=650)
heatmap.2(aquacorpe)
dev.off()

png(file="aquacov.png")
heatmap(aquacov)
dev.off()
write.table(aquacor, file="aquacov.txt", row.names=FALSE, col.names=FALSE)

png(file="aquacov2.png",width=800,height=650)
heatmap.2(aquacov)
dev.off()


# Find Max correlated values

aquacor[aquacor == 1] <- 0
aquacor=aquacor[apply(aquacor[,-1], 1, function(x) !all(x==0)),]
image(aquacor)
heatmap(aquacor)
aqmax <- max.col(aquacor)

N<-5
aquainf<-matrix(0,ncol(aquacor),N)
# aquainf[,1]<-1:44
aquainf[,1]<-colnames(aquacor)
aquainf[,2]<-max.col(aquacor)
# M <-ncol(aquacor)
# aquainf[,2]<-aquacor[M,aqmax[M]]
# aquainf[,2]<-rownames(aquacor)[M]
# aquainf[,2]<- rownames(aquacor)[aqmax[1:46]]

N <- 5
M <-ncol(aquacor)
C<-1:M
#ndx <- order(aquacor[,C], decreasing = T)[1:N]
top<-matrix(0,M,N)
while (C<M+1) {
  top[C,]<-order(aquacor[,C], decreasing = T)[1:N]
  C<-C+1
  }
aquainf<-top
aquainf[,]<-rownames(aquacor)[top[,]]
rownames(aquainf)<-colnames(aquacor)
View(aquainf)
write.csv(aquainf, file="aquacorrelations.csv")