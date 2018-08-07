#step1,使用bioinfo调整输入文件
#结果临时保存在项目中的step1模块
input="../data/8-05-cjj/all.counts.exp.txt";
out="../data/8-05-cjj/step1/ModifyforDiffGene.txt";

java -cp ../bioinfo.jar com.novelbio.bioinfomatics.tools.ModifyInputFile --in $input --col 4,5,6,8,10,12,14,15 --group ACF,ACF,ACF,ACF,ALI,ALI,ALI,ALI --genecol 1 --minSum 10 --minSep 5 --needlog false --out $out
