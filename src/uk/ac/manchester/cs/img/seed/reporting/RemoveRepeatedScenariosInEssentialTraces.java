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

public class RemoveRepeatedScenariosInEssentialTraces {
	public static void main(String args[]) throws XQException, IOException {
		new RemoveRepeatedScenariosInEssentialTraces().removeAfterEssentialTraceMergeDuplicatio(); 
	}

	public void removeAfterEssentialTraceMergeDuplicatio() throws XQException, IOException
	{
		File xqueryFile = new File("dedup_essential_traces.xqy");
		File uniqueEssentialTracesFile = new File("traces/essential/unique_essential_traces.xml");
		
		if(!uniqueEssentialTracesFile.exists()) uniqueEssentialTracesFile.createNewFile();
		
		FileInputStream inputStream = new FileInputStream(xqueryFile);
		FileOutputStream fout = new FileOutputStream("traces/essential/unique_essential_traces.xml", true);	

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
