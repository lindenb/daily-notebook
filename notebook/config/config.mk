SHELL=/bin/bash
config_dir=$(dir $(lastword $(MAKEFILE_LIST)))
maven_dir?=$(config_dir)../maven
package_dir?=$(config_dir)../packages


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

htslib_dir?=${HOME}/package/htslib

#$(package_dir)/cromwell.jar:
#	mkdir -p $(dir $@)
#	wget -O "$@" "https://github.com/broadinstitute/cromwell/releases/download/31/cromwell-31.jar"
