mydata<-read.csv("/home/ibab/programs/tetra_count.csv", header=TRUE,sep=",")
dat=data.frame(mydata)
values=dat[,2:257]
res<-Rtsne::Rtsne(values,perplexity=13)
species=mydata[,1]
species.fa<-factor(species)
plot(res$Y, col = "black", bg=species.fa, pch = 21, cex = 1.5)