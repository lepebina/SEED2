package uk.ac.manchester.cs.img.seed;

import java.io.IOException;

import uk.ac.manchester.cs.img.seed.reporting.DuplicationReport;

public class Seed {
    public static void main(String[] args) throws Exception {
        try {
            DuplicationReport.createDuplicationReport();
        } catch (IOException e) {
            e.printStackTrace();
        }

    }

}