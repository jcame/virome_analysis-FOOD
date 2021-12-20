# Vapline v2.0 (Virome Analysis Pipeline 2.0)

## Introduction (IN DEVELOPMENT### not ready yet)

This is a respository that contains a general workflow for virome analyses at UCPH-FOOD.
To be able to implementing this workflow you will need access to:

- Linux system (e.g. Ubuntu) (w/ administrator rights)
- :: Anaconda version 3
- R-base version 4.1.1 or higher | make sure the "tidyverse" package is installed

To implement the workflow create first a conda environment, and activate it:
```
conda create --name vaplinev2
conda activate vaplinev2
```

Install the following dependencies:
```
conda install -c bioconda trimmomatic
conda install -c bioconda seqkit 
conda install -c bioconda bbmap 
conda install -c bioconda fastq-pair 
conda install -c bioconda spades  
conda install -c bioconda seqtk
conda install -c bioconda virsorter 
virsorter setup -d db -j 22 # this will install the required databases, -j 22 = 22 cores | modify accordingly | this will generate ~13 GB of data
conda install -c bioconda bowtie 
conda install -c bioconda samtools

```

Then clone this repository:
```
git clone https://github.com/jcame/virome_analysis-FOOD.git
```


In addition, you should also download the following Vapline's customized databases:

- Modified DB of Viral Orthologous Groups (VOGs | https://vogdb.org/) + proteins from *Anelloviruses* (*Circoviridae*) derived from our recent pre-print Shah et al. 2021 (https://doi.org/10.1101/2021.07.02.450849) 
```
wget https://www.dropbox.com/s/k0cmufct7ewxxt8/vog.lca_206_anello.fa?dl=0  ; mv vog.lca_206_anello.fa?dl=0   bin/vog.lca_206_anello.fa
wget https://www.dropbox.com/s/ffppwuhiurkh0l6/vog.lca_206_anello.tsv?dl=0 ; mv vog.lca_206_anello.tsv?dl=0  bin/vog.lca_206_anello.tsv
```

- A DB of CRISPRs spacers and tRNAs predicted from species-level genome bins (SGBs) described in Pasolli et al. 2019 (https://doi.org/10.1016/j.cell.2019.01.001) & metagenome-assembled genomes (MAGs) described in Castro-Mejía et al. 2021 (https://doi.org/10.1101/2021.09.01.458531) 
```
wget https://www.dropbox.com/s/bmi2cjjrpvazknj/CALM-CS-SEGARA_DB_merged.fa?dl=0  ; mv CALM-CS-SEGARA_DB_merged.fa?dl=0  bin/CALM-CS-SEGARA_DB_merged.fa
wget https://www.dropbox.com/s/nmeovezthplrc6e/CALM-CS-SEGARA_DB_merged.txt?dl=0 ; mv CALM-CS-SEGARA_DB_merged.txt?dl=0 bin/CALM-CS-SEGARA_DB_merged.txt
```

- Nextera adaptors/transposases & PhiX Illumina control sequences
```
wget https://www.dropbox.com/s/icq13e935kicrz5/NexteraPE-PE.fa?dl=0    ; mv NexteraPE-PE.fa?dl=0   bin/NexteraPE-PE.fa
wget https://www.dropbox.com/s/qgk09l2w6vg82re/phi_X174_phage.fa?dl=0  ; mv phi_X174_phage.fa?dl=0 bin/phi_X174_phage.fa
```


## The workflow contains 6 steps, below a brief description of their rationale:

#### 1) Fastq QC + reads labeling + dereplicating + identifying sequence pairs + de-novo assembly

- *Quality control of unassembled reads, deconvoluting phi-X174 reads, dereplicating reads, finding paired- & unpaired- reads, and de-novo assembly*

#### 2) QC of assembled contigs + vOTUs labeling

- *This step uses solely VirSorter2 as QC of viral contigs ("full" categories | dsDNAphage, ssDNA,  RNA, Lavidaviridae, NCLDV | viralquality ≥ 0.66), our benchmark shows that VirSorter2 outcompetes any other viral genome tool, as we recently reported in Shah et al. 2021 (https://doi.org/10.1101/2021.07.02.450849)*

#### 3) Taxonomy annotation of vOTUs

- *Predicts ORF and compare them against VOGs-NCBI + Anelloviruses (Circoviridae), for each viral genome the annotated proteins/genes are subjected to voting-consensus LCA system (winner-gets-it-all). In our in-house benchmark, we have obtained satifactory results in providing taxonomy (order level) to Shah et al. 2021 (https://doi.org/10.1101/2021.07.02.450849) viral genomes. This is a fast (greedy indeed) system, but it shows high-performance for predicting high taxonomy levels*

#### 4) Bacterial host-prediction of vOTUs

- *Searches (blastn) CRISPRs spacers + tRNAs derived from metagenome assemblies. Similar to Step 3, for each viral genome the identified genomic regions matching (CRISPRs spacers + tRNAs) are subjected to voting-consensus LCA system (winner-gets-it-all) –– NOT bechmarked YET available, but it will come soon*

#### 5) vOTUs abundance stats

- *Maps unassembled reads to viral genomes (viral contigs) using Bowtie2, it creates BAM files (storing sequence alignment data) and extract number of reads mapping each viral genome within every sample. Then, aligments for every sample are converted into an abundance table of vOTUs*

#### 6) Integrated results

- *Normalizes RPKM on vOTU-tables and integrates host-taxonomy + viral-taxonomy on files ready to load in R (e.g. Phyloseq) or Qiime2*

# 
# 
# Tutorial

You can download a couple of virome examples to run in this pipeline
```
wget https://www.dropbox.com/s/tfg4szr1w23wma0/NXT062_IDA221_S221_R1_001.fastq?dl=0 ; mv NXT062_IDA221_S221_R1_001.fastq?dl=0 NXT062_IDA221_S221_R1_001.fastq
wget https://www.dropbox.com/s/jl9kecl1ndnl02c/NXT062_IDA221_S221_R2_001.fastq?dl=0 ; mv NXT062_IDA221_S221_R2_001.fastq?dl=0 NXT062_IDA221_S221_R2_001.fastq
wget https://www.dropbox.com/s/mmpa91s777vf5l4/NXT062_IDA222_S222_R1_001.fastq?dl=0 ; mv NXT062_IDA222_S222_R1_001.fastq?dl=0 NXT062_IDA222_S222_R1_001.fastq
wget https://www.dropbox.com/s/f3o21j2qiw0sz3a/NXT062_IDA222_S222_R2_001.fastq?dl=0 ; mv NXT062_IDA222_S222_R2_001.fastq?dl=0 NXT062_IDA222_S222_R2_001.fastq
```

Next, 




# Note: At this moment the pipeline is based on bash wrappers, but I do hope to provide a conda environment for easier deployment (just need to find the time).

