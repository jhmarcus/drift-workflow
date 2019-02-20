#!/bin/bash

source activate drift_e

snakemake \
    -kp \
    --ri \
    -j 65 \
    --max-jobs-per-second 5 \
    --cluster-config cluster.json \
    -c "sbatch \
        --time={cluster.time} \
        --mem={cluster.mem} \
        --nodes={cluster.n} \
        --tasks-per-node={cluster.tasks} \
        --partition=jnovembre \
        --job-name={cluster.name} \
        --mail-user={cluster.email} \
        --mail-type={cluster.emailtype} \
	    --output={cluster.logfile}" \
    $*