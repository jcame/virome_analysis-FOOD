# vapline_v2.0 (Virome Analysis Pipeline 2.0)

## Introduction

This is a respository that contains a general workflow for virome analyses at UCPH-FOOD.
To be able to implementing this workflow you will need access to:

- UNIX-like terminal/Linux (w/ administrator rights)
- :: Anaconda version 3
- R-base version 4.1.1 or higher | including tidyverse package

The workflow contains 6 wrappers dealing with the following steps:

1) Fastq QC + reads labeling + dereplicating + identifying sequence pairs + de-novo assembly

Required packages
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

```
conda install -c bioconda trimmomatic
conda install -c bioconda seqkit 
conda install -c bioconda bbmap 
conda install -c bioconda fastq-pair 
conda install -c bioconda spades  
conda install -c bioconda nanofilt
conda install -c bioconda blast
```

3) Taxonomy annotation of vOTUs

```
conda install -c bioconda trimmomatic
conda install -c bioconda seqkit 
conda install -c bioconda bbmap 
conda install -c bioconda fastq-pair 
conda install -c bioconda spades  
conda install -c bioconda nanofilt
conda install -c bioconda blast
```

4) Bacterial host-prediction of vOTUs

```
conda install -c bioconda trimmomatic
conda install -c bioconda seqkit 
conda install -c bioconda bbmap 
conda install -c bioconda fastq-pair 
conda install -c bioconda spades  
conda install -c bioconda nanofilt
conda install -c bioconda blast
```

5) vOTUs abundance stats

```
conda install -c bioconda trimmomatic
conda install -c bioconda seqkit 
conda install -c bioconda bbmap 
conda install -c bioconda fastq-pair 
conda install -c bioconda spades  
conda install -c bioconda nanofilt
conda install -c bioconda blast
```

6) Integrated results

```
conda install -c bioconda trimmomatic
conda install -c bioconda seqkit 
conda install -c bioconda bbmap 
conda install -c bioconda fastq-pair 
conda install -c bioconda spades  
conda install -c bioconda nanofilt
conda install -c bioconda blast
```






