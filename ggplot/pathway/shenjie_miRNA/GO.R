#install.packages("ggplot2")


library(ggplot2)

go = read.table("shenjie_go_30.txt",header=T,sep="\t")

pp = ggplot(go,aes(richFactor,GOTerm))
pp + geom_point()

pp + geom_point(aes(size=DifGene))

pbubble = pp + geom_point(aes(size=DifGene,color=-1*log10(P_Value)))
pbubble + scale_colour_gradient(low="green",high="red")

pr = pbubble + scale_colour_gradient(low="green",high="red") + labs(color=expression(-log[10](P_Value)),size="Gene number",x="Rich factor",y="Go name",title="Top30 of go enrichment")
pr + theme_bw()
ggsave("out-go30.pdf")  
ggsave("out-go30.png")  
ggsave("out2.png",width=4,height=4)   