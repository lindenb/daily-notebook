params.rawdata="NO_FILE";

def getLibraryId( prefix ){
  prefix.split("_")[0] 
}

workflow {
	files_channel = Channel.fromFilePairs("${params.rawdata}/*_R{1,2}*.fastq.gz", flat: true, checkExists: true).
		map{prefix, R1, R2 -> tuple(getLibraryId(prefix), R1, R2)}.
		flatMap{libraryId,R1,R2 -> [
			[[libraryId,"R1"],R1],
			[[libraryId,"R2"],R2]
			] }.
		groupTuple()
	
	merge_ch = MERGE(files_channel)
	
	concat_R1_ch = merge_ch.output.filter{K,FASTQ->K[1].equals("R1")}.map{K,FASTQ->[K[0],FASTQ]}
	concat_R2_ch = merge_ch.output.filter{K,FASTQ->K[1].equals("R2")}.map{K,FASTQ->[K[0],FASTQ]}
	
	pair_ch = concat_R1_ch.join(concat_R2_ch)
	
	pair_ch.view()
	}
process MERGE {
tag "${key} ${fastqs}"
input:
	tuple val(key),val(fastqs)
output:
	tuple val(key),path("${key[0]}.${key[1]}.fastq.gz"),emit:output
script:
	def ordered =fastqs.sort{A,B->A.name.compareTo(B.name)}.join(" ")
"""
cat ${ordered} > ${key[0]}.${key[1]}.fastq.gz
"""
}