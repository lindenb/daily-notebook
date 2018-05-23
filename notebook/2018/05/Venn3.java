import java.util.*;
import java.io.*;
import java.awt.*;
import java.awt.geom.*;

public class Venn3
	{
	enum ZONE {A,B,C,AB,BC,AC,ABC};
	private final Map<ZONE,Long> counts = new HashMap<>();
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
				_ellipse = new Ellipse2D.Double(cx-r,cy,r*2,r*2);
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
			double total = counts.values().stream().mapToLong(V->V).sum();
			double nA = counts.get(ZONE.A) + counts.get(ZONE.AB) + counts.get(ZONE.AC) +  counts.get(ZONE.ABC);
			double nB = counts.get(ZONE.B) + counts.get(ZONE.AB) + counts.get(ZONE.BC) +  counts.get(ZONE.ABC);
			double nC = counts.get(ZONE.C) + counts.get(ZONE.AC) + counts.get(ZONE.BC) +  counts.get(ZONE.ABC);
			double nMax = Math.max(nA,Math.max(nB,nC));
			
			circles[0].r = (nA/nMax)*100.0;
			circles[1].r = (nB/nMax)*100.0;
			circles[2].r = (nC/nMax)*100.0;
			}
		Solution(final Solution cp) {
			for(int i=0;i< circles.length;i++) circles[i]=new Circle(cp.circles[i]);
			
			}
		long surface(final ZONE z) {
			Area area = null;
			for(final Circle c:this.circles)
				{
				if(z.name().indexOf(c.name)<0) continue;
				Area area2= new Area(c.ellipse());
				if(area==null)
					{
					area = area2;
					}
				else 
					{
					area.intersect(area2);
					}
				}
			if(area==null || area.isEmpty()) return 1000L;
			return Venn3.this.area(area);
			}
		
		double score() {
			if(_score==null) {
				Map<ZONE,Long> obs = new HashMap<>();
				for(ZONE z:ZONE.values()) {
					obs.put(z,surface(z));
					}
				double sum1 =  counts.values().stream().mapToLong(V->V).sum();
				double sum2 =  obs.values().stream().mapToLong(V->V).sum();
				_score = 0.0;
				for(ZONE z:ZONE.values()) {
					double r1 = counts.get(z)/sum1;
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
		
		Solution best = new Solution();
		for(;;)
			{
			Solution sol = best.mute();
			
			Circle c= sol.circles[rand.nextInt(3)];
			double dv = rand.nextDouble()*10.0 + (rand.nextBoolean()?-1:1);
			switch(rand.nextInt(2))
				{
				case 0: c.cx += dv; break;
				case 1: c.cy += dv; break;

				}
			
			if(sol.score() <= best.score())
				{
				System.err.println("OK "+sol);
				PrintWriter pw = new PrintWriter(new File("jeter.svg"));
				double maxx = Arrays.stream(sol.circles).mapToDouble(C->C.cx+C.r).max().getAsDouble();
				double maxy = Arrays.stream(sol.circles).mapToDouble(C->C.cy+C.r).max().getAsDouble();
				double minx = Arrays.stream(sol.circles).mapToDouble(C->C.cx-C.r).min().getAsDouble();
				double miny = Arrays.stream(sol.circles).mapToDouble(C->C.cy-C.r).min().getAsDouble();
				pw.println("<?xml version=\"1.0\"?>");
				pw.println("<svg width=\""+ (maxx-minx) +"\" height=\""+ (maxy-miny) +"\" version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\">");
				pw.println("<g style=\"stroke:black;fill:none;\">");
				for(final Circle c2:sol.circles) {
					pw.println("<circle cx=\""+(c2.cx-minx)+"\"  cy=\""+(c2.cy-miny)+"\" r=\""+c2.r+"\">");
					pw.println("<title>"+c2.name+"</title>");
					pw.println("</circle>");
					}
				pw.println("</g>\n</svg>");
				pw.flush();
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
