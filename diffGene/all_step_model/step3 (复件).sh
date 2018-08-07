#step3,使用bioinfo计算DESeq2
#需要×.result.txt文件
#需要ModifyforDiffGene.txt文件
outin="../data/8-05-cjj/step1/ModifyforDiffGene.txt";
outin2="../data/8-05-cjj/step2/ACFVSALI.result.txt";
outputDir="../data/8-05-cjj/step3";


java -cp ../bioinfo.jar com.novelbio.bioinfomatics.tools.DifGeneFilter --in $outin --out $outputDir --diff $outin2 --sample ACF001,ACF002,ACF004,ACF006,ALI001,ALI003,ALI006,ALI007 --group ACF,ACF,ACF,ACF,ALI,ALI,ALI,ALI --case ACF --control ALI --compare ACFVSALI --type FDR --log2FC 1 --cutoff 0.01 --algorithm DESeq2
