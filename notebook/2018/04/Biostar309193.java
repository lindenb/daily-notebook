import java.nio.*;
import java.nio.file.*;
import java.io.*;
import java.util.*;
import java.util.function.*;
class Biostar309193
	{
	private  static void parse(final Path path,final BiConsumer<String,CharSequence> consummer) throws IOException {
		try (BufferedReader br = new BufferedReader(new InputStreamReader(Files.newInputStream(path)))) {
			final StringBuilder sn = new StringBuilder();
			final StringBuilder ba = new StringBuilder(100_000);
			br.lines().forEach(L->{
				if(L.startsWith(">")) {
					if(ba.length()>0) consummer.accept(sn.toString(),ba);
					sn.setLength(0);
					sn.append(L.substring(1));
					ba.setLength(0);
					}
				else
					{
					ba.append(L);
					}
				});
			if(ba.length()>0) consummer.accept(sn.toString(),ba);
			}
		
		}
	public static void main(final String args[]) throws IOException{
		for(final String sn:args) parse(Paths.get(sn),(S,A)->{System.out.print(A);System.out.println();});
		}
	}
