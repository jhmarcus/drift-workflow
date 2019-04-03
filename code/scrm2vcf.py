import sys

i = 0
chrom = 0
for line in sys.stdin:
    
    # split the line
    lst = line.strip().split(" ")

    # exctract pop info / sample sizes and write vcf header
    if i == 0:
        # number of haploid samples
        n_sam = int(line.split(" ")[1])

        # number of individuals
        n_ind = int(n_sam / 2)

        # write the vcf header
        sys.stdout.write("##fileformat=VCFv4.2\n")
        sys.stdout.write("##source=scrm2vcf\n")
        sys.stdout.write('##FILTER=<ID=PASS,Description="All filters passed">\n')
        sys.stdout.write('##FORMAT=<ID=GT,Number=1,Type=String,Description="Genotype">\n')
        header = "#CHROM\tPOS\tID\tREF\tALT\tQUAL\tFILTER\tINFO\tFORMAT\t"
        for i in range(n_ind):
            header += "scrm_{}\t".format(i+1)
        header += "\n"
        sys.stdout.write(header)

    # tally the chromosome
    if line.startswith("position"):
        chrom += 1
        #assert chrom <= 22, "Cant have more than 22 replicates"

    # write a mutation
    if (len(lst) == n_sam + 2) and (not line.startswith("position")):
        # modified from 
        # https://github.com/popgenmethods/smcpp/blob/master/util/scrm2vcf.py
        pos, time = lst[:2]
        gts = lst[2:]
        cols = [str(chrom), str(int(float(pos))), ".", "A", "C", ".", "PASS", ".", "GT"]
        cols += ["|".join(gt) for gt in zip(gts[::2], gts[1::2])]
        sys.stdout.write("\t".join(cols) + "\n")
    
    i+=1
