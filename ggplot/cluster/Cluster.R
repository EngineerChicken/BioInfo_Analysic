library(pheatmap)
inputRPKM="./ggplot/cluster/8-4/ACFVSALI.rpkm.3.txt";
outputPDF="./ggplot/cluster/8-4/test.pdf";

data<- read.table(inputRPKM,head = T,row.names=1,sep="\t")
pheatmap(data,
         scale="row",#按列均一化，"row","column" or "none"默认是"none"
         #clustering_distance_rows = "correlation",#聚类线长度优化
         treeheight_row=40,#按行聚类树高
         treeheight_col=40,#按列聚类树高
         #cluster_cols=F,#是否按列聚类,
         #cluster_rows=F,#是否按行聚类
         display_numbers=F,#是否在每一格上显示数据
         number_format="%.2f",#显示数据的格式，几位小数，或"\%.1e"，颜色number_color,大小fontsize_number
         fontsize_row=10,#行名称字体大小
         fontsize_col=15,#列名称字体大小
         #格子大小
         cellwidth = 50,
         cellheight= 14,
         #main="ABC",#标题名称
         #gaps_row = c(10, 15),#插入缝隙，不能聚类！
         #cutree_row = 7,#按聚类分割
         show_colnames=T,#是否显示列名，同理show_rownames
         show_rownames=T,
         #定义颜色"navy", "white", "firebrick3"
         #color = colorRampPalette(c("green","black","red"),bias=2.5)(256),
         #color = colorRampPalette(c("green","black","red"))(256),         
         color = colorRampPalette(c("MediumBlue","white","red"))(256),
         border_color = "black" ,#格子框颜色
         #legend = FALSE,#是否显示图例
         legend_breaks = -1:4,#图例范围
         filename = outputPDF #保存文件命名
) 