HTSDIR=../../../../htslib
CFLAGS=-I$(HTSDIR) -I$(dir $(HTSDIR))bcftools -Wall -g
LDFLAGS=-L$(HTSDIR)  -lm -lpthread -lhts -lz -llzma -lbz2

test2: a.out
	LD_LIBRARY_PATH=$(HTSDIR) ./a.out  "http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.chrX.phase3_shapeit2_mvncall_integrated_v1c.20130502.genotypes.vcf.gz" "http://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5c.20130502.sites.vcf.gz"


test: a.out ../../../../jvarkit-git/src/test/resources/toy.bcf ../../../../jvarkit-git/src/test/resources/rotavirus_rf.vcf.gz ../../../../jvarkit-git/src/test/resources/toy.bcf
	LD_LIBRARY_PATH=$(HTSDIR) ./a.out $(word 2,$^) $(word 3,$^) $(word 2,$^)

a.out: vcftobed.o
	$(CC) -o $@ $< $(LDFLAGS)

vcftobed.o : vcftobed.c
	$(CC) -c -o $@ $(CFLAGS) $<

clean:
	rm -rf bcftools htslib
