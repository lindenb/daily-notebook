all: google-blockly/README.md
	java -jar ${HOME}/src/jsandbox/dist/fileserver.jar -D .

google-blockly/README.md :
	wget -O "jeter.tar.gz" "https://github.com/google/blockly/releases/download/blockly-v10.2.2/blockly-10.2.2.tgz"
	tar xvfz jeter.tar.gz
	rm jeter.tar.gz
	mv package google-blockly
	touch -c $@
clean:
	rm -rf google-blockly
