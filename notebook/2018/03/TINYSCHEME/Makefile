all: tinyscheme-1.41/scheme

tinyscheme-1.41/scheme : tinyscheme-1.41/makefile
	(cd $(dir $<) && $(MAKE))

tinyscheme-1.41/makefile:
	rm -rf tinyscheme-1.41
	wget -O tinyscheme-1.41.tar.gz "https://downloads.sourceforge.net/project/tinyscheme/tinyscheme/tinyscheme-1.41/tinyscheme-1.41.tar.gz"
	tar xvfz tinyscheme-1.41.tar.gz
	rm tinyscheme-1.41.tar.gz
	touch -c $@

clean:
	rm -rf tinyscheme-1.41
