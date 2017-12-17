all: 
	 autoreconf -vif
	 ./configure --with-guile
	 make -B
	 ./program
	 make -B clean
	 autoreconf -vif
	 ./configure
	 make -B
	 ./program
	 make -B clean	 


clean:
	rm -f Makefile configure  program   program.o config.log  config.status
	rm -rf autom4te.cache aclocal.m4 config.h
	
