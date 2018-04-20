NXF_HOME=${PWD}/.nextflow

test: nextflow alignrf01.nf alignrf01.json
	#cp /home/lindenb/src/jvarkit-git/src/test/resources/rotavirus_rf.fa ./
	./nextflow  run -resume -params-file alignrf01.json alignrf01.nf
	
nextflow:
	wget -O nextflow "https://get.nextflow.io"
	chmod +x nextflow
	mkdir -p ${NXF_HOME}
clean:
	rm -rf work  .nextflow.log* 
clean-all: clean
	rm -rf nextflow "${NXF_HOME}" "${HOME}/.nextflow"
