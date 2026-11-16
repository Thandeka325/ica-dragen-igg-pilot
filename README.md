# ICA DRAGEN Iterative gVCF Genotyper (IGG) Pilot

## 1. Overview

This repository contains the scripts, input files, and supporting metadata prepared for the evaluation of the **DRAGEN Iterative gVCF Genotyper (IGG)** workflow on **Illumina Connected Analytics (ICA)**.

The pilot used genomic variant call files (gVCFs) from the **1000 Genomes Project**, generated using DRAGEN v4.4.7, to evaluate joint genotyping and iterative cohort expansion.

The evaluation was performed using **DRAGEN IGG v2.2.3** on ICA.

The objectives were to:

- Prepare the input files and metadata required for DRAGEN IGG.
- Execute joint genotyping on an initial cohort of 100 samples.
- Evaluate the N+1 iterative genotyping approach by introducing an additional batch of 100 samples.
- Assess workflow execution, generated outputs, and ICA computational resource consumption.

The initial 100-sample workflow completed successfully through all five IGG processing stages. The subsequent 200-sample iterative evaluation completed the aggregation stages but could not proceed through the remaining stages because the available ICA credits (BIC) were exhausted.

## 2. Repository Contents

The repository is organised into directories containing the scripts and supporting files used to prepare and execute the pilot.

### `Scripts/` — Input and Metadata Generation

The `Scripts/` directory contains the custom scripts developed to generate and organise the input files required by DRAGEN IGG.

These scripts were used for:

- Selecting and organising samples into batches.
- Generating batch-specific gVCF manifests.
- Preparing sample gender information in the required format.
- Generating version-specific metadata for iterative cohort expansion.

The scripts support the preparation of input files for the initial 100-sample cohort and subsequent cohort versions.

**These are data-preparation scripts, not the scripts responsible for submitting the IGG workflow to ICA.**

### `metadata/` — Source Sample Metadata

The `metadata/` directory contains the 1000 Genomes sample gender information used during input preparation.

This information provides the sample identifiers and associated sex metadata required to generate the gender files supplied to DRAGEN IGG.

The metadata was used to associate each selected sample with its corresponding sex information and to generate the version-specific gender files.

The gender metadata follows the PLINK-compatible sex encoding convention:

| Code | Description |
|---|---|
| 1 | Male |
| 2 | Female |
| 0 | Unknown |

The original sample identifiers are preserved to maintain consistency between the gVCF manifests and the gender metadata.

### `Project data/` — Prepared IGG Input Files

The `Project data/` directory contains the project-specific files prepared for the DRAGEN IGG pilot.

These include:

**Batch gVCF manifests**

Each batch contains a list of gVCF inputs associated with the selected samples. These manifests identify the genomic data to be processed by the workflow.

The pilot was organised into three batches:

| Batch | Samples | Status |
|---|---:|---|
| Batch 1 | 100 | Completed |
| Batch 2 | 100 | Aggregation completed as part of Version 2 |
| Batch 3 | 100 | Prepared but not executed |

**Gender metadata**

The version-specific gender files contain the sample identifiers and corresponding sex information for the cumulative cohort.

The files follow the structure:

`#FID    IID    SEX`

Each version includes the gender metadata for all samples participating in that cohort version.

**Version metadata**

The version files identify the batches included in each iteration of the workflow.

| Version | Included batches | Total samples |
|---|---|---:|
| Version 1 | Batch 1 | 100 |
| Version 2 | Batches 1 and 2 | 200 |
| Version 3 | Batches 1, 2 and 3 | 300 |

Version 3 was prepared for potential subsequent processing but was not executed during this pilot.

**Project configuration**

The project-data directory also contains updated project-specific setup files used during input preparation.

The ICA project configuration is generated during the workflow setup using the Illumina-provided `1.config.sh` script. The original environment-specific configuration, including authentication credentials, is not intended for publication.

Any configuration files included in this repository must have credentials and other sensitive values removed.

## 3. Software and Input Data

| Component | Details |
|---|---|
| Workflow | DRAGEN Iterative gVCF Genotyper (IGG) |
| IGG version | 2.2.3 |
| Execution platform | Illumina Connected Analytics (ICA) |
| ICA region | EU Frankfurt |
| Input dataset | 1000 Genomes Project |
| Input format | DRAGEN-generated gVCF |
| DRAGEN input generation version | 4.4.7 |
| Reference genome | GRCh38 / hg38-alt_masked |
| Workflow interface | Illumina PopGen CLI |

The PopGen CLI is used to configure and interact with the IGG workflow on ICA. Its software version is independent of the IGG pipeline version.

## 4. IGG Workflow Execution

The DRAGEN IGG workflow consists of five main processing stages.

<img width="1230" height="1278" alt="ICA DRAGEN IGG Workflow Infographic" src="https://github.com/user-attachments/assets/6c115d9b-62fb-49ef-8b4e-f79b714342c0" />

### Step 1: Aggregate gVCF

Aggregates the input gVCFs at the shard level, preparing the cohort data for downstream joint genotyping.

For Version 1, the workflow processed Batch 1 using 102 shards.

**Version 1 result:** 102 successful analyses.

### Step 2: Aggregate Census

Processes the aggregated gVCF information to generate census data and identify the subshards required for downstream processing.

**Version 1 result:** 102 successful analyses.

Following this stage, the Illumina-provided subshard collection utility was used to collect the generated subshard statistics.

