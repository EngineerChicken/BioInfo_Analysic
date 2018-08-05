library(ggplot2)
library(stringr)
library(grid)
Args <- commandArgs()
args6="pathway_data.txt";#
args7="pvalue_up";
args8="Pathway";
args9="temp.png";
args10="temp.pdf";



data=read.table(args6,header=T,sep="\t",quote = "",nrows=30)


pathCharNum=apply(data,1,nchar)[2,]

data[,2]=str_wrap(data[,2], width = 200)
maxPathCharNum = max(pathCharNum)
if (maxPathCharNum>200) {
  maxPathCharNum = 200
}
rowNumber = dim(data)[1]

yOrder=args7
porder=factor(as.integer(rownames(data)),labels=rev(data[,2]))
if (yOrder=="pvalue_up"){
  dataOrder=data[order(data[,7],decreasing=FALSE),]
  porder=factor(as.integer(rownames(data)),labels=rev(dataOrder[,2]))
  data=dataOrder
} else if (yOrder=="pvalue_down") {
  dataOrder=data[order(data[,7],decreasing=T),]
  porder=factor(as.integer(rownames(data)),labels=rev(dataOrder[,2]))
  data=dataOrder
} else if (yOrder=="enrichment_up") {
  dataOrder=data[order(data[,9],decreasing=FALSE),]
  porder=factor(as.integer(rownames(data)),labels=rev(dataOrder[,2]))
  data=dataOrder
} else if (yOrder=="enrichment_down") {
  dataOrder=data[order(data[,9],decreasing=T),]
  porder=factor(as.integer(rownames(data)),labels=rev(dataOrder[,2]))
  data=dataOrder
} 

titleStr = paste("Top",rowNumber,"of",args8,"enrichment")
yTitle = paste(args8,"Term")

pp = ggplot(data,aes(data[,3]/data[,5],data[,2]),family = "sans",face = "bold",size=axisFontSize)+ theme_bw()
pbubble = pp + geom_point(aes(y=rev(porder),size=DifGene,color=-1*log10(P.Value),family = "sans",face = "bold"))
legendHeigh = 0.5;
lengendSize = 14;
legendKeySize = 0.3 + rowNumber*0.01;
picHeigh = 2 + rowNumber*0.2
picWidth = maxPathCharNum*0.1 + 5
if(rowNumber<5) {
  lengendSize = 5+rowNumber*1
}


pr=pbubble + scale_colour_gradient(low="green",high="red") + theme(legend.position="right",legend.title=element_text(face="bold", family="sans", size=lengendSize),legend.key.size=unit(legendKeySize,"cm")) 
pr2=pr+labs(color=expression(-log[10](P-Value)),size="Gene number",family = "sans",face = "bold")

pr3 = pr2+labs(x="Rich factor",y="",title=titleStr)

axisFontSize = 16 - rowNumber*0.2;
if (maxPathCharNum>80) {
  axisFontSize = 18 - rowNumber*0.2 - maxPathCharNum*0.01;
}

pr4= pr3 + theme(axis.title=element_text(family = "sans",face = "bold",size=axisFontSize)) 
pr5 = pr4 + theme(axis.text.x=element_text(family = "sans",face = "bold",size=axisFontSize-1)) 
pr6 = pr5 + theme(axis.text.y=element_text(family = "sans",face = "bold",size=axisFontSize))
pr7 = pr6 + theme(plot.title=element_text(family = "sans",face = "bold",hjust=0.5,size=14+axisFontSize*0.05)) 

ggsave(pr7,file=args9,width=picWidth ,height= picHeigh ,dpi=500)
ggsave(pr7,file=args10,width=picWidth ,height= picHeigh ,dpi=500)
