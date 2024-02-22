##
## https://stackoverflow.com/questions/78041173/
##
SHELL=/bin/bash
CC=gcc
R_VERSION=4.3.2

tests: test1 test2

test1: TMP/RSession.class  TMP/libRSession.so
	echo | R_HOME=${PWD}/TMP/lib/R PATH=$${PATH}:{PWD}/TMP/R-$(R_VERSION)/bin  java -Djava.library.path=${PWD}/TMP:TMP/R-$(R_VERSION)/lib -cp TMP RSession "${PWD}/TMP/R-$(R_VERSION)/bin/R"

test2: standalone.c TMP/R-$(R_VERSION)/lib/libR.so
	$(CC)  `TMP/R-$(R_VERSION)/bin/R CMD config --cppflags` -rpath TMP/R-$(R_VERSION)/lib -L ${PWD}/TMP -o ./a.out $< -lR
	./a.out

TMP/libRSession.so : RSession.c TMP/R-$(R_VERSION)/lib/libR.so TMP/RSession.h
	$(CC)  -ITMP -I$${JAVA_HOME}/include/ -I$${JAVA_HOME}/include/linux \
		-LTMP/R-$(R_VERSION)/lib `TMP/R-$(R_VERSION)/bin/R CMD config --cppflags` -shared -fPIC -o $@  -g $< -lR


TMP/RSession.h : TMP/RSession.class
	touch -c $@

TMP/RSession.class : RSession.java
	mkdir -p TMP
	javac -h TMP -d TMP $<
	touch $@

TMP/R-$(R_VERSION)/lib/libR.so :
	rm -rvf  "TMP/R-$(R_VERSION)" TMP/jeter.tar.gz
	mkdir -p $(dir $@)
	wget -O TMP/jeter.tar.gz "https://pbil.univ-lyon1.fr/CRAN/src/base/R-4/R-$(R_VERSION).tar.gz"
	# --with-blas=no
	# --enable-R-static-lib
	(cd TMP && tar xfz jeter.tar.gz && rm jeter.tar.gz &&  cd R-$(R_VERSION) &&  ./configure --with-pcre1 --enable-R-shlib --with-x=no --prefix=${PWD}/TMP && make && make install)


clean:
	rm -rvf TMP *.so *.o hs_err* ./a.out
