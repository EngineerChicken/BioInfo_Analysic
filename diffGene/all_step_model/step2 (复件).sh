#step1,使用bioinfo调整输入文件
#结果临时保存在项目中的step1模块
cwd="../data/8-05-cjj";
inout="./step1/ModifyforDiffGene.txt";

Rscript DESeq2.R $cwd $inout ACF001,ACF002,ACF004,ACF006,ALI001,ALI003,ALI006,ALI007 ACF,ACF,ACF,ACF,ALI,ALI,ALI,ALI ACF ALI ACFVSALI true false 10 5 0.01
