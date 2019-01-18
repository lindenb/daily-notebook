
## code.jshell

The jshell script.

```
import java.io.*;
import htsjdk.variant.vcf.*;
var filename = System.getProperty("vcf");
var vcfReader = new VCFFileReader(new File(filename),false);
long count = vcfReader.iterator().stream().filter(V->V.isSNP()).count();
vcfReader.close();
System.out.println(filename+"\t"+count);
/exit
```

invoke jshell

```
## base directory for the *.jar files for the htsjdk library

$ export BASE=/home/lindenb/.gradle/caches/modules-2/files-2.1

## invoke jshell (see https://stackoverflow.com/questions/46756421/how-to-pass-arguments-to-a-jshell-script )

$ jshell \
	--class-path "${BASE}/org.tukaani/xz/1.5/9c64274b7dbb65288237216e3fae7877fd3f2bee/xz-1.5.jar:${BASE}/org.xerial.snappy/snappy-java/1.1.4/d94ae6d7d27242eaa4b6c323f881edbb98e48da6/snappy-java-1.1.4.jar:${BASE}/gov.nih.nlm.ncbi/ngs-java/2.9.0/8c22355d23b97b9ec0998171c45a42b5eb61eb77/ngs-java-2.9.0.jar:${BASE}/commons-logging/commons-logging/1.1.1/5043bfebc3db072ed80fbd362e7caf00e885d8ae/commons-logging-1.1.1.jar:${BASE}/org.apache.commons/commons-jexl/2.1.1/6ecc181debade00230aa1e17666c4ea0371beaaa/commons-jexl-2.1.1.jar:${BASE}/org.apache.commons/commons-compress/1.4.1/b02e84a993d88568417536240e970c4b809126fd/commons-compress-1.4.1.jar:${BASE}/com.github.samtools/htsjdk/2.18.0/89bd60388aece4de98a0de2c527b9e7966b0c90b/htsjdk-2.18.0.jar"  \
	-R-Dvcf=input.vcf code.jshell

input.vcf	173
```

