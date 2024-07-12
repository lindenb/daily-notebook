HTSDIR=../../../../htslib/
CFLAGS=-I$(HTSDIR) -Wall -g
LDFLAGS=-L$(HTSDIR)  -lm -lpthread -lhts -lz -llzma -lbz2

test: a.out ../../../../jvarkit-git/src/test/resources/rotavirus_rf.vcf.gz
	LD_LIBRARY_PATH=$(HTSDIR) ./a.out $(word 2,$^)

a.out: vcf2bed.o
	$(CC) -o $@ $< $(LDFLAGS)

vcf2bed.o : vcf2bed.c
	$(CC) -c -o $@ $(CFLAGS) $<

clean:
	rm -rf bcftools htslib
