OUTDIR=work
all:$(OUTDIR)/ScanMail.class $(OUTDIR)/apache-mime4j-core-0.8.11.jar $(OUTDIR)/commons-io-2.18.0.jar
	echo | java -cp $(OUTDIR):$(OUTDIR)/apache-mime4j-core-0.8.11.jar:$(OUTDIR)/commons-io-2.18.0.jar ScanMail

$(OUTDIR)/ScanMail.class: ScanMail.java $(OUTDIR)/apache-mime4j-core-0.8.11.jar $(OUTDIR)/commons-io-2.18.0.jar
	javac -d $(OUTDIR) -cp $(OUTDIR)/apache-mime4j-core-0.8.11.jar $<

$(OUTDIR)/commons-io-2.18.0.jar:
	mkdir -p $(dir $@)
	wget -O $@  "https://repo1.maven.org/maven2/commons-io/commons-io/2.18.0/$(notdir $@)"

$(OUTDIR)/apache-mime4j-core-0.8.11.jar :
	mkdir -p $(dir $@)
	wget -O $@  "https://repo1.maven.org/maven2/org/apache/james/apache-mime4j-core/0.8.11/$(notdir $@)"

clean:
	rm -rf $(OUTDIR)
