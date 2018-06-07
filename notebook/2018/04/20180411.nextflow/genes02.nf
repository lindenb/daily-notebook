
	
process downloadEnsemblGenes {
	tag "get ensembl"
	echo true
	
	output:
		 file("ensembl.bed") into ensembl_bed
	script:
		"""
cat << __EOF__ | tr -d '\\n' | tr "\\t" " " | tr -s ' ' | tr " " "+" > jeter.query
http://www.ensembl.org/biomart/martservice?query=<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE Query>
<Query  virtualSchemaName = "default" formatter = "TSV" header = "0" uniqueRows = "0" count = "" datasetConfigVersion = "0.6">
	<Dataset name = "hsapiens_gene_ensembl" interface = "default" >
	    <Filter name = "chromosome_name" value = "1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,X,Y"/>
	    <Filter name = "transcript_biotype" value = "protein_coding"/>
		<Attribute name = "chromosome_name" />
		<Attribute name = "start_position" />
		<Attribute name = "end_position" />
		<Attribute name = "ensembl_gene_id" />
		<Attribute name = "ensembl_transcript_id" />
		<Attribute name = "external_gene_name" />
	</Dataset>
</Query>
__EOF__

wget -O "ensembl.bed" `cat jeter.query`
rm jeter.query

		"""
	}
