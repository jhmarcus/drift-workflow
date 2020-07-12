# drift-workflow

A workflow for visualizing population structure with empirical Bayes factor analysis

**Authors:** Joe Marcus and Jason Willwerscheid   
**Advisors:** John Novembre, Peter Carbonetto, and Matthew Stephens

## Setup

Add `R` info to `.bashrc`:

```
module load R/3.5.1
export R_HOME=/software/R-3.5.1-el7-x86_64/lib64/R # this is needed for installing rpy2
```

Setup conda env:

```
# setup env
conda create -n=drift python=3 jupyter jupyterlab rstudio numpy pandas scipy matplotlib stdpopsim jupyter-rsession-proxy rpy2 pysam click
pip install snakemake

# for some reason pip was not exported at the time so installed using this path
# /project2/jnovembre/jhmarcus/src/miniconda3/envs/drift/bin/pip install snakemake
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

## Setup altair env

```
conda create -n=alt_e python=3 numpy pandas scipy matplotlib jupyter altair vega_datasets
```
