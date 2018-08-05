Args <- commandArgs()
library(ggplot2)
data=read.table(Args[6],sep="\t",header=T)
log2fc=as.numeric(Args[7])
fdr=as.numeric(Args[8])
log2fcThreshold=as.numeric(Args[9])
fdrThreshold=as.numeric(Args[10])
xlimit = as.numeric(Args[11])
ylimit = as.numeric(Args[12])
pvaluefdr=Args[13]
FDR <- c(data[,fdr])
FC <- c(data[,log2fc])
df <- data.frame(FDR, FC)
df.G <- subset(df, FC < -log2fcThreshold& FDR < fdrThreshold) #define Down
df.G <- cbind(df.G, rep("Down", nrow(df.G)))
colnames(df.G)[3] <- "Style"
df.B <- subset(df, (FC >= -log2fcThreshold & FC <= log2fcThreshold) | FDR >= fdrThreshold) #define Normal
df.B <- cbind(df.B, rep("Normal", nrow(df.B)))
colnames(df.B)[3] <- "Style"
df.R <- subset(df, FC > log2fcThreshold & FDR < fdrThreshold) #define Up
df.R <- cbind(df.R, rep("Up", nrow(df.R)))
colnames(df.R)[3] <- "Style"
df.t <- rbind(df.G, df.B, df.R)
df.t$Style <- as.factor(df.t$Style)
result=ggplot(data=df.t,aes(FC,-1*log10(FDR), color= Style)) +theme_bw()+theme(panel.grid.major=element_blank(),panel.grid.minor=element_blank(),panel.border=element_blank(),axis.line=element_line(colour="black"))+ geom_point(size=0.8)+ xlim(-xlimit,xlimit) + ylim(0,ylimit) + geom_vline(xintercept=c(-log2fcThreshold,log2fcThreshold), linetype="longdash", size=0.2) + geom_hline(yintercept=c(-log10(fdrThreshold)), linetype="longdash", size=0.2)

if (nrow(df.G) == 0) {
result=result + scale_color_manual(values =c("gray","red")) 
}else if(nrow(df.B) == 0){
result=result + scale_color_manual(values =c("blue","red")) 
}else if(nrow(df.R) == 0){
result=result + scale_color_manual(values =c("blue","gray")) 
}else {
result=result + scale_color_manual(values =c("blue","gray","red")) 
}

if (pvaluefdr == "FDR") {
result2=result + labs(title="Volcanoplot",x=expression(Log[2](FC)),y=expression(-log[10](FDR)))
} else {
result2=result + labs(title="Volcanoplot",x=expression(Log[2](FC)),y=expression(-log[10](Pvalue)))
}
ggsave(result2,file=Args[14])
dataplot=cbind(data[,log2fc],-1*log10(data[,fdr]))
colnames(dataplot) <-c("Log2FC","-log10(FDR)")
write.table(dataplot,quote=FALSE, row.names=FALSE, sep="\t", eol="\n",file=Args[15])
