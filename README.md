# vapline_v2.0 (Virome Analysis Pipeline 2.0)

## Introduction

This is a respository that contains a general workflow for virome analyses at UCPH-FOOD.
To be able to implementing this workflow you will need access to:

- Linux system (e.g. Ubuntu) (w/ administrator rights)
- :: Anaconda version 3
- R-base version 4.1.1 or higher | make sure the "tidyverse" package is installed

To implement the workflow, you will have to install the following dependencies and create a "bin" directory:
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

usearch  #Download the free version of usearch (e.g. version 11) | https://www.drive5.com/usearch/download.html | make usearch is executable by running the following line:
chmod 775 usearch*
mv usearch* bin/
```

In addition, you should download the following customized databases:

- Modified DB of Viral Orthologous Groups (VOGs | https://vogdb.org/) + proteins from Anelloviruses (Circoviridae) derived from our recent pre-print Shah et al. 2021 (https://doi.org/10.1101/2021.07.02.450849) 
```
https://www.dropbox.com/s/k0cmufct7ewxxt8/vog.lca_206_anello.fa?dl=0  ; mv vog.lca_206_anello.fa?dl=0   bin/vog.lca_206_anello.fa
https://www.dropbox.com/s/ffppwuhiurkh0l6/vog.lca_206_anello.tsv?dl=0 ; mv vog.lca_206_anello.tsv?dl=0  bin/vog.lca_206_anello.tsv
```

- A DB of CRISPRs spacers and tRNAs predicted from species-level genome bins (SGBs) described in Pasolli et al. 2019 (https://doi.org/10.1016/j.cell.2019.01.001) & metagenome-assembled genomes (MAGs) described in Castro-Mejía et al. 2021 (https://doi.org/10.1101/2021.09.01.458531) 
```
https://www.dropbox.com/s/bmi2cjjrpvazknj/CALM-CS-SEGARA_DB_merged.fa?dl=0  ; mv CALM-CS-SEGARA_DB_merged.fa?dl=0  bin/CALM-CS-SEGARA_DB_merged.fa
https://www.dropbox.com/s/nmeovezthplrc6e/CALM-CS-SEGARA_DB_merged.txt?dl=0 ; mv CALM-CS-SEGARA_DB_merged.txt?dl=0 bin/CALM-CS-SEGARA_DB_merged.txt
```

- Nextera adaptors/transposases & PhiX Illumina control sequences
```
https://www.dropbox.com/s/icq13e935kicrz5/NexteraPE-PE.fa?dl=0    ; mv NexteraPE-PE.fa?dl=0   bin/NexteraPE-PE.fa
https://www.dropbox.com/s/qgk09l2w6vg82re/phi_X174_phage.fa?dl=0  ; mv phi_X174_phage.fa?dl=0 bin/phi_X174_phage.fa
```


## The workflow contains 6 wrappers dealing with the following steps:

#### 1) Fastq QC + reads labeling + dereplicating + identifying sequence pairs + de-novo assembly

#### 2) QC of assembled contigs + vOTUs labeling

*This step uses solely VirSorter2 as QC of viral contigs ("full" categories | dsDNAphage, ssDNA,  RNA, Lavidaviridae, NCLDV), our benchmark shows that VirSorter2 outcompetes any other tool, as we report in Shah et al. 2021 (https://doi.org/10.1101/2021.07.02.450849)*

#### 3) Taxonomy annotation of vOTUs

#### 4) Bacterial host-prediction of vOTUs

#### 5) vOTUs abundance stats

#### 6) Integrated results


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



