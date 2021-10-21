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

public class ProduceEssentialTracesForAllScenariosFullTraceAfterFiveRuns {
	public static void main(String[] args) throws XQException, IOException {
		ProduceEssentialTracesForAllScenariosFullTraceAfterFiveRuns obj = new ProduceEssentialTracesForAllScenariosFullTraceAfterFiveRuns();        
		obj.produceFiveRunsCombinedEssentialFullTraces();
		obj.produceFiveRunsScenariosEssentialFullTrace();
    }
	
	public void produceFiveRunsCombinedEssentialFullTraces() throws XQException, IOException { 
		File outputFile = new File("e_full_traces_for_five_runs_combined.xml");		
		if(!outputFile.exists()) {
			outputFile.createNewFile();	
		}
	      
        File xqueryFile = new File("essential_traces_for_all_scenarios.xqy");
        FileInputStream inputStream = new FileInputStream(xqueryFile);
        FileOutputStream fout = new FileOutputStream("e_full_traces_for_five_runs_combined.xml", true);

        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        XQPreparedExpression exp = conn.prepareExpression(inputStream);        
        XQResultSequence result = exp.executeQuery();

        fout.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes());
        result.writeSequence(fout, null);  
    }
	
	public void produceFiveRunsScenariosEssentialFullTrace() throws XQException, IOException { 
		File outputFile = new File("e_full_traces_for_five_runs.xml");		
		if(!outputFile.exists()) {
			outputFile.createNewFile();	
		}
	      
        File xqueryFile = new File("essential_traces_for_all_scenarios1.xqy");
        FileInputStream inputStream = new FileInputStream(xqueryFile);
        FileOutputStream fout = new FileOutputStream("e_full_traces_for_five_runs.xml", true);

        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        XQPreparedExpression exp = conn.prepareExpression(inputStream);        
        XQResultSequence result = exp.executeQuery();

        fout.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes());
        result.writeSequence(fout, null);  
    }


}
