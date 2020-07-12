import sys
import pysam
import click


@click.command()
@click.option('--sites', help="path to 1kg sites vcf")
def sites_to_aa(sites):
  """Converts 1kg sites vcf to a tsv with three columns 
  the rsid, ancestral allele, and derived allele
  """
  vcf = pysam.VariantFile(sites)
  for rec in vcf.fetch():
    chrom = rec.chrom
    pos = rec.pos
    chrom_pos = "{}:{}".format(chrom, pos)
    rsid = rec.id
    ref_allele = rec.ref
    alt_allele = rec.alts[0]
    # check if ancestral allele is in record
    if "AA" in list(rec.info):
      ancestral_allele = rec.info['AA'][0].upper()
      # check if ancestral allelle is a valid base and 
      # is the ref or alt base double mutation?
      if ((ancestral_allele in ["A", "C", "T", "G"]) and
          (ancestral_allele in [ref_allele, alt_allele])):
        # check if ancestral allele is reference allele
        if ref_allele == ancestral_allele:
          derived_allele = alt_allele
        else:
          derived_allele = ref_allele
      else:
        continue
    else:
      continue

    # write to stdout 
    sys.stdout.write("{}\t{}\t{}\n".format(chrom_pos, derived_allele, ancestral_allele))

if __name__ == "__main__":
  sites_to_aa()
