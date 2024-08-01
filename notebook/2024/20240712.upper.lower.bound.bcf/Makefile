HTSDIR=../../../../htslib/
CFLAGS=-I$(HTSDIR) -Wall -g
LDFLAGS=-L$(HTSDIR)  -lm -lpthread -lhts -lz -llzma -lbz2

test: a.out ../../../../jvarkit-git/src/test/resources/toy.bcf ../../../../jvarkit-git/src/test/resources/rotavirus_rf.vcf.gz ../../../../jvarkit-git/src/test/resources/toy.bcf
	LD_LIBRARY_PATH=$(HTSDIR) ./a.out $(word 2,$^) $(word 3,$^) $(word 2,$^)

a.out: vcftobed.o
	$(CC) -o $@ $< $(LDFLAGS)

vcftobed.o : vcftobed.c
	$(CC) -c -o $@ $(CFLAGS) $<

clean:
	rm -rf bcftools htslib
