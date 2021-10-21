package uk.ac.manchester.cs.img.seed.reporting;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQException;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQResultSequence;

import net.sf.saxon.xqj.SaxonXQDataSource;

public class CountSystem1Dups {
	public static void main(String[] args) throws IOException {
        try {
            execute();
        }

        catch (FileNotFoundException e) {
            e.printStackTrace();
        }

        catch (XQException e) {
            e.printStackTrace();
        }		

    }

    private static void execute() throws XQException, IOException {
        FileInputStream inputStream = new FileInputStream(new File("count_system1_dups.xqy"));
        XQDataSource ds = new SaxonXQDataSource();
        XQConnection conn = ds.getConnection();
        XQPreparedExpression exp = conn.prepareExpression(inputStream);
        XQResultSequence result = exp.executeQuery();

        while(result.next()) {
            System.out.println(result.getSequenceAsString(null));
        }
    }

}
