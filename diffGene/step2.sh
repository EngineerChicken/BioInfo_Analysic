#step1,使用bioinfo调整输入文件
#结果临时保存在项目中的step1模块
cwd="../data/8-05-cjj/step1-2/8-7/7vs7";修改结果路径名
inout="ModifyforDiffGene.txt";

#修改样本名，比较组
Rscript DESeq2.R $cwd $inout ACF001,ACF002,ACF004,ACF005,ACF006,ACF007,ALI001,ALI002,ALI003,ALI004,ALI006,ALI007 ACF,ACF,ACF,ACF,ACF,ACF,ALI,ALI,ALI,ALI,ALI,ALI ACF ALI ACFVSALI true false 10 5 0.01
