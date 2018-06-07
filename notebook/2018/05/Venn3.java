import java.util.*;
import java.io.*;
import java.awt.*;
import java.awt.geom.*;

public class Venn3
	{
	enum ZONE {A,B,C,AB,BC,AC,ABC};
	private final Map<ZONE,Long> counts = new HashMap<>();
	private double total_weight = 0.0;
	private final Random rand = new Random();
	
	
	
	private class Circle
		{
		char name;
		double cx;
		double cy;
		double r;
		Ellipse2D.Double _ellipse = null;
		Circle() {
			name='?';
			cx=0;
			cy=0;
			r=1;
			}
		Circle(final Circle cp) {
			name=cp.name;
			cx=cp.cx;
			cy=cp.cy;
			r=cp.r;
			}
		Ellipse2D ellipse() {
			if(_ellipse == null) {
				_ellipse = new Ellipse2D.Double(cx-r,cy-r,r*2,r*2);
				}
			return _ellipse;
			}
		public String toString() {
			return name+"=("+cx+","+cy+","+r+") ";
			}
		}
	
	private class Solution
		{
		final  Circle circles[]= new Circle[3] ;
		Double _score = null;
		Solution() {
			for(int i=0;i< circles.length;i++) circles[i]=new Circle();
			circles[0].name='A';
			circles[1].name='B';
			circles[2].name='C';
			}
		Solution(final Solution cp) {
			for(int i=0;i< circles.length;i++) circles[i]=new Circle(cp.circles[i]);
			}
		
		Area getAreaForZone(final ZONE z)
			{
			Area area = null;
			
			for(final Circle c :this.circles)
				{
				if(z.name().indexOf(c.name)<0) continue;
				final Area area2= new Area(c.ellipse());
				if(area==null)
					{
					area = area2;
					}
				else 
					{
					area.intersect(area2);
					}
				}
			return area;
			}	
		
		long surface(final ZONE z) {
			final Area area = getAreaForZone(z);
			if(area==null || area.isEmpty()) return  100000L;
			return Venn3.this.area(area);
			}
		
		double score() {
			if(_score==null) {
				final Map<ZONE,Long> obs = new HashMap<>();
				for(ZONE z:ZONE.values()) {
					obs.put(z,surface(z));
					}
				final double sum2 =  obs.values().stream().mapToLong(V->V).sum();
				_score = 0.0;
				for(ZONE z:ZONE.values()) {
					double r1 = Venn3.this.counts.get(z)/Venn3.this.total_weight;
					double r2 = obs.get(z)/sum2;
					_score+= Math.pow((r1-r2),2);
					}
				}
			return _score;
			}
		Solution mute()
			{
			Solution sol = new Solution(this);
			return sol;
			}
		
		void print(PrintStream pw) throws IOException
			{
			final double maxx = Arrays.stream(this.circles).mapToDouble(C->C.cx+C.r).max().getAsDouble();
			final double maxy = Arrays.stream(this.circles).mapToDouble(C->C.cy+C.r).max().getAsDouble();
			final double minx = Arrays.stream(this.circles).mapToDouble(C->C.cx-C.r).min().getAsDouble();
			final double miny = Arrays.stream(this.circles).mapToDouble(C->C.cy-C.r).min().getAsDouble();
			pw.println("<?xml version=\"1.0\"?>");
			pw.println("<svg width=\""+ (1+maxx-minx) +"\" height=\""+ (1+maxy-miny) +"\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">");
			pw.println("<g style=\"stroke:black;fill:none;font-size:10px;\" transform=\"translate("+(-minx)+","+ (-miny)+")\">");
			for(final Circle c2:this.circles) {
				pw.print("<circle cx=\""+ c2.cx +"\"  cy=\""+ c2.cy +"\" r=\""+c2.r+"\" style=\"fill-opacity:0.3;fill:");
				switch(c2.name)
					{
					case 'A': pw.print("blue");break;
					case 'B': pw.print("green");break;
					case 'C': pw.print("red");break;
					}
				pw.println( ";\">");
				pw.println("<title>"+c2.name+"</title>");
				pw.println("</circle>");
				}
			for(final ZONE z:ZONE.values())
				{
				//if(z.name().length()!=1) continue;
				final Area area = this.getAreaForZone(z);
				if(area==null || area.isEmpty()) continue;
				
				final Rectangle2D rect = area.getBounds2D();
				
				
				pw.println("<text x=\""+
					rect.getCenterX()+"\" y=\""+
					rect.getCenterY()+"\">"+
					z.name()+":"+Venn3.this.counts.get(z) +
					"</text>");
				}
			pw.println("</g>\n</svg>");
			pw.flush();
			
			}	
		
		public String toString() {
			return Arrays.asList(circles)+" "+_score;
			}
		}
	
	private long area(final Shape s)
		{
		long n=0L;
		final Rectangle b=s.getBounds();
		for(int x=(int)b.getMinX();x<=(int)b.getMaxX();++x)
			{
			for(int y=(int)b.getMinY();y<=(int)b.getMaxY();++y)
				{
				if(s.contains(x,y)) n++;
				}
			}
		return n;
		}
	
	private void run(final String args[]) throws Exception {
		for(ZONE z:ZONE.values()) counts.put(z,0L);
		BufferedReader br= new BufferedReader(new FileReader(args[0]));
		String line;
		while((line=br.readLine())!=null)
			{
			if(line.isEmpty() || line.startsWith("#")) continue;
			int tab = line.indexOf("\t");
			if(tab==-1) tab = line.indexOf(" ");
			ZONE z = ZONE.valueOf(line.substring(0,tab));
			Long n = Long.parseLong(line.substring(tab+1));
			this.counts.put(z,n);
			}
		br.close();
		System.err.println(counts);
		
		
		
		this.total_weight = counts.values().stream().mapToLong(V->V).sum();
		final  long nA= counts.get(ZONE.A) + counts.get(ZONE.AB) + counts.get(ZONE.AC) +  counts.get(ZONE.ABC);
		final  long nB= counts.get(ZONE.B) + counts.get(ZONE.AB) + counts.get(ZONE.BC) +  counts.get(ZONE.ABC);
		final  long nC= counts.get(ZONE.C) + counts.get(ZONE.AC) + counts.get(ZONE.BC) +  counts.get(ZONE.ABC);
		final double nMax = Math.max(nA,Math.max(nB,nC));
		
		Solution best = new Solution();
		
		final double MAX_RADIUS=100.0;
		best.circles[0].r = ((nA)/nMax)*MAX_RADIUS;
		best.circles[1].r = ((nB)/nMax)*MAX_RADIUS;
		best.circles[2].r = ((nC)/nMax)*MAX_RADIUS;

		
		for(;;)
			{
			boolean ok=true;
			for(Circle c:best.circles)
				{
				c.cx = rand.nextDouble()*3*MAX_RADIUS;
				c.cy = rand.nextDouble()*3*MAX_RADIUS;
				}
			
			for(int x=0;ok && x+1<best.circles.length;++x)
				{
				Circle c1= best.circles[x];
				for(int y=x+1;ok && y<best.circles.length;++y)
					{
					Circle c2= best.circles[y];
					//if(c1.ellipse().getBounds().contains(c2.ellipse().getBounds())) ok=false;
					//if(c2.ellipse().getBounds().contains(c1.ellipse().getBounds())) ok=false;
					//if(!c1.ellipse().getBounds().intersects(c2.ellipse().getBounds())) ok=false;
					}
				}
			if(ok) break;
			}
		
		
		for(;;)
			{
			Solution sol = best.mute();
			
			
			
			Circle c= sol.circles[rand.nextInt(3)];
			double dv = rand.nextDouble()*c.r;
			if(rand.nextBoolean()) dv*=-1.0;
			switch(rand.nextInt(2))
				{
				case 0: c.cx += dv; break;
				case 1: c.cy += dv; break;
				}
			
			if(sol.score() <= best.score())
				{
				System.err.println("OK "+sol);
				PrintStream pw = new PrintStream(new File("jeter.svg"));
				sol.print(pw);
				pw.close();
				best = sol;
				}
			}
		
		}
	public static void main(final String args[])
		{
		try 	{
			new Venn3().run(args);
			}
		catch(final Throwable err)
			{
			err.printStackTrace();
			}
		}
	}
