#install.packages("ggplot2")


library(ggplot2)

pathway = read.table("zhaobin_tsRNA_pathway.txt",header=T,sep="\t")

pp = ggplot(pathway,aes(richFactor,PathwayTerm))
pp + geom_point()

pp + geom_point(aes(size=DifGene))

pbubble = pp + geom_point(aes(size=DifGene,color=-1*log10(P_Value)))
pbubble + scale_colour_gradient(low="green",high="red")

pr = pbubble + scale_colour_gradient(low="green",high="red") + labs(color=expression(-log[10](P_Value)),size="Gene number",x="Rich factor",y="Pathway name",title="Top20 of pathway enrichment")
pr + theme_bw()
ggsave("out.pdf")  
ggsave("out.png")  
ggsave("out2.png",width=4,height=4)   