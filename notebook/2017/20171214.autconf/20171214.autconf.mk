all: 
	 autoreconf -vif
	 ./configure --with-guile
	 make -B



clean:
	rm -f Makefile configure  program   program.o config.log  config.status
	rm -rf autom4te.cache aclocal.m4 config.h
	
