all: 
	 autoreconf -vif
	 ./configure --with-guile
	 make



clean:
	rm -f Makefile configure  program  program.c  program.o config.log  config.status
	rm -rf autom4te.cache aclocal.m4 config.h
	
