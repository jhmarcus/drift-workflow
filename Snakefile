#!python

include: "snakefiles/flash/Snakefile"
include: "snakefiles/admixture/Snakefile"
include: "snakefiles/pca/Snakefile"
include: "snakefiles/coalsim/Snakefile"
include: "snakefiles/admixture_benchmark/Snakefile"

rule none:
    input: 'Snakefile'
    run: print("drift-workflow")
