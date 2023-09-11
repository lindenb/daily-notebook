/** parse yaml using nextflow 

nextflow run main.nf --samples test.yaml

*/
params.samples="NO_FILE"

workflow {
	ch = Channel.fromPath(params.samples).
		flatMap(F->{
				def yaml = new org.yaml.snakeyaml.Yaml();
				def map = yaml.load(F);
				return map.samples;
			});
	doIt(ch)
}

process doIt {
tag "${row.biosample_id} = ${row.bam}"
input:
	val(row)
script:
"""
echo "${row.biosample_id} = ${row.bam}"
"""
}