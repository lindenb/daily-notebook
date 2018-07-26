include ../../config/config.mk
lib.dir=lib


weka_lib  =  \
	$(lib.dir)/com/github/fommil/jniloader/1.1/jniloader-1.1.jar \
	$(lib.dir)/com/github/fommil/netlib/core/1.1.2/core-1.1.2.jar \
	$(lib.dir)/com/github/fommil/netlib/core/1.1/core-1.1.jar \
	$(lib.dir)/com/github/fommil/netlib/native_ref-java/1.1/native_ref-java-1.1.jar \
	$(lib.dir)/com/googlecode/matrix-toolkits-java/mtj/1.0.4/mtj-1.0.4.jar \
	$(lib.dir)/com/googlecode/netlib-java/netlib-java/1.1/netlib-java-1.1.jar \
	$(lib.dir)/net/sourceforge/f2j/arpack_combined_all/0.1/arpack_combined_all-0.1.jar \
	$(lib.dir)/nz/ac/waikato/cms/weka/thirdparty/bounce/0.18/bounce-0.18.jar \
	$(lib.dir)/nz/ac/waikato/cms/weka/thirdparty/java-cup-11b-runtime/2015.03.26/java-cup-11b-runtime-2015.03.26.jar \
	$(lib.dir)/nz/ac/waikato/cms/weka/thirdparty/java-cup-11b/2015.03.26/java-cup-11b-2015.03.26.jar \
	$(lib.dir)/nz/ac/waikato/cms/weka/weka-stable/3.8.2/weka-stable-3.8.2.jar \
	$(lib.dir)/org/projectlombok/lombok/1.18.0/lombok-1.18.0.jar \
	$(lib.dir)/org/springframework/spring-beans/5.0.7.RELEASE/spring-beans-5.0.7.RELEASE.jar \
	$(lib.dir)/org/springframework/spring-core/5.0.7.RELEASE/spring-core-5.0.7.RELEASE.jar \
	$(lib.dir)/org/springframework/spring-jcl/5.0.7.RELEASE/spring-jcl-5.0.7.RELEASE.jar \
	$(lib.dir)/org/springframework/spring-context/5.0.7.RELEASE/spring-context-5.0.7.RELEASE.jar \
		$(lib.dir)/org/springframework/spring-expression/5.0.7.RELEASE/spring-expression-5.0.7.RELEASE.jar

all: Weka01.class config01.xml iris.arff
	java -cp "$(call space2colon,$(weka_lib)):." $(basename $<) config01.xml iris.arff

Weka01.class: Weka01.java $(weka_lib)
	javac -cp "$(call space2colon,$(weka_lib))" $<

iris.arff  : 
	wget -O $@ "http://storm.cis.fordham.edu/~gweiss/data-mining/weka-data/$@"

clean:
	rm -f *.class
	rm -fr lib



all_maven_jars = $(sort  ${weka_lib})
${all_maven_jars} : 
	mkdir -p $(dir $@) && wget -O "$@" "http://central.maven.org/maven2/$(patsubst ${lib.dir}/%,%,$@)"

