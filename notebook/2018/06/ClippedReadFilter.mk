GATKJAR?=${HOME}/package/gatk/3.8.0/GenomeAnalysisTK.jar

test.sample_summary: clippedreadfilters.jar
	java -cp clippedreadfilters.jar:$(GATKJAR) org.broadinstitute.gatk.engine.CommandLineGATK \
		-T DepthOfCoverage \
		-R "${HOME}/src/jvarkit-git/src/test/resources/rotavirus_rf.fa" \
		--out test -I "${HOME}/src/jvarkit-git/src/test/resources/S1.bam"  \
		--omitDepthOutputAtEachBase --omitLocusTable --omitIntervalStatistics \
		--read_filter ClippedRead --minfraction 0.0001


clippedreadfilters.jar : ClippedReadFilter.java
	mkdir -p  org/broadinstitute/gatk/engine/filters
	cp $< org/broadinstitute/gatk/engine/filters
	javac -cp "$(GATKJAR)" org/broadinstitute/gatk/engine/filters/ClippedReadFilter.java
	jar cvf $@ org
	rm -rf org
clean:
	rm -f clippedreadfilters.jar test.sample_statistics  test.sample_summary
