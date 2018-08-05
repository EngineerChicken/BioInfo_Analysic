library(DESeq2)
args<-commandArgs(T)

path = args[1]
infile = args[2]
samples = args[3]
groups = args[4]
cases = args[5]
controls = args[6]
compares = args[7]
NormalizedByCompare = args[8]
isCreateNormalizedCounts = args[9]
minrowSum = as.numeric(args[10])
minrowMax = as.numeric(args[11])
cutoff = as.numeric(args[12])

setwd(path)
data = read.table(infile, he=T, sep="\t", row.names=1)
title = read.table(infile, he=F, nrow = 1,colClasses='character',sep="\t", row.names=1)
colnames(data) = title
sample =  unlist(strsplit(samples, "[,]"))
group =  unlist(strsplit(groups, "[,]"))
case =  unlist(strsplit(cases, "[,]"))
control =  unlist(strsplit(controls, "[,]"))
compare =  unlist(strsplit(compares, "[,]"))
compareNum = length(compare)
map = data.frame(Sample = sample[1:length(group)],Group=group)

if(NormalizedByCompare=="false"||isCreateNormalizedCounts=="true"){
	condition = map[,2][match(colnames(data),map[,1])]
	colData <- data.frame(row.names=colnames(data), condition)
	dds <- DESeqDataSetFromMatrix(data, DataFrame(condition), design= ~ condition )
	dds <- DESeq(dds)
		if(isCreateNormalizedCounts=="true"){
			rld <- rlogTransformation(dds)
			exprSet=assay(rld)
			rownames = data.frame(AccID = row.names(exprSet))
			exprSet_new = cbind(rownames,exprSet)
			write.table(exprSet_new,"AllCounts.DESeq2.txt",sep="\t",quote = FALSE,row.names = FALSE)
		}
}

if(NormalizedByCompare=="false"){
	for(i in 1:compareNum){
		res <- results(dds,contrast=c("condition",case[i],control[i]))
		png(filename=paste0(compare[i],".MAplot.png",sep=""),width=800,height=800)
		plotMA(res,alpha=cutoff,main=paste0(compare[i],"_MAplot",sep=""))
		dev.off()
		out = data.frame(AccID = row.names(res),log2FC = res$log2FoldChange,Pvalue = res$pvalue,FDR=res$padj)
		out$FDR[is.na(out$FDR)]=1
		out$Pvalue[is.na(out$Pvalue)]=1
		write.table(out,paste0(compare[i],".result.txt"),sep="\t",quote = FALSE,row.names = FALSE)
	}
}else if(NormalizedByCompare=="true"){
	for(i in 1:compareNum){
		select = is.finite(match(map[,2],c(case[i],control[i])))
		dat = data[,select]
		dat = dat[rowSums(dat)>=minrowSum,]
		dat = dat[rowMax(as.matrix(dat))>=minrowMax,]
		condition = map[,2][match(colnames(dat),map[,1])]
		dds <- DESeqDataSetFromMatrix(dat, DataFrame(condition), design= ~ condition )
		dds <- DESeq(dds)
		res <- results(dds,contrast=c("condition",case[i],control[i]))
		png(filename=paste0(compare[i],".MAplot.png",sep=""),width=800,height=800)
                plotMA(res,alpha=cutoff,main=paste0(compare[i],"_MAplot",sep=""))
                dev.off()
		out = data.frame(AccID = row.names(res),log2FC = res$log2FoldChange,Pvalue = res$pvalue,FDR=res$padj)
		out$FDR[is.na(out$FDR)]=1
		out$Pvalue[is.na(out$Pvalue)]=1
		write.table(out,paste0(compare[i],".result.txt"),sep="\t",quote = FALSE,row.names = FALSE)
	}
}
write.table("finish",file="DiffGene.Finished")
