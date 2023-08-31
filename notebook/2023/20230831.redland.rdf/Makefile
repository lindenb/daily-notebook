#
# Script to install roqet , SPARQL engine in C
#
SHELL=/bin/bash
DIST=${PWD}/release
RAPTOR_VERSION=2.0.16
RASQUAL_VERSION=0.9.33

test: $(DIST)/bin/roqet
	wget -O jeter.rdf "https://raw.githubusercontent.com/BruceMWhealton/Gedcom-RDF/master/Disney.rdf"
	$(DIST)/bin/roqet -e 'SELECT * WHERE { ?s ?p ?o }' --data jeter.rdf --results rdfxml
	rm jeter.rdf

$(DIST)/bin/roqet : rasqal-$(RASQUAL_VERSION)/Makefile
	cd $(dir $<) && LD_LIBRARY_PATH=$(DIST)/lib make && make install

rasqal-$(RASQUAL_VERSION)/Makefile: rasqal-$(RASQUAL_VERSION)/configure
	mkdir -p $(DIST)
	cd $(dir $@) && PKG_CONFIG_PATH=$(DIST)/lib/pkgconfig RAPTOR2_CFLAGS=-I$(DIST)/include/raptor2 LDFLAGS=-L$(DIST)/lib  ./configure --prefix=$(DIST)

rasqal-$(RASQUAL_VERSION)/configure: $(DIST)/bin/rapper
	wget -O jeter.tgz "http://download.librdf.org/source/rasqal-$(RASQUAL_VERSION).tar.gz"
	tar xvfz jeter.tgz
	rm jeter.tgz
	touch -c $@

$(DIST)/bin/rapper :raptor2-$(RAPTOR_VERSION)/Makefile
	cd $(dir $<) && make && make install

raptor2-$(RAPTOR_VERSION)/Makefile: raptor2-$(RAPTOR_VERSION)/configure
	mkdir -p $(DIST)
	cd $(dir $@) && ./configure --prefix=$(DIST)

raptor2-$(RAPTOR_VERSION)/configure:
	wget -O jeter.tgz "http://download.librdf.org/source/raptor2-$(RAPTOR_VERSION).tar.gz"
	tar xvfz jeter.tgz
	rm jeter.tgz
	touch -c $@

clean:
	rm -rf raptor2-$(RAPTOR_VERSION) rasqal-$(RASQUAL_VERSION) "$(DIST)" jeter.rdf jeter.tgz