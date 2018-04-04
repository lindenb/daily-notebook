import java.util.regex.*;
import java.util.*;
public class PatternVsDelim
	{
	private static String[] split(char c,String s,int limit) {
		List<CharSequence> L= split1(c,s,limit);
		String pos[]= new String[L.size()];
		for(int i=0;i< L.size();i++) pos[i]= L.get(i).toString();
		return pos;
		}
		
	private static List<String> split1(char c,String s,int limit) {
		List<CharSequence> L= split2(c,s,limit);
		List<String> pos= new ArrayList<>(L.size());
		for(int i=0;i< L.size();i++) pos.add(L.get(i).toString());
		return pos;
		}
	private static List<CharSequence> split2(char c,String s,int limit) {
		List<CharSequence> pos= new ArrayList<>();
		int end = s.length();
		while(end-1>=0 && s.charAt(end-1)==c) end--;
		int prev=0;
		for(int i=0;i< end && (limit==0 || pos.size()+1< limit);i++)
			{
			if(s.charAt(i)==c) {
				pos.add(s.subSequence(prev,i));
				prev=i+1;
				}
			}
		pos.add(s.subSequence(prev,end));
		return pos;
		}
	public static void main(final String args[]) {
		final Pattern pat = Pattern.compile("[,]");
		final char d = ',';
		final long ntry=100000;
		for(final String s:args)
			{
			int n=0;
			long now= System.currentTimeMillis();
			for(long i=0;i< ntry;i++) {
				n=pat.split(s).length;
				}
			System.err.println("regex "+(System.currentTimeMillis()-now)+" "+n);
			 now= System.currentTimeMillis();
			for(long i=0;i< ntry;i++) {
				n=split(d,s,0).length;
				}
			System.err.println("char "+(System.currentTimeMillis()-now)+" "+n);
			} 
	
		}
	}
