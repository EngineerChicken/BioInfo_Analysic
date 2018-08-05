#install.packages("ggplot2")
# 导入包
# 帮助文档链接：http://docs.ggplot2.org/current/
library(ggplot2)
# 改变工作路径，将工作路径改变到数据存放的文件夹下
# 火山图
# 读取数据：R0-vs-R3.isoforms.filter.tsv
data =read.table("R0-vs-R3.isoforms.filter.tsv",header=T,row.names=1)
# 画图
r03 = ggplot(data,aes(log2FC,-1*log10(FDR)))
r03 + geom_point()