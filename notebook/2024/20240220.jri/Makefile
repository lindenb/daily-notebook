test: TMP/REngineTest.class TMP/JRIEngine.jar
	mkdir -p TMP
	R_HOME=/usr/bin java  -Djava.library.path=/usr/lib:TMP/rJava/jri -cp $(word 2,$^):TMP REngineTest

TMP/REngineTest.class: REngineTest.java TMP/JRIEngine.jar
	mkdir -p TMP
	javac -d TMP -cp $(word 2,$^) $<


TMP/JRIEngine.jar : TMP/rJava/README.md TMP/REngine/README.md
	mkdir -p TMP
	javac -d TMP -sourcepath ./TMP/rJava/jri:./TMP/REngine:./TMP/REngine/JRI ./TMP/REngine/org/rosuda/REngine/REngine.java ./TMP/REngine/JRI/org/rosuda/REngine/JRI/JRIEngine.java
	## ./TMP/REngine/org/rosuda/REngine/REngine.java
	jar cvf $@ -C TMP org



TMP/org: ./REngine/JRI/JRIEngine.java
	mkdir -p TMP
	javac -d TMP -sourcepath TMP/REngine/JRI:./TMP/REngine  $<




REngine/JRI/JRIEngine.jar:
	cd REngine/JRI && make

REngine/REngine.jar : REngine/Rserve.jar
	touch -c $@
REngine/Rserve.jar : REngine/README.md
	cd REngine && make
	touch -c $@

TMP/REngine/README.md: rEngine.patch
	rm -rf TMP/REngine
	git clone "https://github.com/s-u/REngine" TMP/REngine
	touch -c $@

TMP/rJava/README.md:
	rm -rf TMP/rJava
	git clone "https://github.com/s-u/rJava" TMP/rJava
	touch -c $@

clean:
	rm -rf REngine
