REF=file(params.referenceFasta)
sampleNames = Channel.from(params.samples).collect { it.name }  .flatten()
alignmentReadPairs = Channel.from(params.samples).
	map{ S ->S.reads.collect{ p -> [ "name":S.name,"index":0,"R1":file(p[0]),"R2":file(p[1]),"bam":"" ] }.eachWithIndex{ it,index -> it.index = index ; it.bam = it.name+"."+index+".sorted.bam" }
	} .flatten()
	



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
	input:
		file genome from REF
		file _bwt from genome_bwt
		file _fai from genome_fai
		set sampleName,idx,fastqR1,fastqR2,outputbam from alignmentReadPairs
	  output:
    		file "${outputbam}" into sorted_bam
	script:
	"""
	\${HOME}/package/bwa/bwa-0.7.4/bwa mem \
		-R '@RG\tID:${sampleName}\tSM:${sampleName}' \
		${genome} \
		${fastqR1} \
		${fastqR2} && \
	\${HOME}/package/samtools/samtools-1.3.1/samtools sort \
		--reference "${genome}" \
		--output-fmt BAM \
		-T "${outputbam}.tmp" \
		-o "${outputbam}" -
	"""
	}

