#step3,使用bioinfo计算DESeq2
#需要×.result.txt文件
#需要ModifyforDiffGene.txt文件
outin="../data/8-05-cjj/step1/ModifyforDiffGene.txt";

java -cp ../bioinfo.jar com.novelbio.bioinfomatics.tools.ModifyInputFile --in $input --col 4,5,6,8,10,12,14,15 --group ACF,ACF,ACF,ACF,ALI,ALI,ALI,ALI --genecol 1 --minSum 10 --minSep 5 --needlog false --out $out

java -cp bioinfo.jar com.novelbio.bioinfomatics.tools.DifGeneFilter --in $outin --out .all --diff ACFVSALI.result.txt --sample ACF001,ACF002,ACF004,ACF006,ALI001,ALI003,ALI006,ALI007 --group ACF,ACF,ACF,ACF,ALI,ALI,ALI,ALI --case ACF --control ALI --compare ACFVSALI --type FDR --log2FC 1 --cutoff 0.01 --algorithm DESeq2
