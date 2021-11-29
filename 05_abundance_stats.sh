mkdir 00_contigs_mapped_table
cp 00_contigs_processing/h_qual_clean_contigs.fa 00_qual_reads/h_qual_clean_contigs.fa
cp 00_contigs_processing/h_qual_clean_contigs.fa 00_contigs_mapped_table/h_qual_clean_contigs.fa
cd 00_qual_reads

bowtie2-build -f h_qual_clean_contigs.fa dbname


for file in reads*.fa
do
TAB=$'\t'
bowtie2 -x dbname -f $file -p 24 |  samtools view -bS - > tmp
samtools sort tmp  -o ${file}.bam -@ 24
echo 'vOTU'"${TAB}"''"${file}"'' > header
samtools index -b ${file}.bam
samtools idxstats ${file}.bam | cut -f1,3 | sed '/*/d' > tmp
cat header tmp > ${file}.stats
rm tmp
rm header
rm *bai
done


rm dbname*
rm h_qual_clean_contigs.fa
mv *bam ../00_contigs_mapped_table/
mv *stats ../00_contigs_mapped_table/

cd ..
cd 00_contigs_mapped_table

mkdir BAMS
mkdir STATS
mv *bam BAMS/
mv *stats STATS/

cd STATS/


######################R

library(tidyverse)
filelist = list.files(pattern = "*stats")
datalist = lapply(filelist, function(x)read.table(x, header =T))
vOTU_table = datalist %>% reduce(full_join, by = "vOTU")
vOTU_table[is.na(vOTU_table)] <- 0
write.table(vOTU_table, "raw_vOTU_table.txt", sep = '\t', quote =FALSE, row.names =FALSE)

######################R

cd ..
cd ..



