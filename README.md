# vapline_v2.0 (Virome Analysis Pipeline)

## Introduction

This is a respository that contains a general implementation-workflow for virome analyses at UCPH-FOOD.
The workflow contains 6 wrappers dealing with the following steps:

1) Fastq QC + reads labeling + de-novo assembly

```
conda install -c bioconda trimmomatic
conda install -c bioconda seqkit 
conda install -c bioconda bbmap 
conda install -c bioconda fastq-pair 
conda install -c bioconda spades  
conda install -c bioconda nanofilt
conda install -c bioconda blast
```

2) QC of assembled contigs + vOTUs labeling
3) Taxonomy annotation of vOTUs
4) Bacterial host-prediction of vOTUs
5) vOTUs abundance stats
6) Integrated results
