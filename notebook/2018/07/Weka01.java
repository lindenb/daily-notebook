import weka.classifiers.*;
import weka.core.*;
import weka.filters.*;
import org.springframework.context.*;
import org.springframework.context.support.*;
import java.io.*;

public class Weka01
	{
	public static class WekaTest
		{
		private Classifier classifier = null;
		private Filter filter = null;
		
		public void setClassifier(Classifier classifier) {
			this.classifier = classifier;
			}
		
		public Classifier getClassifier() {
			return this.classifier;
			}
		public void setFilter(Filter filter) {
			this.filter = filter;
			}
		
		public Filter getFilter() {
			return this.filter;
			}
		}
	
	

  	  /** for evaluating the classifier */
  protected Evaluation m_Evaluation = null;
  
	private void run(final String[] args) throws Exception {
		final ApplicationContext ctx = new FileSystemXmlApplicationContext(args[0]);
		WekaTest test = (WekaTest)ctx.getBean("weka01");

		
		final File dataFile = new File(args[1]);
		final FileReader fr = new FileReader(dataFile);
		final Instances m_Training     = new Instances(fr);
		fr.close();
		m_Training.setClassIndex(m_Training.numAttributes() - 1);
		
		test.getFilter().setInputFormat(m_Training);
    		Instances filtered = Filter.useFilter(m_Training, test.getFilter());

   		 // train classifier on complete file for tree
    		test.getClassifier().buildClassifier(filtered);
    
	    // 10fold CV with seed=1
	    m_Evaluation = new Evaluation(filtered);
	    m_Evaluation.crossValidateModel(
		test.getClassifier(), filtered, 10, m_Training.getRandomNumberGenerator(1));
		System.err.println("Done");
		}
	public static void main(final String[] args) throws Exception {
		new Weka01().run(args);
		}
	}
