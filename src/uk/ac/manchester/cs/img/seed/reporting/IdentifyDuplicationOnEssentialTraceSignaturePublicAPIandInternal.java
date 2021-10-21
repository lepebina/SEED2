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

public class IdentifyDuplicationOnEssentialTraceSignaturePublicAPIandInternal {
	public static void main(String[] args) throws XQException, IOException {
        new IdentifyDuplicationOnEssentialTraceSignaturePublicAPIandInternal().createXqueryDuplicationReport();
    }
    
    public void createXqueryDuplicationReport() throws XQException, IOException {
        File f= new File("duplication.xml");
        if(!f.exists()){
            f.createNewFile();
        }
        
        File xqueryFile = new File("essential_trace_signature_API_and_internal.xqy");
        FileInputStream inputStream = new FileInputStream(xqueryFile);
        FileOutputStream fout = new FileOutputStream("duplication.xml", true);

        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        XQPreparedExpression exp = conn.prepareExpression(inputStream);        
        XQResultSequence result = exp.executeQuery();

       
        fout.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes());        
        result.writeSequence(fout, null);
    }

}
