GIMP=gimp -i  -b -

SCM=01 02

%.flag : %.scm lenna.png
	cat $< | $(GIMP)
	touch $@

all: $(addsuffix .flag,$(addprefix 20180226.,$(SCM)))


lenna.png:
	wget -O $@ "https://upload.wikimedia.org/wikipedia/en/2/24/Lenna.png"
	
clean:
	rm -f lenna.png jeter.xcf

