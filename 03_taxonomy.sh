mkdir 00_taxonomy
cp 00_contigs_processing/h_qual_clean_contigs.fa 00_taxonomy/h_qual_clean_contigs.fa
cd 00_taxonomy

usearch10 -ublast h_qual_clean_contigs.fa -db /media/server/JOSUE/vapline_v2_database/bin/vog.lca_206_anello.fa -evalue 1e-3  -blast6out blastout.txt -cover_query  -dbmask fastamino -threads 22
cut -f1 < blastout.txt >  tmp1.txt
TAB=$'\t'
cat  blastout.txt | cut -f2  | sed 's/_/'"$TAB"'/g' | cut -f1  >  tmp2.txt
paste tmp1.txt tmp2.txt > blastout_selected.txt
rm tmp*


###########R

library(tidyverse)
X = read.table('blastout_selected.txt', header =F)
Y = read.table('/media/server/JOSUE/vapline_v2_database/bin/vog.lca_206_anello.tsv', header =T, sep ="\t")
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
lca7 = data.frame(annotations %>% group_by(V1, L7) %>% count() %>% group_by(V1) %>% filter(n == max(n)) %>% group_by(V1) %>% mutate(LL7 = L7 %>% fixtax) %>% group_by(V1) %>% filter(row_number()==1))
lca8 = data.frame(annotations %>% group_by(V1, L8) %>% count() %>% group_by(V1) %>% filter(n == max(n)) %>% group_by(V1) %>% mutate(LL8 = L8 %>% fixtax) %>% group_by(V1) %>% filter(row_number()==1))
lca9 = data.frame(annotations %>% group_by(V1, L9) %>% count() %>% group_by(V1) %>% filter(n == max(n)) %>% group_by(V1) %>% mutate(LL9 = L9 %>% fixtax) %>% group_by(V1) %>% filter(row_number()==1))

LCA1 = lca1[,c(1,4)]
LCA2 = lca2[,c(1,4)]
LCA3 = lca3[,c(1,4)]
LCA4 = lca4[,c(1,4)]
LCA5 = lca5[,c(1,4)]
LCA6 = lca6[,c(1,4)]
LCA7 = lca7[,c(1,4)]
LCA8 = lca8[,c(1,4)]


L1 = merge(LCA1,LCA2, all =FALSE)
L2 = merge(L1,LCA3, all =FALSE)
L3 = merge(L2,LCA4, all =FALSE)
L4 = merge(L3,LCA5, all =FALSE)
L5 = merge(L4,LCA6, all =FALSE)
L6 = merge(L5,LCA7, all =FALSE)
L7 = merge(L6,LCA8, all =FALSE)

write.table(L7,"taxonomy_L7.txt", sep = "\t", quote =F, row.names =FALSE)

##########################



cut -f1 taxonomy_L7.txt > tmp1
cut -f2,3,4,5,6,7,8,9 taxonomy_L7.txt > tmp2
TAB=$'\t'
sed 's/'"${TAB}"'/;/g' < tmp2 > tmp3
paste tmp1 tmp3 | sed '1d'  > taxonomy_lineage.txt
rm taxonomy_L7.txt
rm tmp*


cd ..

