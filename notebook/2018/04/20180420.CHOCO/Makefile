all: tmp/Choco01.class
	java -cp  choco-4.0.6/choco-solver-4.0.6-with-dependencies.jar:tmp Choco01

tmp/Choco01.class : Choco01.java choco-4.0.6/choco-solver-4.0.6-with-dependencies.jar
	mkdir -p tmp
	javac -cp  choco-4.0.6/choco-solver-4.0.6-with-dependencies.jar:. -d tmp $<

choco-4.0.6/choco-solver-4.0.6-with-dependencies.jar:
	rm -rf "choco-4.0.6" jeter.zip	
	wget -O "jeter.zip" "https://github.com/chocoteam/choco-solver/releases/download/4.0.6/choco-4.0.6.zip"
	unzip jeter.zip
	rm jeter.zip

clean:
	rm -rf jeter.zip choco-4.0.6 tmp

