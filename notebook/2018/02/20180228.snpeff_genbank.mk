.PHONY:all clean clean1
CHROM4=GAU65924

all: data/rota/snpEffectPredictor.bin
	echo "##fileformat=VCFv4.2" > jeter.vcf
	echo "#CHROM	POS	ID	REF	ALT	QUAL	FILTER	INFO" >> jeter.vcf
	echo "$(CHROM4)	1	.	G	A	.	.	." >> jeter.vcf
	echo "$(CHROM4)	2	.	G	A	.	.	." >> jeter.vcf
	echo "$(CHROM4)	60	.	T	A	.	.	." >> jeter.vcf
	echo "$(CHROM4)	181	.	T	A	.	.	." >> jeter.vcf
	java -jar snpEff/snpEff.jar eff rota jeter.vcf
	rm jeter.vcf

data/rota/snpEffectPredictor.bin : snpEff/snpEff.jar snpEff.config data/rota/genes.gbk
	java -jar $< build -genbank -v rota

snpEff.config:
	echo "rota.genome : rota" > $@
	echo "	rota.chromosomes : ROBVP1 X14057 AY116592 $(CHROM4) ROBNCVP2 ROBMCP Z21639 Z21640 X65940 AY116593 AF188126"  >> $@

snpEff/snpEff.jar:
	rm -f snpEff jeter.zip
	wget -O "jeter.zip" "https://kent.dl.sourceforge.net/project/snpeff/snpEff_latest_core.zip"
	unzip jeter.zip
	rm -f jeter.zip
	touch -c $@

data/rota/genes.gbk:
	mkdir -p $(dir $@)
	wget -O - "https://www.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=nuccore&id=J04346.1&id=X14057.1&id=AY116592.1&id=U65924.1&id=M22308.1&id=K02254.1&id=Z21639.1&id=Z21640.1&id=X65940.1&id=AY116593.1&id=AF188126.1&rettype=gb" |\
		sed -e 's/chromosome="segment 3"/chromosome="$(CHROM4)"/' \
		-e 's/chromosome="7"/chromosome="Z21639"/'  \
		-e 's/chromosome="8"/chromosome="Z21640"/'  > $@

clean1:
	rm -f data/rota/genes.gbk snpEff.config data/rota/snpEffectPredictor.bin
	
clean: clean1
	rm -rf snpEff

	
