NXF_HOME=${PWD}/.nextflow
nextflow_exe=${HOME}/packages/NEXTFLOW/nextflow

test02: genes02.nf
	${nextflow_exe}  run -resume $<

test01: alignrf01.nf alignrf01.json
	#cp /home/lindenb/src/jvarkit-git/src/test/resources/rotavirus_rf.fa ./
	${nextflow_exe}  run -resume -params-file alignrf01.json alignrf01.nf
	
clean:
	rm -rf work  .nextflow.log* 
clean-all: clean
	rm -rf "${NXF_HOME}" "${HOME}/.nextflow"
