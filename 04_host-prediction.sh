mkdir 00_host-prediction
cp 00_contigs_processing/h_qual_clean_contigs.fa 00_host-prediction/h_qual_clean_contigs.fa
cd 00_host-prediction

usearch10 -ublast h_qual_clean_contigs.fa -db /media/server/JOSUE/vapline_v2_database/bin/CALM-CS-SEGARA_DB_merged.fa -evalue 1e-5 -id 0.8  -blast6out blastout.txt -cover_query -strand both -threads 22
cat blastout.txt | cut -f 2 | sed 's/.fa_CRISPR/*/g' | sed 's/.fasta_/*/g'  | cut -d '*' -f 1 > tmp1  
cat blastout.txt | cut -f 1  > tmp2
paste tmp2 tmp1 > blastout_selected.txt
rm tmp*


###########R

library(tidyverse)
X = read.table('blastout_selected.txt', header =F)
Y = read.table('/media/server/JOSUE/vapline_v2_database/bin/CALM-CS-SEGARA_DB_merged.txt', header =T, sep ="\t")
Z = merge(X,Y, all =FALSE)

annotations = tibble(Z)

fixtax <- function(tax) {
  nun <- tax %>% unique
  tax2 <- ifelse(length(nun)==1,nun, 'Unclassified')
  return(tax2)
}

lca1 = data.frame(annotations %>% group_by(V1, L1) %>% count() %>% group_by(V1) %>% filter(n == max(n)) %>% group_by(V1) %>% mutate(LL1 = L1 %>% fixtax) %>% group_by(V1) %>% filter(row_number()==1))
lca2 = data.frame(annotations %>% group_by(V1, L2) %>% count() %>% group_by(V1) %>% filter(n == max(n)) %>% group_by(V1) %>% mutate(LL2 = L2 %>% fixtax) %>% group_by(V1) %>% filter(row_number()==1))
lca3 = data.frame(annotations %>% group_by(V1, L3) %>% count() %>% group_by(V1) %>% filter(n == max(n)) %>% group_by(V1) %>% mutate(LL3 = L3 %>% fixtax) %>% group_by(V1) %>% filter(row_number()==1))
lca4 = data.frame(annotations %>% group_by(V1, L4) %>% count() %>% group_by(V1) %>% filter(n == max(n)) %>% group_by(V1) %>% mutate(LL4 = L4 %>% fixtax) %>% group_by(V1) %>% filter(row_number()==1))
lca5 = data.frame(annotations %>% group_by(V1, L5) %>% count() %>% group_by(V1) %>% filter(n == max(n)) %>% group_by(V1) %>% mutate(LL5 = L5 %>% fixtax) %>% group_by(V1) %>% filter(row_number()==1))
lca6 = data.frame(annotations %>% group_by(V1, L6) %>% count() %>% group_by(V1) %>% filter(n == max(n)) %>% group_by(V1) %>% mutate(LL6 = L6 %>% fixtax) %>% group_by(V1) %>% filter(row_number()==1))

LCA1 = lca1[,c(1,4)]
LCA2 = lca2[,c(1,4)]
LCA3 = lca3[,c(1,4)]
LCA4 = lca4[,c(1,4)]
LCA5 = lca5[,c(1,4)]
LCA6 = lca6[,c(1,4)]



L1 = merge(LCA1,LCA2, all =FALSE)
L2 = merge(L1,LCA3, all =FALSE)
L3 = merge(L2,LCA4, all =FALSE)
L4 = merge(L3,LCA5, all =FALSE)
L5 = merge(L4,LCA6, all =FALSE)


write.table(L5,"taxonomy_L7.txt", sep = "\t", quote =F, row.names =FALSE)

##########################



cut -f1 taxonomy_L7.txt > tmp1
cut -f2,3,4,5,6,7 taxonomy_L7.txt > tmp2
TAB=$'\t'
sed 's/'"${TAB}"'/;/g' < tmp2 > tmp3
paste tmp1 tmp3 | sed '1d'  > taxonomy_lineage.txt
rm taxonomy_L7.txt
rm tmp*


cd ..

