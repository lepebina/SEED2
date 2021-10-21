package uk.ac.manchester.cs.img.seed.reporting;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQException;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQResultSequence;

import net.sf.saxon.xqj.SaxonXQDataSource;

public class RemoveElementsWithEmptyScenarioNames {

	private FileOutputStream fout;
	private boolean firstRunTraceFileCreated = false;
	private boolean secondRunTraceFileCreated = false;
	private boolean thridRunTraceFileCreated = false;
	private boolean fourthRunTraceFileCreated = false;
	private boolean fifthRunTraceFileCreated = false;

	public static void main(String args[]) throws XQException, IOException {
		new RemoveElementsWithEmptyScenarioNames().removeEmptyScenarioAttributes(); 
	}

	public void removeEmptyScenarioAttributes() throws XQException, IOException
	{
		File firstRunTrace= new File("trace_run1.xml");
		File secondRunTrace= new File("trace_run2.xml");
		File thridRunTrace= new File("trace_run3.xml");
		File fourthRunTrace= new File("trace_run4.xml");
		File fifthRunTrace= new File("trace_run5.xml");

		if(!firstRunTrace.exists()){
			firstRunTrace.createNewFile();
			firstRunTraceFileCreated = true;
		} 

		if(!secondRunTrace.exists()) {
			secondRunTrace.createNewFile();
			secondRunTraceFileCreated = true;
		} 

		if(!thridRunTrace.exists()) {
			thridRunTrace.createNewFile();
			thridRunTraceFileCreated = true;
		}

		if(!fourthRunTrace.exists()) {
			fourthRunTrace.createNewFile();
			fourthRunTraceFileCreated = true;
		}

		if(!fifthRunTrace.exists()) {
			fifthRunTrace.createNewFile();
			fifthRunTraceFileCreated = true;
		}

		File xqueryFile = new File("background.xqy");
		FileInputStream inputStream = new FileInputStream(xqueryFile);

		if(firstRunTraceFileCreated) {
			fout = new FileOutputStream("trace_run1.xml", true);
		}

		if(secondRunTraceFileCreated) {
			fout = new FileOutputStream("trace_run2.xml", true);
		}
		
		if(thridRunTraceFileCreated) {
			fout = new FileOutputStream("trace_run3.xml", true);
		}
		
		if(fourthRunTraceFileCreated) {
			fout = new FileOutputStream("trace_run4.xml", true);
		}
		
		if(fifthRunTraceFileCreated) {
			fout = new FileOutputStream("trace_run5.xml", true);
		}

		XQDataSource ds = new SaxonXQDataSource();
		XQConnection conn = ds.getConnection();
		XQPreparedExpression exp = conn.prepareExpression(inputStream);        
		XQResultSequence result = exp.executeQuery();

		fout.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes());
		result.writeSequence(fout, null);

		Path xmlFilePath = Paths.get("trace.xml");
		Files.deleteIfExists(xmlFilePath);
	}
}

