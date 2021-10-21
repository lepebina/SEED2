package uk.ac.manchester.cs.img.seed.tests;

import mockit.Expectations;
import mockit.Mocked;

import org.junit.Test;

import uk.ac.manchester.cs.img.seed.Seed;
import uk.ac.manchester.cs.img.seed.reporting.DuplicationReport;

public class SeedTest {

	private static final String DUPLICATION_REPORT_LOCATION = "DUPLICATION_REPORT_LOCATION";

	@Test
	public void shouldCreateDuplicationReportGivenValidLocationFactoryVersion(@Mocked 
			DuplicationReport anyDuplicationReport) throws Exception {

		new Expectations() {{
			DuplicationReport.createDuplicationReport();
		}};

		Seed.main(new String[] {"-f", "FEATURE_FILE_LOCATION",
				"-s", "STEPDEFS_LOCATION",
				"-p", "PRODCLASS_LOCATION",
				"-dr", DUPLICATION_REPORT_LOCATION });
	}

	//TODO need to test cases for different order of arguments
	//TODO account for the possibility of invalid report location
	//TODO need test for counting the number of duplicates found
}