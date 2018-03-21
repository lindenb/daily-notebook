/*
Author: Pierre Lindenbaum @yokofakun

related: 
http://bionics.it/posts/parsing-drugbank-xml-or-any-large-xml-file-in-streaming-mode-in-go

*/
import ca.drugbank.*;
import java.util.*;
import java.util.stream.*;
import java.io.*;
import javax.xml.stream.*;
import javax.xml.stream.events.*;
import javax.xml.bind.*;
import javax.xml.*;

public class Drugbank
{
public static void main(final String args[]) throws Exception {
	final JAXBContext jc = JAXBContext.newInstance("ca.drugbank");
	final Unmarshaller	unmarshaller =jc.createUnmarshaller();
	final XMLInputFactory xmlInputFactory=XMLInputFactory.newFactory();
	xmlInputFactory.setProperty(XMLInputFactory.IS_NAMESPACE_AWARE, Boolean.TRUE);
	final XMLEventReader r=xmlInputFactory.createXMLEventReader(System.in);
	final ExternalIdentifierResourceType EXTIDS[]={
	  	ExternalIdentifierResourceType.CH_EMBL,
	  	ExternalIdentifierResourceType.PUB_CHEM_COMPOUND,
	  	ExternalIdentifierResourceType.PUB_CHEM_SUBSTANCE
	  	};
	final PrintStream w = System.out;	
	while(r.hasNext())
		{
		final XMLEvent evt=r.peek();
		if(evt.isStartElement() && evt.asStartElement().getName().getLocalPart().equals("drug") ) {
		  final DrugType d = unmarshaller.unmarshal(r,DrugType.class).getValue();
		  w.print(d.getName());
		  w.print('\t');
		  if(d.getCalculatedProperties()!=null) 
		  	w.print(d.getCalculatedProperties().
		  		getProperty().
		  		stream().
		  		filter(P->P.getKind().equals(CalculatedPropertyKindType.IN_CH_I_KEY)).
		  		map(P->P.getValue()).
		  		collect(Collectors.joining(" ")));
		  	
		  w.print('\t');
		  if(d.getGroups()!=null)
		  	w.print(d.getGroups().
		  		getGroup().
		  		stream().
		  		map(G->G.value()).
		  		collect(Collectors.joining("->")));
		 
	  	  for(final ExternalIdentifierResourceType extId: EXTIDS) {
	  		w.print('\t');
	  		if(d.getExternalIdentifiers()!=null)
			  	w.print(d.getExternalIdentifiers().
			  		getExternalIdentifier().
			  		stream().
			  		filter(P->P.getResource()==extId).
			  		map(P->P.getIdentifier()).
			  		collect(Collectors.joining(" ")));
	  		}
		  	
		 w.println();
		 }
		else {
		     r.next();//consumme
		    }
		}
	r.close();
	}
}
