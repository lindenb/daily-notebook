import java.util.*;
import java.io.*;

public class JGimp {

private String quote(final String s) {
	final StringBuilder sb= new StringBuilder(s.length()+2);
	sb.append("\"");
	for(int i=0;i< s.length();i++)  {
		sb.append(s.charAt(i));
		}
	sb.append("\"");
	return sb.toString();
	}
private void run(final String args[]) throws Exception {
	final List<String> cmdarray = new ArrayList<>();
	cmdarray.add("gimp");
	cmdarray.add("-i");
	
	final File file = new File("/home/lindenb/jeter.jpg");
	cmdarray.add("-b");
	cmdarray.add("(gimp-file-load 1 "+quote(file.getPath())+" "+quote(file.getName())+")");
	
	cmdarray.add("-b");
	cmdarray.add("(gimp-quit 0)");
	System.err.println(cmdarray);
	Process proc = Runtime.getRuntime().exec(cmdarray.toArray(new String[cmdarray.size()]));
	int ret=proc.waitFor();
	System.err.println("ret="+ret);
	}

public static void main(final String args[]) {
	try {
	new JGimp().run(args);
	} catch(final Throwable err) {
	err.printStackTrace();
	System.exit(-1);
	}
	}
}
