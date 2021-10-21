package uk.ac.manchester.cs.img.seed.reporting;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQException;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQResultSequence;
import net.sf.saxon.xqj.SaxonXQDataSource;

public class ProduceESsentialTraceForOneScenarioAfterFiveRuns {
	public static void main(String[] args) throws XQException, IOException {
		ProduceESsentialTraceForOneScenarioAfterFiveRuns obj = new ProduceESsentialTraceForOneScenarioAfterFiveRuns();        
		obj.produceFiveRunsScenarioCombinedEssentialTraces();
		obj.produceFiveRunsScenarioEssentialTrace();
    }
	
	public void produceFiveRunsScenarioCombinedEssentialTraces() throws XQException, IOException { 
		File outputFile = new File("et_for_five_runs_combined.xml");		
		if(!outputFile.exists()) {
			outputFile.createNewFile();	
		}
	      
        File xqueryFile = new File("essential_trace_for_one_scenario.xqy");
        FileInputStream inputStream = new FileInputStream(xqueryFile);
        FileOutputStream fout = new FileOutputStream("et_for_five_runs_combined.xml", true);

        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        XQPreparedExpression exp = conn.prepareExpression(inputStream);        
        XQResultSequence result = exp.executeQuery();

        fout.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes());
        result.writeSequence(fout, null);  
    }
	
	public void produceFiveRunsScenarioEssentialTrace() throws XQException, IOException { 
		File outputFile = new File("et_for_five_runs.xml");		
		if(!outputFile.exists()) {
			outputFile.createNewFile();	
		}
	      
        File xqueryFile = new File("essential_trace_for_one_scenario1.xqy");
        FileInputStream inputStream = new FileInputStream(xqueryFile);
        FileOutputStream fout = new FileOutputStream("et_for_five_runs.xml", true);

        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        XQPreparedExpression exp = conn.prepareExpression(inputStream);        
        XQResultSequence result = exp.executeQuery();

        fout.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes());
        result.writeSequence(fout, null);  
    }

}
