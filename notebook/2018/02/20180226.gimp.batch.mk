GIMP=gimp -i  -b -

SCM=01

%.flag : %.scm
	cat $< | $(GIMP)
	touch $@

all: $(addsuffix .flag,$(addprefix 20180226.,$(SCM)))



