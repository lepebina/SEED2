package uk.ac.manchester.cs.img.seed.reporting.helpers;

import uk.ac.manchester.cs.img.seed.reporting.ConcreteXQueryDuplicationReport;

public class PersistentReport {

    public static void write() throws Exception {
        new ConcreteXQueryDuplicationReport().createXqueryDuplicationReport();
    }
}