params.inputdir="/home/lindenb/src/jvarkit-git/src/test"

process collectFiles {
	output:
		file("config.tsv") into configFile
	
	script:
	
	"""
	find "${params.inputdir}" -type f -name "*.fastq.gz" |\\
		grep -E '_R1_[0-9]*.fastq.gz' |\\
		sort |\\
		awk -F '/' '{R1=\$0;R2=\$0;L="Lane1";split(\$NF,S,/_/);gsub(/_R1_/,"_R2_",R2);printf("%s\\t%s\\t%s\\t%s\\t%s\\n",S[1],NR,L,R1,R2);}'  > config.tsv
	"""
	}


process mapBwa {
	input:
		set sample,id,lane,R1,R2 from configFile.splitCsv(header: false, sep:'\t' )
	output:
		set sample,file("${sample}.${id}.sorted.bam") into mapped_fastqs
	script:
	"""
		${HOME}/packages/bwa/bwa mem -R '@RG\\tID:${sample}_${lane}\\tSM:${sample}\\tPU:${lane}\\tCN:Nantes' ${HOME}/src/jvarkit/src/test/resources/rotavirus_rf.fa "${R1}" "${R2}" |\\
		${HOME}/packages/samtools/samtools sort -o "${sample}.${id}.sorted.bam" -T "${sample}.${id}" -
	"""
	}

process mergeBam {
	input:
		set sample,bams from mapped_fastqs.groupTuple(by:0)
	output:
		set sample,file("${sample}.rmdup.bam") into merged
	script:
	"""
cat << __EOF__ > bam.list
${bams.join("\n")}
__EOF__

sed 's/^/I=/' bam.list > args.txt

cat << __EOF__ >> args.txt
O=${sample}.merged.bam
SO=coordinate
AS=true
CO=Hello world
VALIDATION_STRINGENCY=LENIENT
__EOF__

java -jar  /home/lindenb/src/picard/build/libs/picard.jar MergeSamFiles OPTIONS_FILE=args.txt

java -jar  /home/lindenb/src/picard/build/libs/picard.jar MarkDuplicates VALIDATION_STRINGENCY=LENIENT  AS=true METRICS_FILE=${sample}.rmdup.metrics I=${sample}.merged.bam O=${sample}.rmdup.bam 

rm bam.list args.txt ${sample}.merged.bam
	
	"""
	}




