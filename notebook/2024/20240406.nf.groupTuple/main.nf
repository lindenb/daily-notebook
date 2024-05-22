/**

test group tuple with array [] as item

~/src/nextflow/nextflow run main.nf -resume

*/

workflow {
	ch1 = Channel.of(
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample2",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample1",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample2",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample2",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample1",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample1",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample2",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample2",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample1",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample1",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample2",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample3",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")],
			["sample2",file("chunck.vcf.gz"),file("chunck.vcf.gz.tbi")]
		).
		groupTuple().
		map{T->[T[0],T[1].sort(),T[2].sort()]}

	JOIN(ch1)
}


process JOIN {
	tag "${sample}"
	input:
		tuple val(sample),path("dir??/*"),path("dir??/*")
	script:
	"""
	echo ok
	"""
	}