For Version 1, 451 subshards were identified.

### Step 3: Generate mSVCF

Generates multi-sample variant call files from the aggregated cohort data using the shard and subshard information.

This stage also produces supporting intermediate files for downstream processing.

**Version 1 result:** 451 successful analyses.

### Step 4: Concatenate mSVCF

Combines the generated mSVCF data into chromosome-level outputs.

The stage was executed for chromosome workflow identifiers 1–26.

Outputs include chromosome-level VCF files, sites-only VCFs, reduced VCFs, and PGEN-related files.

**Version 1 result:** 26 successful analyses.

### Step 5: Annotate Variants

Performs variant annotation on the chromosome-level outputs.

The generated files include annotated VCFs and associated annotation information.

**Version 1 result:** 26 successful analyses.

### Version 1 execution summary

| Stage | Successful analyses |
|---|---:|
| Aggregate gVCF | 102 |
| Aggregate Census | 102 |
| Generate mSVCF | 451 |
| Concatenate mSVCF | 26 |
| Annotate Variants | 26 |
| **Total** | **707** |

All five processing stages completed successfully for the initial 100-sample cohort.

## 5. Iterative Genotyping: N+1 Evaluation

After completing the initial 100-sample workflow, an additional batch of 100 gVCFs was introduced to evaluate the iterative genotyping approach.

Version 2 therefore represented a cumulative cohort of 200 samples.

The following stages completed successfully:

| Stage | Successful analyses |
|---|---:|
| Aggregate gVCF | 102 |
| Aggregate Census | 102 |
| **Total** | **204** |

The aggregation process identified 453 subshards for Version 2.

The remaining stages were not executed because the available ICA BIC credits were exhausted.

Consequently, although the aggregation stages successfully processed the expanded cohort, the pilot did not complete an end-to-end validation of joint genotyping for all 200 samples.

## 6. Generated Outputs

The completed Version 1 workflow generated chromosome-level outputs stored within the ICA project.

The output directories included:

- `full-vcf/` — Full chromosome-level VCF files and sites-only VCFs.
- `postproc-vcf/` — Post-processed and reduced VCF outputs.
- `postproc-pgen/` — PGEN-related outputs.
- `full-anno/` — Annotated VCF files and annotation information.

These outputs were generated within the ICA environment and are not included in this repository.

The repository focuses on the scripts and metadata required to prepare the workflow inputs.

## 7. Workflow Submission and ICA Scripts

**The scripts used to configure, upload, submit, and monitor the DRAGEN IGG workflow are provided by Illumina as part of the PopGen CLI demo package.**

These scripts were not developed as part of this pilot and are therefore not reproduced in this repository.

The Illumina demo package includes:

| Script | Purpose |
|---|---|
| `1.config.sh` | Generates and prepares the ICA project configuration |
| `2.upload.sh` | Uploads the required input files to ICA |
| `3.submit.sh` | Submits the IGG workflow stages for execution |
| `poll.sh` | Monitors submitted analyses and their execution status |

The demo package also contains supporting project-data files and documentation.

The submission scripts were used alongside the project-specific batch, gender, and version metadata prepared during this pilot.

The PopGen CLI and its accompanying demo files are distributed through the Illumina ICA release project.

Users wishing to reproduce the workflow should obtain the relevant PopGen CLI release and refer to the Illumina-provided `README.dragen-igg.md` for the complete configuration, upload, submission, and monitoring procedures.

## 8. Reproducibility

To reproduce the input-preparation process:

1. Obtain the relevant 1000 Genomes DRAGEN-generated gVCF data and corresponding sample gender metadata.
2. Use the scripts in `Scripts/` to prepare sample batches and gVCF manifests.
3. Generate the version-specific gender and batch metadata.
4. Review the generated files in `Project data/` to understand the expected input organisation.
5. Obtain the PopGen CLI and DRAGEN IGG demo scripts from Illumina.
6. Configure an ICA project and generate the required local configuration files.
7. Upload the prepared inputs and execute the workflow using the Illumina-provided submission scripts.

The sample selection, input paths, metadata format, software versions, and ICA project settings should be checked before attempting reproduction in a different environment.

Execution on ICA requires appropriate platform access, authentication, and computational credits.

## 9. Limitations

The initial 100-sample cohort was successfully processed through all five IGG stages.

The N+1 evaluation was limited to the first two stages because of insufficient ICA computational credits.

Accordingly, the pilot confirms successful end-to-end execution for the initial cohort and successful aggregation of the expanded cohort, but it does not establish successful completion of all downstream stages for the 200-sample cohort.

## 10. References

- [Illumina Connected Analytics documentation](https://help.ica.illumina.com/)
- [ICA CLI installation](https://help.ica.illumina.com/command-line-interface/cli-installation)
- [ICA CLI authentication](https://help.ica.illumina.com/command-line-interface/cli-authentication)
- [ICA API key generation](https://help.ica.illumina.com/get-started/gs-getstarted#generate-an-api-key)
- [1000 Genomes Project](https://www.internationalgenome.org/)

The Illumina PopGen CLI demo package and `README.dragen-igg.md` should be consulted for the official DRAGEN IGG submission procedures.

---

**Repository scope:** This repository documents the input preparation, metadata organisation, and execution outcomes of the ICA DRAGEN IGG pilot. The workflow submission utilities are provided by Illumina and are not custom implementations.
