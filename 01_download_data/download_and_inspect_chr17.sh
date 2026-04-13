# ==============================
# 1000 Genomes – Download & QC
# Chromosome 17 – Phase 3 VCF
# ==============================

# download_1kg.sh
BASE_URL="http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502"

# Download VCF chr17 + tabix index
wget ${BASE_URL}/ALL.chr17.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz
wget ${BASE_URL}/ALL.chr17.phase3_shapeit2_mvncall_integrated_v5b.20130502.genotypes.vcf.gz.tbi

# Initial inspection with bcftools
bcftools stats ALL.chr17*.vcf.gz | grep "^SN" > results/vcf_stats_raw.txt
bcftools view -H ALL.chr17*.vcf.gz | head -5  # variant prewie
