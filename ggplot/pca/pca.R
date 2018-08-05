#-------------------------------------
# name: pca.r
# copyright: genedenovo
# ‘#’号后面为注释信息
#------------------------------------
#install.packages("gmodels")
library(gmodels)
library(ggplot2)

# 设置好工作路径

# input file name **
inname="./pca/8-4-2/ACFVSALI.rpkm.2.txt"
#inname="daidawei_pca_data.txt";
# out PCA figure name **
outname = "./pca/8-4-2/test3.png"

# 设置分组
# define the color for points  **
group <- c("ACF","ACF","ACF","ACF","ACF","ALI","ALI","ALI","ALI","ALI")

## step 1: 数据的读取和处理
# read the expr data
expr <- read.table(inname, header=T, row.names=1)

# transpose the data
data <- t(as.matrix(expr))

## step2：PCA分析
# do PCA
data.pca <- fast.prcomp(data,scale=T)
data.pca <- fast.prcomp(data,retx=T,scale=T,center=T)    # 启用这句话，则将对数据进行归一化

## step3： PCA结果解析
# fetch the proportion of PC1 and PC2
a <- summary(data.pca)
tmp <- a[4]$importance
pro1 <- as.numeric(sprintf("%.3f",tmp[2,1]))*100
pro2 <- as.numeric(sprintf("%.3f",tmp[2,2]))*100

# 将成分矩阵转换为数据框
pc = as.data.frame(a$x)

# 给pc的数据框添加名称列和分组列（用来画图）
pc$group = group
pc$names = rownames(pc)

## step 4: 绘图
# draw PCA plot figure
xlab=paste("PC1(",pro1,"%)",sep="")
ylab=paste("PC2(",pro2,"%)",sep="")
pca=ggplot(pc,aes(PC1,PC2)) +
  geom_point(size=3,aes(shape=group,color=group)) +
  geom_text(aes(label=names),size=4)+labs(x=xlab,y=ylab,title="PCA") +
  geom_hline(yintercept=0,linetype=4,color="grey") +
  geom_vline(xintercept=0,linetype=4,color="grey") +
  theme_bw()

# 保存结果
ggsave(outname,pca,width=10,height=8)