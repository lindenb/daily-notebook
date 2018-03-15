CC=g++
all:htslib/tabix bcftools/bcftools


	
bcftools/bcftools: bcftools/Makefile htslib/tabix
	(cd bcftools && make)	
	
bcftools/Makefile: 
	rm -rf bcftools
	wget -O "1.7.tar.gz" "https://github.com/samtools/bcftools/archive/1.7.tar.gz"
	tar xvfz 1.7.tar.gz
	mv bcftools-1.7 bcftools
	touch -c $@
	
htslib/tabix: htslib/Makefile
	(cd htslib && $(MAKE))

htslib/Makefile:
	rm -rf htslib
	wget -O "1.7.tar.gz" "https://github.com/samtools/htslib/archive/1.7.tar.gz"
	tar xvfz 1.7.tar.gz
	mv htslib-1.7 htslib
	(cd htslib && $(MAKE))
	touch -c $@

clean: 
	rm -rf bcftools htslib
