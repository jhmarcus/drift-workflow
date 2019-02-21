#!python

include: "snakefiles/flash/Snakefile"
include: "snakefiles/admixture/Snakefile"
include: "snakefiles/coalsim/Snakefile"

rule none:
    input: 'Snakefile'
    run: print("drift-workflow")
