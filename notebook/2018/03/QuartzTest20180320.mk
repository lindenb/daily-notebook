
all:QuartzTest20180320.class $(quartz_jars)
	java -cp $(call space2colon,$(quartz_jars)):. QuartzTest20180320

include ../../config/config.mk

QuartzTest20180320.class : QuartzTest20180320.java $(quartz_jars)
	javac -cp $(call space2colon,$(quartz_jars)) $<

clean:
	rm -f QuartzTest20180320.class

