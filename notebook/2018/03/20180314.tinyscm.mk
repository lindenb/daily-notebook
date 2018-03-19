# https://github.com/avbaula/schemer/blob/d8c59df3a680af0c66978946335881fd123fb9f3/examples/embedded.c
test: a.out
	./a.out '(+ 1 1)'
	./a.out '(display "hello\n")'
	./a.out '(< 1 2)'
	./a.out '(> 1 2)'
	./a.out '(+ 0.1 0.0)'
	./a.out '(my-average 1.0 2.0 3.0 4.0 5.0)'

a.out: 20180314.hello.c \
	tinyscheme-1.41/dynload.c \
	tinyscheme-1.41/scheme.c
	gcc -o $@ -g -Wall -DSTANDALONE=0  -DUSE_MATH=1 -DUSE_ASCII_NAMES=0 -I tinyscheme-1.41 $^  -ldl -lm

tinyscheme-1.41/dynload.c tinyscheme-1.41/scheme.c: tinyscheme-1.41/makefile 

tinyscheme-1.41/makefile :
	rm -rf $(dir $@)
	wget -O tinyscheme-1.41.tar.gz "https://downloads.sourceforge.net/project/tinyscheme/tinyscheme/tinyscheme-1.41/tinyscheme-1.41.tar.gz"
	tar xvfz tinyscheme-1.41.tar.gz 
	rm tinyscheme-1.41.tar.gz
	touch -c $@

clean:
	rm -rf tinyscheme-1.41 a.out

