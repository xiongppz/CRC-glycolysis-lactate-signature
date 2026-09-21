# Generate reproducibility information for the GitHub repository
# Run this script in the same R environment used for the final manuscript analyses.

capture.output(
  sessionInfo(),
  file = "sessionInfo.txt"
)

packages_used <- c(
  "tidyverse", "data.table", "dplyr", "tibble", "readr", "tidyr",
  "reshape2", "ggplot2", "ggpubr", "ggsignif", "ggsci", "ggvenn",
  "patchwork", "pheatmap", "limma", "clusterProfiler", "WGCNA",
  "survival", "survminer", "glmnet", "caret", "timeROC", "rms",
  "riskRegression", "Seurat", "harmony", "SingleR", "celldex",
  "monocle", "CellChat", "kBET", "GSVA", "IOBR", "CIBERSORT",
  "estimate", "scRNAtoolVis", "rio"
)

pkg_info <- lapply(packages_used, function(pkg) {
  if (requireNamespace(pkg, quietly = TRUE)) {
    data.frame(
      Package = pkg,
      Version = as.character(utils::packageVersion(pkg)),
      stringsAsFactors = FALSE
    )
  } else {
    data.frame(
      Package = pkg,
      Version = NA_character_,
      stringsAsFactors = FALSE
    )
  }
})

pkg_info <- do.call(rbind, pkg_info)

write.csv(
  pkg_info,
  file = "package_versions.csv",
  row.names = FALSE
)

cat(
  "Generated sessionInfo.txt and package_versions.csv\n"
)
