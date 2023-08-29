# TEST for java modules
all: test-jdeps test-run test-jlink

test-jlink: helloJRE/bin/runHello
	# run using generated java JRE
	helloJRE/bin/java  --module-path hello.jar --module helloModule/hello.HelloWorld
	# run using executable
	helloJRE/bin/runHello

helloJRE/bin/runHello : hello.jar
	rm -rf helloJRE
	jlink  --launcher  runHello=helloModule/hello.HelloWorld \
		--module-path "${JAVA_HOME}/jmods:$<"  \
		--add-modules helloModule --output helloJRE

test-jdeps : hello.jar
	jdeps --module-path $< -s --module helloModule
test-run : hello.jar
	java --module-path $< --module helloModule/hello.HelloWorld
hello.jar : hello/HelloWorld.java module-info.java
	mkdir -p TMP
	javac -d TMP $^
	jar cvf $@ -C TMP .
	rm -rf TMP

clean:
	rm -rf hello.jar helloJRE TMP
