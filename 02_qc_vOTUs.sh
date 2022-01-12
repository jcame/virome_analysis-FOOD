mkdir 00_contigs_processing
mkdir 00_qual_reads

cp folder*/reads* 00_qual_reads
cp folder*/contigs* 00_contigs_processing

cd 00_contigs_processing/

cat *.fa > All_cross_contigs.fasta
rm *.fa
dedupe.sh in=All_cross_contigs.fasta out=temp.fa minidentity=90
seqkit sort -l -r temp.fa -o Deduplicated.fasta 
rm temp.fa
seqtk rename Deduplicated.fasta vOTU_ > h_qual_contigs.fa

virsorter run -d /media/server/JOSUE/vapline_v2_database/db/  -w QC_VIRSORTER2 -i h_qual_contigs.fa -j 22 --include-groups dsDNAphage,NCLDV,RNA,ssDNA,lavidaviridae

TAB=$'\t'

cat QC_VIRSORTER2/final-viral-score.tsv | cut -f 1,8 | grep "full"  | grep "dsDNAphage"  | sed 's/|/'"${TAB}"'/g' | cut -f 1 | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_VIRSORTER01.txt
cat QC_VIRSORTER2/final-viral-score.tsv | cut -f 1,8 | grep "full"  | grep "RNA"  | sed 's/|/'"${TAB}"'/g' | cut -f 1        | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_VIRSORTER02.txt
cat QC_VIRSORTER2/final-viral-score.tsv | cut -f 1,8 | grep "full"  | grep "ssDNA"  | sed 's/|/'"${TAB}"'/g' | cut -f 1      | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_VIRSORTER03.txt

cat sQC* | cut -f1 | sort -u > h_qual_clean_contigs.txt

seqtk subseq h_qual_contigs.fa h_qual_clean_contigs.txt | seqkit sort -l -r -o h_qual_clean_contigs.fa


cd ..
