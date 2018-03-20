SHELL=/bin/bash
all: Drugbank.java
	rm -rf tmp
	mkdir -p tmp
	xjc -d tmp "https://www.drugbank.ca/docs/drugbank.xsd"
	javac -d tmp -cp tmp Drugbank.java `find tmp/ca/ -type f -name '*.java'`
	cat ${HOME}/database.xml | java -cp tmp Drugbank
