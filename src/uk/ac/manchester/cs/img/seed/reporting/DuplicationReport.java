package uk.ac.manchester.cs.img.seed.reporting;

import uk.ac.manchester.cs.img.seed.reporting.helpers.PersistentReport;

public class DuplicationReport {
    public static void createDuplicationReport() throws Exception {
        PersistentReport.write();
    }

}