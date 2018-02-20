.PHONY:all

all:snpEff/snpEff.jar Homo_sapiens.GRCh37.87.chromosome.MT.gff3
	java -jar $< build -gff3 XX

snpEff/snpEff.jar:
	rm -f snpEff jeter.zip
	wget -O "jeter.zip" "https://kent.dl.sourceforge.net/project/snpeff/snpEff_latest_core.zip"
	unzip jeter.zip
	rm -f jeter.zip
	touch -c $@

Homo_sapiens.GRCh37.87.chromosome.MT.gff3:
	wget -O - "ftp://ftp.ensembl.org/pub/grch37/update/gff3/homo_sapiens/$@.gz" | gunzip -c > $@
	
