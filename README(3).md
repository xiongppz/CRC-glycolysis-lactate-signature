# CRC Glycolysis/Lactate Metabolism Multi-omics Analysis

## Overview

This repository contains the R analysis code accompanying a colorectal cancer (CRC) study of a glycolysis/lactate metabolism-related six-gene prognostic signature, tumor microenvironment features, and single-cell transcriptional heterogeneity.

The main script covers bulk transcriptomics, weighted gene co-expression network analysis (WGCNA), prognostic modeling and validation, immune-related analyses, single-cell RNA-seq, pseudotime analysis, and cell-cell communication analysis.

**Scope:** This is a code repository. Raw datasets and third-party reference resources are not redistributed here. A complete, clean-install, end-to-end reproduction has not yet been verified.

## Repository files

| File | Description |
| --- | --- |
| `CRC_analysis.R` | Main analysis script. |
| `README.md` | Project description, input requirements, and usage notes. |
| `generate_sessionInfo.R` | Original helper script for recording the **current** R session and selected package versions; see the overwrite warning below. |
| `sessionInfo.txt` | Annotated compilation of the two computer environments, **not** the output of one R session. |
| `sessionInfo_macos.txt` | Original macOS `sessionInfo()` output. |
| `sessionInfo_windows.txt` | Original Windows `sessionInfo()` output. |
| `package_versions_macos.csv` | Selected package versions detected in the macOS environment. |
| `package_versions_windows.csv` | Selected package versions detected in the Windows environment. |
| `.gitignore` | Rules for excluding selected local data, generated objects, and temporary files from normal Git tracking. |

The table describes the intended repository contents; check that every listed file has actually been uploaded. The `.gitignore` filename must start with a period.

## Analyses included

The main script contains sections for:

- TCGA-COAD expression preprocessing and differential expression analysis;
- WGCNA, candidate-gene intersection, and functional enrichment analysis;
- univariate Cox regression, LASSO-Cox modeling, and internal validation;
- independent validation using GSE161158;
- clinical Cox regression, model comparison, C-index, time-dependent AUC, Brier score, bootstrap correction, and nomogram analyses;
- ESTIMATE, CIBERSORT, ssGSEA, and related immune microenvironment analyses;
- TCIA immunophenoscore (IPS) and exploratory IMvigor210 analyses;
- GSE221575 single-cell RNA-seq analysis using Seurat, Harmony batch correction, and kBET assessment;
- cell-type annotation, epithelial-cell subclustering, and `AddModuleScore`;
- Monocle 2 pseudotime and CellChat analyses, including GALECTIN, MK, and LAMININ signaling.

## Data sources and external resources

| Resource | Role in this study |
| --- | --- |
| TCGA-COAD | Bulk transcriptomic and clinical analyses. |
| GSE161158 | Independent prognostic validation. |
| GSE221575 | Single-cell RNA-seq analysis. |
| TCIA | Immunophenoscore analysis. |
| IMvigor210 | Exploratory immunotherapy-related analysis. |
| MSigDB | Gene-set resource used as `genesets.v2024.1.Hs.gmt`. |
| GeneCards | Glycolysis-related gene table used as `glycolysis.csv`. |
| DAVID and other external reference files | Enrichment and immune-related analysis inputs. |

Obtain data and reference files from their original providers and comply with applicable access and redistribution terms. Dataset accession numbers and the filenames in `CRC_analysis.R` identify the relevant inputs; this repository does not supply all download or preprocessing steps as a unified workflow.

## Local input organization

Run the script with the project directory as the R working directory. The following is an **illustrative local layout**, not a list of files to upload to GitHub:

```text
CRC-glycolysis-lactate-signature/
├── CRC_analysis.R
├── README.md
├── generate_sessionInfo.R
├── sessionInfo.txt
├── sessionInfo_macos.txt
├── sessionInfo_windows.txt
├── package_versions_macos.csv
├── package_versions_windows.csv
├── .gitignore
├── TCGA/
│   ├── TCGA-COAD.htseq_counts.tsv.gz
│   ├── TCGA-COAD.survival.tsv
│   └── TCGA-COAD.GDC_phenotype.tsv.gz
├── GSE221575/
│   └── [sample-specific 10x count directories]
├── genesets.v2024.1.Hs.gmt
├── glycolysis.csv
└── [additional external inputs and intermediate results]
```

