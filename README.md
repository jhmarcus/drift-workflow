# drift-workflow

A workflow for visualizing population structure with empirical Bayes factor analysis

**Authors:** Joe Marcus and Jason Willwerscheid   
**Advisors:** John Novembre, Peter Carbonetto, and Matthew Stephens

## Setup

```
conda create -n=drift_e python=3
source activate drift_e
conda install numpy pandas scipy snakemake rpy2 matplotlib cython seaborn
conda install -c bioconda cyvcf2 pysam
conda install jupyter jupyterlab
conda install -c conda-forge stdpopsim
```

In `R` session:

```
library(devtools)
install.packages("tidyverse")
devtools::install_github('jdblischak/workflowr')
devtools::install_github("stephenslab/ebnm", ref = "regular-normal")
devtools::install_github("stephens999/ashr")
devtools::install_github("willwerscheid/flashier", build_vignettes = TRUE)
install.packages("softImpute")
devtools::install_github("Storeylab/lfa")
```
