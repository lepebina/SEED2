package uk.ac.manchester.cs.img.seed.reporting.tests;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

import javax.xml.xquery.XQConnection;
import javax.xml.xquery.XQDataSource;
import javax.xml.xquery.XQException;
import javax.xml.xquery.XQPreparedExpression;
import javax.xml.xquery.XQResultSequence;

import org.junit.Ignore;
import org.junit.Test;
import mockit.Expectations;
import mockit.Mock;
import mockit.MockUp;
import mockit.Mocked;
import net.sf.saxon.xqj.SaxonXQDataSource;
import uk.ac.manchester.cs.img.seed.reporting.ConcreteXQueryDuplicationReport;
import uk.ac.manchester.cs.img.seed.reporting.DuplicationReport;
import uk.ac.manchester.cs.img.seed.reporting.helpers.PersistentReport;

public class DuplicationReportTest {

    @Test
    public void shouldCreateDuplicationReport(@Mocked PersistentReport anyPersistentReport) throws Exception {
        //arrange

        new Expectations() {{                     
            PersistentReport.write(); 
        }};

        //Act
        DuplicationReport.createDuplicationReport();

        //Assert
    } 

    @Ignore
    @Test
    public void shouldCreateXqueryDuplicationReport(@Mocked XQDataSource anyXQDS, @Mocked SaxonXQDataSource anySaxonDS,
            @Mocked XQConnection anyXQConn, @Mocked XQPreparedExpression anyXQPEx, @Mocked XQResultSequence anyXQRS, 
            @Mocked ConcreteXQueryDuplicationReport anyXqueryReport) throws XQException, IOException { 

        new MockUp<File>() {
            @Mock
            public void $init(String fileName) {

            }
        }; 

        new MockUp<FileInputStream>() {
            @Mock
            public void $init(File f) {

            }
        }; 

        new MockUp<FileOutputStream>() {
            @Mock
            public void $init(String fileName, boolean append) {

            }
        }; 

        new Expectations() {

            {


                File f= new File(anyString);
                FileInputStream fin = new FileInputStream(f);
                FileOutputStream fout = new FileOutputStream(anyString, true);
                XQDataSource ds = new SaxonXQDataSource();
                result = anySaxonDS;
                ds.getConnection();
                result = anyXQConn;
                XQPreparedExpression exp = anyXQConn.prepareExpression(fin);
                result = anyXQPEx;
                exp.executeQuery();
                result = anyXQRS;
                fout.write(withPrefix("<?xml version=\"1.0\" encoding=\"UTF-8\"?>").getBytes());
                anyXQRS.writeSequence(fout, null);

            }};


            new ConcreteXQueryDuplicationReport().createXqueryDuplicationReport();
    }

}