**Path inconsistency requiring attention:** One clinical-analysis section reads `TCGA/TCGA-COAD.GDC_phenotype.tsv.gz`, while a later clinical-model section reads `TCGA-COAD.GDC_phenotype.tsv.gz` from the project root. Reconcile those paths in the script or provide the file at the location expected by the section being run. The example tree above does not resolve that inconsistency.

Other inputs referenced in individual sections include `genes1.rds`, `genes.rds`, `WGCNA/wgcna_gene.rds`, `差异分析/COAD_GSE37182_limma.rds`, DAVID outputs such as `go-bp.txt`, `go-cc.txt`, `go-mf.txt`, and `kegg.txt`, `mmc3.xlsx`, TCIA data, and IMvigor210 data. Some inputs are external resources or prior analysis results; others are intermediate files produced by earlier steps. **This list is not exhaustive.** Consult each section's read/load statements before running it. For example, `all_risk.txt` is generated in the prognostic-model section and read again downstream.

## Software environments: two computers

The study used two R environments. Versions are recorded separately; they should **not** be combined into one fictitious R installation.

| Environment | R version | Operating system reported by R | kBET |
| --- | --- | --- | --- |
| macOS | 4.6.1 | macOS Tahoe 26.5.1 | 0.99.6 |
| Windows | 4.5.0 | Windows 8 x64 (build 9200) | Not detected by the Windows package inventory (`NA`) |

The study author confirmed that the **kBET assessment was performed on the Mac**. The available records do not establish which computer ran every other individual module; no further module-to-computer assignments are claimed here.

Environment records:

- `sessionInfo_macos.txt`: original Mac session record, including kBET 0.99.6.
- `sessionInfo_windows.txt`: original Windows session record; the main study analysis packages were not attached when this particular snapshot was taken.
- `package_versions_macos.csv` and `package_versions_windows.csv`: separately collected lists of selected package versions.
- `sessionInfo.txt`: annotated compilation containing both original records; **it is not a single-session `sessionInfo()` result**.

An `NA` package version means that the inventory script did not detect/load that package in the corresponding environment when run; it must not be replaced with a version taken from the other computer. Consult the environment-specific records for version attribution. Package installation methods and compatibility may differ across R and Bioconductor versions.

### Recording an environment again

Run the appropriate command **on the specified computer and in the relevant R environment**:

On the Mac:

```r
capture.output(sessionInfo(), file = "sessionInfo_macos.txt")
```

On Windows:

```r
capture.output(sessionInfo(), file = "sessionInfo_windows.txt")
```

The supplied `generate_sessionInfo.R` is an **older, single-environment helper**: it writes `sessionInfo.txt` and `package_versions.csv`. **Do not run it unchanged in the repository root**, because it would overwrite the two-computer compilation. To refresh inventories, adapt its output filenames for each computer, retain the resulting records separately, and regenerate the annotated compilation only after checking both records.

## Running the analysis

1. Download or clone this repository.
2. Obtain the required source datasets and external resources from their providers.
3. Organize the inputs according to the filenames and paths used by the relevant script section, resolving the clinical-file path inconsistency described above.
4. Open R/RStudio with the project directory as the working directory.
5. Install or otherwise make available the required packages in a compatible R environment; use the corresponding environment records as a guide.
6. Run and check the relevant sections of `CRC_analysis.R` in their intended order. Retain the necessary intermediate outputs for downstream sections.

For a preliminary syntax check, run:

```r
parse(file = "CRC_analysis.R")
```

A successful syntax check does **not** verify data availability, package compatibility, methodological correctness, or reproduction of reported results. The script has multiple interdependent sections and is not presented as a validated one-command pipeline.

## Reproducibility and sharing limitations

- The repository provides code and environment documentation but not all required input data, reference files, or generated intermediates.
- Certain sections require additional manual data preparation or outputs from earlier analyses.
- Relative paths depend on the project working directory, and at least one clinical input path needs reconciliation as noted above.
- A clean-environment, end-to-end reproduction of the complete study has **not been verified** on the basis of the files provided.
- Before sharing derived tables or model outputs, check dataset terms, redistribution rights, and whether any patient-level information is included.
- `.gitignore` is not a substitute for reviewing files selected for upload, and it does not remove files that have already been committed.

## Citation

If you use this code, please cite the associated manuscript once its full bibliographic details are available.

> Full article citation and DOI: to be added after publication.

## Repository status

This repository accompanies the manuscript and provides the current analysis code and separately documented software environments. Limitations and outstanding input/path requirements are stated above rather than implying that the full workflow has already been independently reproduced.
