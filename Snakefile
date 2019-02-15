#!python

include: "snakefiles/flash/Snakefile"

rule none:
    input: 'Snakefile'
    run: print("drift-workflow")
