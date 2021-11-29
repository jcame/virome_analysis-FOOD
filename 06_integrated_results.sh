mkdir 00_integrated_results
cp 00_contigs_processing/h_qual_clean_contigs.fa 00_integrated_results/h_qual_clean_contigs.fa
cp 00_host-prediction/taxonomy_lineage.txt 00_integrated_results/taxonomy_host.txt
cp 00_taxonomy/taxonomy_lineage.txt	   00_integrated_results/taxonomy_viral.txt
cp 00_contigs_mapped_table/STATS/raw_vOTU_table.txt	00_integrated_results/raw_vOTU_table.txt


cd 00_integrated_results

seqkit fx2tab -l -n h_qual_clean_contigs.fa > tmp1
TAB=$'\t'
echo 'vOTU'"${TAB}"'size' > tmp2
cat tmp2 tmp1 > h_qual_clean_contigs_sizes.txt
rm tmp*

TAB=$'\t'
echo 'vOTU'"${TAB}"'taxonomy' > header
cat header taxonomy_host.txt > Taxonomy_host.txt
cat header taxonomy_viral.txt > Taxonomy_viral.txt
rm taxono*
rm header*


########################R

X = read.table('raw_vOTU_table.txt', header =T)
Y = read.table('h_qual_clean_contigs_sizes.txt', header =T, sep ="\t")
Z = merge(Y,X, all =FALSE)
size = Z$size
Z = Z[,-c(2)]
vOTU = Z$vOTU


### RPKM = numReads/(geneLength/1000 * totalNumReads/1000000)
### RPKM = C/(A * B)

A = size/1000
B = colSums(Z[-1])/1000000
C = Z[-1]


RPKM.tmp = C/(as.matrix(A) %*% B)
RPKM = cbind(vOTU,RPKM.tmp)


taxaH = read.table('Taxonomy_host.txt', header =T, sep ="\t")
taxaV = read.table('Taxonomy_viral.txt', header =T, sep ="\t")

tmp1 = merge(RPKM, taxaV, all.x = TRUE)
size = ncol(tmp1)
taxonomy = as.matrix(tmp1[,size])
taxonomy[is.na(taxonomy)] <- "Unknown"
taxonomy = data.frame(taxonomy)
tmp3 = tmp1[,-size]
viral.table = cbind(tmp3,taxonomy)

tmp1 = merge(RPKM, taxaH, all.x = TRUE)
size = ncol(tmp1)
taxonomy = as.matrix(tmp1[,size])
taxonomy[is.na(taxonomy)] <- "Unknown"
taxonomy = data.frame(taxonomy)
tmp3 = tmp1[,-size]
host.table = cbind(tmp3,taxonomy)

write.table(viral.table, "vOTU_table_viral.txt", sep = '\t', quote =FALSE, row.names =FALSE)
write.table(host.table, "vOTU_table_host.txt", sep = '\t', quote = FALSE, row.names =FALSE)



cd ..

