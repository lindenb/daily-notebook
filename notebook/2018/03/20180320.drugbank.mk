DATABASE?=${HOME}/full_database.xml
all: tmp/Drugbank.class $(DATABASE)
	echo "Scanning the XML drug-bank file $(DATABASE)"
	cat $(DATABASE) | java -cp tmp Drugbank

tmp/Drugbank.class: Drugbank.java tmp/ca/drugbank/ObjectFactory.java
	javac -d tmp -cp tmp Drugbank.java `find tmp/ca/ -type f -name '*.java'`
	

tmp/ca/drugbank/ObjectFactory.java:
	mkdir -p tmp && xjc -d tmp "https://www.drugbank.ca/docs/drugbank.xsd" && touch -c $@

clean:
	rm -rf tmp
