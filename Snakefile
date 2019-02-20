#!python

include: "snakefiles/flash/Snakefile"
include: "snakefiles/admixture/Snakefile"

rule none:
    input: 'Snakefile'
    run: print("drift-workflow")
