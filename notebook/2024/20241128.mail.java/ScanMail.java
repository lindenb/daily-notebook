import org.apache.james.mime4j.parser.*;
import org.apache.james.mime4j.stream.*;
import org.apache.james.mime4j.*;
public class ScanMail extends AbstractContentHandler {

@Override
public void field(Field field) throws MimeException {
    System.out.println(field);
    }

public static void main(String[] args) {
	try {
	    final ContentHandler handler = new ScanMail();
        final  MimeConfig config = MimeConfig.DEFAULT;
		final MimeStreamParser parser = new MimeStreamParser(config);
		parser.setContentHandler(handler);
		parser.parse(System.in);
		}
	catch(Throwable err) {
		err.printStackTrace();
		}

	}

};
