REF=file(params.referenceFasta)
sampleNames = Channel.from(params.samples).collect { it.name }  .flatten()
alignmentReadPairs = Channel.from(params.samples.
	collect{ S ->S.reads.
			collect{ p -> [ "sample":S.name,"index":-1,"R1":file(p[0]),"R2":file(p[1]) ] }.
			eachWithIndex{ it,index -> it.index=index }
	}.flatten())




process indexFaidx {
	input:
		file genome from REF
	output:
		file "${genome}.fai" into genome_fai
	script:
	 
	  """
	  samtools faidx ${genome}
	  """
}

process indexPicard {
	input:
		file genome from REF
	output:
		file "${genome.baseName}.dict" into genome_dict
	script:
	 
	  """
	  java -jar \${HOME}/package/picard-tools-2.1.1/picard.jar \
	  	CreateSequenceDictionary \
	  	R= $genome \
	  	O= ${genome.baseName}.dict
	  """
}

process indexBWA {
	input:
		file genome from REF
	output:
		file "${genome}.*" into genome_bwt
	script:
	"""
	\${HOME}/package/bwa/bwa-0.7.4/bwa index ${genome}
	"""
	}

process mapSamples {
	 tag "bwa $sampleName ${idx}"
	 echo true

	input:
		file genome from REF
		file _bwt from genome_bwt
		file _fai from genome_fai
		set sampleName, idx, file(fastqR1), file(fastqR2)  from alignmentReadPairs
	  output:
    		set sampleName, file("${sampleName}.${idx}.sorted.bam") into sorted_bam
	script:
	"""
	\${HOME}/package/bwa/bwa-0.7.4/bwa mem \\
		-R '@RG\tID:${sampleName}\tSM:${sampleName}' \\
		${genome} \\
		${fastqR1} \\
		${fastqR2} |\\
	\${HOME}/package/samtools/samtools-1.3.1/samtools sort \\
		--reference "${genome}" \\
		--output-fmt BAM \\
		-T "${sampleName}.${idx}.sorted.tmp" \\
		-o "${sampleName}.${idx}.sorted.bam" -
	"""
	}
	
// https://github.com/senthil10/NGI-ExoSeq/blob/63719b722cb3ebe6f966f181ebbe77394f431337/exoseq.nf
sorted_bam
    .groupTuple()
    .set{ lanes_sorted_bam_group }

process mergeSamples {   
	input:
		 set val(sample), file(sample_bam) from lanes_sorted_bam_group
	output:
		set val(sample), file("${sample}_merged.bam") into samples_merged
	script:
	"""
		echo "${sample}  ${sample_bam.flatten{"INPUT=$it"}.join(' ')}" > ${sample}_merged.bam
	"""
	}



process indexBam {   
	tag "index ${bam} for sample ${sample}"
	input:
		set val(sample), file(bam) from samples_merged
	output:
		set val(sample), file(bam),file("${bam}.bai") into samples_merged_bai
	script:
	"""
		touch "${bam}.bai"
	"""
	}


samples_merged_bai
    .collect { it[1] }
    .flatten()
    .toList()
    .set{ bams_for_list }
   

process bamList {
	tag "call ${bam} for sample ${sample}"
	echo true
	
	input:
		file bam from bams_for_list
	output:
		 file("bam.list") into bam_list
	script:
		"""
		echo "${bam}" > "bam.list"
		"""
	}
	
process callVariants {
	tag "call ${bam} for sample ${sample}"
	echo true
	
	input:
		file genome from REF
		file _fai from genome_fai
		file bam_list from bam_list
	output:
		 file("raw.vcf") into vcf
	script:
		"""
		echo "${bam_list}" > "raw.vcf"
		"""
	}
