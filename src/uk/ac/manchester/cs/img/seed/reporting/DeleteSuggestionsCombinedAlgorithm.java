package uk.ac.manchester.cs.img.seed.reporting;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQResultSequence;
import net.sf.saxon.xqj.SaxonXQDataSource;

public class DeleteSuggestionsCombinedAlgorithm {
	private FileOutputStream fout;
	public static void main(String[] args) throws Exception {
		new DeleteSuggestionsCombinedAlgorithm().createDeleteSuggestionReport();
	}

	public void createDeleteSuggestionReport() throws Exception {
		File f= new File("delete_suggestions.xml");
		if(!f.exists()){
			f.createNewFile();
		}

		File xqueryFile = new File("delete_suggestions_combined_algorithm.xqy");
		FileInputStream inputStream = new FileInputStream(xqueryFile);
		fout = new FileOutputStream("delete_suggestions.xml", true);

		XQDataSource ds = new SaxonXQDataSource();
		XQConnection conn = ds.getConnection();
		XQPreparedExpression exp = conn.prepareExpression(inputStream);        
		XQResultSequence result = exp.executeQuery();	

		fout.write("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n".getBytes());
		result.writeSequence(fout, null);
	}	

}
