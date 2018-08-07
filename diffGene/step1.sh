#step1,使用bioinfo调整输入文件
#结果临时保存在项目中的step1模块
input="../data/8-05-cjj/all.counts.exp.txt";
out="../data/8-05-cjj/step1/8-7/7vs7/ModifyforDiffGene.txt";

#需要设置参数：1--col 表示样本名表达量所在行。
#--group 表示样本名表达量的组名
#4-9,   ACF001	ACF002	ACF004	ACF005	ACF006	ACF007
#10-15, ALI001	ALI002	ALI003	ALI004	ALI006	ALI007
#前开后闭
java -cp ../bioinfo.jar com.novelbio.bioinfomatics.tools.ModifyInputFile --in $input --col 4,5,6,7,8,9,10,11,12,13,14,15,16, --group ACF,ACF,ACF,ACF,ACF,ACF，ALI,ALI,ALI,ALI,ALI,ALI,ALI, --genecol 1 --minSum 10 --minSep 5 --needlog false --out $out
