import org.rosuda.REngine.*;

public class REngineTest {
public static void main(String[] args) {
	try {
		REngine jri = REngine.engineForClass("org.rosuda.REngine.JRI.JRIEngine");
		}
	catch(Throwable err) {
		err.printStackTrace();
		System.exit(-1);
		}

	}
}
