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


#conda install -c bioconda checkv
#conda install -c bioconda vibrant
#download-db.sh
#conda install -c bioconda virsorter
#virsorter setup -d db -j 22


checkv end_to_end h_qual_contigs.fa -d /mnt/ed058f9c-275f-4599-a283-e4e5927a7946/Databases/VIROME_TOOL_checkv/checkv-db-v1.0/ QC_CHECKV -t 22

VIBRANT_run.py -i h_qual_contigs.fa -t 22 -virome -d /mnt/ed058f9c-275f-4599-a283-e4e5927a7946/Databases/VIROME_TOOL_vibrant/databases/ -m /mnt/ed058f9c-275f-4599-a283-e4e5927a7946/Databases/VIROME_TOOL_vibrant/files/ -folder QC_VIBRANT

virsorter run -d /media/server/JOSUE/vapline_v2_database/db/  -w QC_VIRSORTER2 -i h_qual_contigs.fa -j 22 --include-groups dsDNAphage,NCLDV,RNA,ssDNA,lavidaviridae


TAB=$'\t'

cat QC_CHECKV/quality_summary.tsv | cut -f 1,8  | grep "High-quality"   | cut -f 1 | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_CHECKV01.txt
cat QC_CHECKV/quality_summary.tsv | cut -f 1,8  | grep "Medium-quality" | cut -f 1 | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_CHECKV02.txt
cat QC_CHECKV/quality_summary.tsv | cut -f 1,8  | grep "Complete"       | cut -f 1 | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_CHECKV03.txt
cat QC_VIBRANT/VIBRANT_h_qual_contigs/VIBRANT_results_h_qual_contigs/VIBRANT_genome_quality_h_qual_contigs.tsv | cut -f 1,3 | grep "high quality"   | cut -f 1 | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_VIBRANT01.txt
cat QC_VIBRANT/VIBRANT_h_qual_contigs/VIBRANT_results_h_qual_contigs/VIBRANT_genome_quality_h_qual_contigs.tsv | cut -f 1,3 | grep "medium quality" | cut -f 1 | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_VIBRANT02.txt
cat QC_VIBRANT/VIBRANT_h_qual_contigs/VIBRANT_results_h_qual_contigs/VIBRANT_genome_quality_h_qual_contigs.tsv | cut -f 1,3 | grep "complete"       | cut -f 1 | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_VIBRANT03.txt
cat QC_VIRSORTER2/final-viral-score.tsv | cut -f 1,8 | grep "full"  | grep "dsDNAphage"  | sed 's/|/'"${TAB}"'/g' | cut -f 1 | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_VIRSORTER01.txt
cat QC_VIRSORTER2/final-viral-score.tsv | cut -f 1,8 | grep "full"  | grep "RNA"  | sed 's/|/'"${TAB}"'/g' | cut -f 1        | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_VIRSORTER02.txt
cat QC_VIRSORTER2/final-viral-score.tsv | cut -f 1,8 | grep "full"  | grep "ssDNA"  | sed 's/|/'"${TAB}"'/g' | cut -f 1      | sed 's/_fragment/*/g' | sed 's/*/'"$TAB"'/g' | cut -f 1 > sQC_VIRSORTER03.txt

cat sQC* | cut -f1 | sort -u > h_qual_clean_contigs.txt

seqtk subseq h_qual_contigs.fa h_qual_clean_contigs.txt | seqkit sort -l -r -o h_qual_clean_contigs.fa


cd ..

echo 
echo 
echo ">>>>>>>>DONE, Proceed with 6_metavirome.sh script<<<<<<<<<"
echo ""
echo ""
echo ">>>>by J.Castro 28.12.2017<<<<"
echo "" 
