# Assign unique IDs + remove duplicates
# -----------------------------

# Assign unique IDs to all variants
plink2 \
  --pfile data/chr17_qcd \
  --set-all-var-ids @:#:\$r:\$a \
  --make-pgen \
  --out data/chr17_qcd_uniq

echo "Unique IDs assigned"

# Identify duplicates

plink2 \
  --pfile data/chr17_qcd_uniq \
  --rm-dup list \
  --out tmp/dup_check

echo "Duplicates listed in tmp/dup_check.dupvar"

# Removing duplicates

plink2 \
  --pfile data/chr17_qcd_uniq \
  --rm-dup force-first \
  --make-pgen \
  --out data/chr17_qcd_nodup

echo "Duplicates removed"


# -----------------------------
# 5. LD pruning
# -----------------------------

# LD pruning

plink2 \
  --pfile data/chr17_qcd_nodup \
  --indep-pairwise 50 10 0.1 \
  --out data/chr17_pruned

echo "Generated prune.in and prune.out files"


# -----------------------------
# PCA 
# -----------------------------

# PCA on independent SNPs

plink2 \
  --pfile data/chr17_qcd_nodup \
  --extract data/chr17_pruned.prune.in \
  --pca 20 \
  --out results/chr17_pca

echo "PCA completed: results/chr17_pca.eigenvec"
