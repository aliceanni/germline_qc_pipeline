# ============================================================
# PCA Annotation – 1000 Genomes (Chromosome 17)
# Author: Alice Annicchiarico
# Description:
#   - Importa PCA da PLINK2
#   - Importa file panel 1000 Genomes
#   - Effettua merge per aggiungere popolazione e super-pop
# ============================================================
library(tidyverse)
library(readr)
library(dplyr)

# ------------------------------------------------------------
# 1. Importa PCA generata da PLINK2
#    Il file .eigenvec NON ha header, quindi header = FALSE
# ------------------------------------------------------------
pca <- read.table(
  "/Users/alice/Documents/R_scripts/chr17_pca.eigenvec",
  header = FALSE,
  check.names = FALSE
)

# Rinomina la prima colonna (sample ID)
colnames(pca)[1] <- "sample_id"


# ------------------------------------------------------------
# 2. Importa il file panel del 1000 Genomes
#    Contiene: sample_id, pop, super_pop, gender
# ------------------------------------------------------------
panel <- read_tsv(
  "/Users/alice/Documents/R_scripts/integrated_call_samples_v3.20130502.ALL.panel",
  col_names = c("sample_id", "pop", "super_pop", "gender")
)


# ------------------------------------------------------------
# 3. Merge PCA + annotazioni popolazione
# ------------------------------------------------------------
pca_annot <- left_join(pca, panel, by = "sample_id")

# Visualizza le prime righe
head(pca_annot)


# ============================================================
# PCA Plot – 1000 Genomes (Chromosome 17)

library(ggplot2)

# ------------------------------------------------------------
# 1. Rinomina le colonne PCA per chiarezza
#    PLINK2 produce: sample_id, PC1, PC2, PC3, ...
# ------------------------------------------------------------
colnames(pca_annot)[2:21] <- paste0("PC", 1:20)

# ------------------------------------------------------------
# 2. Plot PCA (PC1 vs PC2)
# ------------------------------------------------------------
ggplot(pca_annot, aes(x = PC1, y = PC2, color = super_pop)) +
  geom_point(alpha = 0.7, size = 2) +
  labs(
    title = "PCA – 1000 Genomes (Chromosome 17)",
    subtitle = "Colored for super-population",
    x = "PC1",
    y = "PC2",
    color = "Super-pop"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold"),
    legend.position = "right"
  )
