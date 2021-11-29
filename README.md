# vapline_v2.0 (Virome Analysis Pipeline 2.0)

## Introduction

This is a respository that contains a general workflow for virome analyses at UCPH-FOOD.
To be able to implementing this workflow you will need access to:

- Linux system (e.g. Ubuntu) (w/ administrator rights)
- :: Anaconda version 3
- R-base version 4.1.1 or higher | including "tidyverse"

To implement the workflow, you will have to install the following dependencies:
```
conda install -c bioconda trimmomatic
conda install -c bioconda seqkit 
conda install -c bioconda bbmap 
conda install -c bioconda fastq-pair 
conda install -c bioconda spades  
conda install -c bioconda seqtk
conda install -c bioconda virsorter 
conda install -c bioconda bowtie 
conda install -c bioconda samtools
usearch############
```

In addition, you should download the following customized databases:


The workflow contains 6 wrappers dealing with the following steps:

1) Fastq QC + reads labeling + dereplicating + identifying sequence pairs + de-novo assembly

2) QC of assembled contigs + vOTUs labeling (ONLY Linux systems - just because 'Virsorter2' is not supported in VMs or MAC)

3) Taxonomy annotation of vOTUs

4) Bacterial host-prediction of vOTUs

5) vOTUs abundance stats

--- Required packages:
```
conda install -c bioconda bowtie 
conda install -c bioconda samtools
```

6) Integrated results

--- No Required packages: it is just formatting and calculations







