# drift-workflow

A workflow for visualizing population structure with empirical Bayes factor analysis

**Authors:** Joe Marcus and Jason Willwerscheid   
**Advisors:** John Novembre, Peter Carbonetto, and Matthew Stephens

## Setup

```
conda create -n=drift_env python=3
conda activate drift_env
conda install -c conda-forge openblas numpy pandas scipy snakemake rpy2 matplotlib cython seaborn stdpopsim
conda install -c bioconda cyvcf2 pysam
conda install jupyter jupyterlab
```

In `R` session:

```
install.packages("devtools")
install.packages("tidyverse")
install.packages("workflowr")
install.packages("mixsqp")
devtools::install_github("stephens999/ashr")
devtools::install_github("willwerscheid/flashier", build_vignettes=FALSE)
install.packages("softImpute")
devtools::install_github("Storeylab/lfa")
devtools::install_github("stephenslab/drift.alpha")
```
