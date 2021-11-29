#formatting


for dir in folder*
do
cd $dir


(for file in *R1*
do

string0=${file}
string1=$(sed "-es/combined_//g" <<< $string0)
string2=$(sed "-es/_/./g" <<< $string1)
string3=$(sed "-es/.R1.fastq//g" <<< $string2)
echo ${string3}

trimmomatic PE -threads 4 -phred33 *R1* *R2* PF1.fq UF1.fq PF2.fq UF2.fq ILLUMINACLIP:/media/server/JOSUE/vapline_v2_database/bin/NexteraPE-PE.fa:2:30:10 LEADING:20 TRAILING:20 MINLEN:50
cat PF1.fq UF1.fq > forward.fq
cat PF2.fq UF2.fq > reverse.fq
rm PF1.fq 
rm UF1.fq
rm PF2.fq
rm UF2.fq

seqkit rmdup forward.fq -s -o DPF1.fq -j 4
seqkit rmdup reverse.fq -s -o DPF2.fq -j 4
rm forward.fq
rm reverse.fq

bbduk.sh in=DPF1.fq out=forward.fq  ref=/media/server/JOSUE/vapline_v2_database/bin/phi_X174_phage.fa k=31 hdist=1
bbduk.sh in=DPF2.fq out=reverse.fq  ref=/media/server/JOSUE/vapline_v2_database/bin/phi_X174_phage.fa k=31 hdist=1
rm DPF1.fq
rm DPF2.fq

fastq_pair forward.fq reverse.fq
rm forward.fq
rm reverse.fq
cat *single.fq > unpaired.fq
rm *single.fq

spades.py --pe1-1 forward.fq.paired.fq --pe1-2 reverse.fq.paired.fq --pe1-s unpaired.fq -o spades_folder -t 22 -m 7 --only-assembler
seqkit seq spades_folder/scaffolds.fasta -m 2200 -g > contigs.fasta
rm -r spades_folder
seqtk rename contigs.fasta contig-${string3}_ > contigs_${string3}.fa
rm contigs.fasta


cat forward.fq.paired.fq reverse.fq.paired.fq  unpaired.fq | seqtk seq -a  | cut -d ' ' -f 1  >  tmp ; seqtk rename tmp ${string3}_ > reads_${string3}.fa
rm *fq
rm tmp


done)





cd ..
done

 

















