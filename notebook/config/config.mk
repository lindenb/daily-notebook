SHELL=/bin/bash
config_dir=$(dir $(lastword $(MAKEFILE_LIST)))
maven_dir?=$(config_dir)../maven


ifneq ($(realpath $(config_dir)local.mk),)
include $(realpath $(config_dir)local.mk)
endif


EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

define CRLF


endef


define space2colon
$(subst $(SPACE),:,$(1))
endef

quartz_jars=$(addprefix $(maven_dir)/quartz-2.2.3/lib/,$(addsuffix .jar,c3p0-0.9.1.1 slf4j-log4j12-1.7.7 quartz-2.2.3 slf4j-api-1.7.7 log4j-1.2.16 quartz-jobs-2.2.3 quartz-2.2.3)) 


$(addprefix $(maven_dir)/quartz-2.2.3/lib/,$(addsuffix .jar,c3p0-0.9.1.1 slf4j-log4j12-1.7.7 quartz-2.2.3 slf4j-api-1.7.7 log4j-1.2.16 quartz-jobs-2.2.3)) : $(maven_dir)/quartz-2.2.3/lib/quartz-2.2.3.jar
	touch -c $@

$(maven_dir)/quartz-2.2.3/lib/quartz-2.2.3.jar :
	rm -rf "$(maven_dir)/quartz-2.2.3"
	mkdir -p "$(maven_dir)"
	wget -O "$(maven_dir)/jeter.tar.gz" "http://d2zwv9pap9ylyd.cloudfront.net/quartz-2.2.3-distribution.tar.gz"
	(cd "$(maven_dir)" && tar xvfz jeter.tar.gz && rm jeter.tar.gz)
	touch -c $@

htslib_dir?=${HOME}/package/htslib
