#step3,使用bioinfo计算DESeq2
#需要×.result.txt文件
#需要ModifyforDiffGene.txt文件
outin="../data/8-05-cjj/step1-2/8-7/7vs7/ModifyforDiffGene.txt";
outin2="../data/8-05-cjj/step1-2/8-7/7vs7/ACFVSALI.result.txt";
outputDir="../data/8-05-cjj/step3/8-7/7vs7";


java -cp ../bioinfo.jar com.novelbio.bioinfomatics.tools.DifGeneFilter --in $outin --out $outputDir --diff $outin2 --sample ACF001,ACF002,ACF004,ACF005,ACF006,ACF007,ALI001,ALI002,ALI003,ALI004,ALI006,ALI007 --group ACF,ACF,ACF,ACF,ACF,ACF,ALI,ALI,ALI,ALI,ALI,ALI --case ACF --control ALI --compare ACFVSALI --type FDR --log2FC 1 --cutoff 0.01 --algorithm DESeq2
