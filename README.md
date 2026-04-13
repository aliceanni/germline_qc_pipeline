# Germline QC Pipeline

A reproducible bioinformatics pipeline for quality control and population
stratification of large-scale germline genomic data, using the 1000 Genomes
Project Phase 3 (chromosome 17) as a reference dataset.

## Overview

This pipeline implements standard pre-processing steps for germline variant
data, from raw VCF download to cohort definition by ancestry. It is designed
to produce analysis-ready datasets suitable for genome-wide association studies
(GWAS) and germline-somatic interaction analyses.

## Pipeline Structure

| Module | Script | Description |
|--------|--------|-------------|
| 1 | `01_download_data/download_and_inspect_chr17.sh` | Download VCF (chr17) and population panel from 1000 Genomes FTP |
| 2 | `02_qc_pipeline/plink2_qc_pipeline.sh` | QC filters: MAF, genotype call rate, HWE, duplicate removal |
| 3a | `03_population_stratification/pca_analysis.sh` | LD pruning and PCA computation (PLINK2) |
| 3b | `03_population_stratification/pca_plot_ch17.R` | PCA visualization colored by superpopulation (ggplot2) |
| 4 | `04_cohort_definition/cohort_filter.ipynb` | Cohort stratification by superpopulation (pandas) |

germline_qc_pipeline/
├── 01_download_data/
├── 02_qc_pipeline/
├── 03_population_stratification/
├── 04_cohort_definition/
├── data/
│ ├── raw/ # VCF and panel files (not versioned, see .gitignore)
│ └── cohorts/ # Sample IDs per superpopulation (for PLINK2 --keep)
├── results/
│ ├── figures/ # PCA plots
│ ├── chr17_pca.* # PLINK2 PCA output
│ └── vcf_stats_raw.txt
├── environment.yml
└── README.md

## Requirements

```bash
conda env create -f environment.yml
conda activate germline-qc
```

**Tools:** PLINK2, bcftools, R 4.3+ (tidyverse, ggplot2), Python 3.11 (pandas)

## Usage

Run modules sequentially from the project root:

```bash
# Module 1 — Download data (~1.5 GB)
bash 01_download_data/download_and_inspect_chr17.sh

# Module 2 — Quality control
bash 02_qc_pipeline/plink2_qc_pipeline.sh

# Module 3 — Population stratification
bash 03_population_stratification/pca_analysis.sh
Rscript 03_population_stratification/pca_plot_ch17.R

# Module 4 — Cohort definition
jupyter lab 04_cohort_definition/cohort_filter.ipynb
```

## Key Results

### QC Summary

| Stage | Variants | Samples |
|-------|----------|---------|
| Raw (chr17) | ~880,000 | 2,504 |
| Post-QC (MAF > 1%, geno < 5%, HWE p > 1e-6) | ~440,000 | 2,504 |

### Population Structure (PCA)

PCA on LD-pruned SNPs separates the five 1000 Genomes superpopulations.
PC1 captures African vs. non-African divergence; PC2 separates East Asian
from European ancestry. AMR samples show high dispersion, consistent with
their admixed genetic background. The top 20 PCs are used as covariates
in association models to control for population stratification.

### Stratified Cohorts

Output files `data/cohorts/cohort_*.txt` contain sample IDs per
superpopulation (EUR, EAS, AFR, AMR, SAS), ready for use with
`plink2 --keep` in downstream analyses.

## References

- Chang CC et al. (2015). *Second-generation PLINK: rising to the challenge
  of larger and richer datasets.* GigaScience, 4(1).
- 1000 Genomes Project Consortium (2015). *A global reference for human
  genetic variation.* Nature, 526, 68–74.
- PLINK2 QC tutorial: https://www.cog-genomics.org/plink/2.0/tutorials/qc2a
- SwitzerlandOmics PCA workflow: https://docs.switzerlandomics.ch/pages/pca_biplot_1kg.html

## Author

Alice Annicchiarico — M.Sc. Bioinformatics, University of Rome Tor Vergata
EOF

