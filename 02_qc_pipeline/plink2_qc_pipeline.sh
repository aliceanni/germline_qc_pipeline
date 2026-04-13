# ==================================
# Germline QC Pipeline – PLINK2
# Chromosome 17 (1000 Genomes)
# ==================================

# Step 1: VCF conversion → PLINK2 format (pgen/psam/pvar)
plink2 \
  --vcf ALL.chr17*.vcf.gz \
  --make-pgen \
  --out data/chr17_raw \
  --threads 4

echo "=== Pre-QC Statistics ===" 
plink2 --pfile data/chr17_raw --freq --out results/freq_preQC

# Step 2: Standard QC filters
plink2 \
  --pfile data/chr17_raw \
  --maf 0.01 \          # Removes variants with allelic frequencies < 1%
  --geno 0.05 \         # Removes variants with > 5% missing genotypes
  --mind 0.10 \         # Removes individuals with > 10% missing genotypes
  --hwe 1e-6 \          # Hardy-Weinberg equilibrium filter
  --make-pgen \
  --out data/chr17_qcd \
  --threads 4

# Step 3: Log of variants removed at each step
echo "Pre-QC variants:"
awk 'NR>1' data/chr17_raw.pvar | wc -l

echo "Post-QC variants:"
awk 'NR>1' data/chr17_qcd.pvar | wc -l

