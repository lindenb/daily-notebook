NEXTFLOW?=${HOME}/src/nextflow/nextflow

all: main.nf jeter1.csv jeter2.csv
	$(NEXTFLOW) run main.nf --f1 jeter1.csv --f2 jeter2.csv

jeter1.csv:
	echo "sample,age" > $@
	echo "S1,20" >> $@
	echo "S2,30" >> $@
	echo "S3,40" >> $@

jeter2.csv:
	echo "sample,birth" > $@
	echo "S1,1980" >> $@
	echo "S3,1990" >> $@
	echo "S5,1998" >> $@


clean:
	rm -rf work jeter1.csv jeter2.csv .nextflo*


