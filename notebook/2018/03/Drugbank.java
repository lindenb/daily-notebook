import ca.drugbank.*;
import java.util.*;
import javax.xml.stream.*;
import javax.xml.stream.events.*;
import javax.xml.bind.*;
import javax.xml.*;
public class Drugbank
{
public static void main(final String args[]) throws Exception {
	JAXBContext jc = JAXBContext.newInstance("ca.drugbank");
	Unmarshaller	unmarshaller =jc.createUnmarshaller();
	final XMLInputFactory xmlInputFactory=XMLInputFactory.newFactory();
	xmlInputFactory.setProperty(XMLInputFactory.IS_NAMESPACE_AWARE, Boolean.TRUE);
  XMLEventReader r=xmlInputFactory.createXMLEventReader(System.in);		
	while(r.hasNext())
				{
				final XMLEvent evt=r.peek();
				if(evt.isStartElement() && evt.asStartElement().getName().getLocalPart().equals("drug") ) {
				  final DrugType d = unmarshaller.unmarshal(r,DrugType.class).getValue();
		  	  
		  	 
				  System.out.println(d.getName());
				  System.out.println(d.getDescription());
				  System.out.println(d.getCasNumber());
				  System.out.println(d.getUnii());
				  System.out.println("//");
					
					}
				else {
					r.next();//consumme
					}
				}
 r.close();
 }
}
