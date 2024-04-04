SHELL=/bin/bash
OUTDIR=TMP
BUILD=GRCh38

all: $(OUTDIR)/database.rdf query.01.sparql
	${HOME}/packages/apache-jena-4.8.0/bin/arq --data=$< --query=query.01.sparql


$(OUTDIR)/database.rdf: $(OUTDIR)/go.rdf $(OUTDIR)/gtf.rdf
	mkdir -p $(dir $@)
	echo '<?xml version="1.0" encoding="UTF-8"?><rdf:RDF xmlns:bio="https://www.biostars.org/#"   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"  xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" xml:base="https://www.biostars.org/">' > $@
	cat $^ >> $@
	echo "</rdf:RDF>" >> $@


$(OUTDIR)/go.rdf:
	mkdir -p $(dir $@)
	wget -O - "https://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2go.gz" | gunzip -c |\
		awk -F '\t' '$$1==9606' | cut -f 2,3,6 | sort -T $(dir $@) -t $$'\t' -k1,1 > $(addsuffix .tmp1,$@)
	wget -O - "https://ftp.ncbi.nlm.nih.gov/gene/DATA/gene2ensembl.gz" | gunzip -c |\
		awk -F '\t' '$$1==9606' | cut -f 2,3 |  sort -T $(dir $@) -t $$'\t' -k1,1 > $(addsuffix .tmp2,$@)
	join -t $$'\t' -1 1 -2 1   $(addsuffix .tmp1,$@)  $(addsuffix .tmp2,$@) >  $(addsuffix .tmp3,$@)
	cut -f 2,3  $(addsuffix .tmp3,$@)  |  sort -T $(dir $@) | uniq |\
		awk -F '\t' '{GO=$$1;gsub(/:/,"_",GO); printf("<bio:Term rdf:about=\"%s\"><bio:go_id>%s</bio:go_id><rdfs:label>%s</rdfs:label></bio:Term>\n",GO,$$1,$$2);}' >> $@
	cut -f 2,4  $(addsuffix .tmp3,$@)  | awk -F '\t' '{GO=$$1;gsub(/:/,"_",GO); printf("<rdf:Description rdf:about=\"%s\"><bio:has_go_term rdf:resource=\"%s\"/></rdf:Description>\n",$$2,GO);}' >> $@
	rm  $(addsuffix .tmp1,$@)  $(addsuffix .tmp2,$@)  $(addsuffix .tmp3,$@)


$(OUTDIR)/gtf.rdf :  gtf2rdf.awk
	mkdir -p $(dir $@)
	wget -O - "https://ftp.ensembl.org/pub/release-111/gtf/homo_sapiens/Homo_sapiens.$(BUILD).111.chr.gtf.gz" | gunzip -c  |\
		awk '($$1=="1")' |\
		awk -vBUILD=$(BUILD) -f gtf2rdf.awk > $@

clean:
	rm -rfv $(OUTDIR)
