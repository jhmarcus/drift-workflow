#!/bin/sh
# properties = {"type": "single", "rule": "run_flash_greedy", "local": false, "input": ["data/datasets/hoa_global_ld/HumanOriginsPublic2068_maf_geno_ldprune.bed"], "output": ["output/flash_greedy/hoa_global_ld/HumanOriginsPublic2068_maf_geno_ldprune.rds"], "wildcards": {"dataset": "hoa_global_ld", "prefix": "HumanOriginsPublic2068_maf_geno_ldprune"}, "params": {"bed": "data/datasets/hoa_global_ld/HumanOriginsPublic2068_maf_geno_ldprune"}, "log": [], "threads": 1, "resources": {}, "jobid": 1, "cluster": {"time": "36:00:00", "mem": "40G", "n": 1, "tasks": 1, "name": "run_flash_greedy-dataset=hoa_global_ld,prefix=HumanOriginsPublic2068_maf_geno_ldprune", "logfile": "output/log/snake-run_flash_greedy-dataset=hoa_global_ld,prefix=HumanOriginsPublic2068_maf_geno_ldprune-%j.out", "email": "jhmarcus@uchicago.edu", "emailtype": "ALL"}}
cd /project/jnovembre/jhmarcus/drift-workflow && \
/project/jnovembre/jhmarcus/src/miniconda3/envs/drift_e/bin/python3.6 \
-m snakemake output/flash_greedy/hoa_global_ld/HumanOriginsPublic2068_maf_geno_ldprune.rds --snakefile /project/jnovembre/jhmarcus/drift-workflow/Snakefile \
--force -j --keep-target-files --keep-remote \
--wait-for-files /project/jnovembre/jhmarcus/drift-workflow/.snakemake/tmp.pwbtd3cg data/datasets/hoa_global_ld/HumanOriginsPublic2068_maf_geno_ldprune.bed --latency-wait 5 \
 --attempt 1 --force-use-threads \
--wrapper-prefix https://bitbucket.org/snakemake/snakemake-wrappers/raw/ \
  -p --allowed-rules run_flash_greedy --nocolor --notemp --no-hooks --nolock \
--mode 2  && touch "/project/jnovembre/jhmarcus/drift-workflow/.snakemake/tmp.pwbtd3cg/1.jobfinished" || (touch "/project/jnovembre/jhmarcus/drift-workflow/.snakemake/tmp.pwbtd3cg/1.jobfailed"; exit 1)

