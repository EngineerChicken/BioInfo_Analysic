library(ggplot2)
library(plyr)
library(reshape2)
library (scales)
library(RColorBrewer)
Args <- commandArgs()
data =read.table(Args[6],header=T)
dataR=cor(data[as.numeric(Args[9]):ncol(data)])
dataR = dataR^2
data=as.data.frame(dataR)
data=data.frame(row=rownames(data),data)
fileName=levels(data$row)
datap=subset(dataR,select=fileName)
datap=datap[order(datap[,1]),]
dataplot=matrix(0,length(fileName),length(fileName))
for (i in 1:length(fileName)) {
	dataplot[i,]=datap[rownames(datap) %in% fileName[i]]
}
colnames(dataplot)=levels(data$row)
rownames(dataplot)=fileName
dataplot=formatC(dataplot,digits=3)
write.table(dataplot,quote=FALSE, row.names=TRUE, sep="\t", eol="\n",file=Args[8])
rownames(data) <- NULL
data=melt(data)
r1=ggplot(data,aes(row,variable))+xlab("")+geom_tile(aes(fill=value),colour="transparent")+theme(axis.text.x=element_text(angle=60,hjust=1),axis.title.y=element_blank())
r2=r1+scale_fill_gradient(name=expression(R^2),low="white",high="#003E3E")+theme(panel.background = element_rect(fill='white', colour='white'))
r3=r2+scale_y_discrete(limits=levels(data$row)) + labs(title="Pearson correlation between samples")+geom_text(aes(label=round(value,3)),size=2)
ggsave(r3,file=Args[7])

