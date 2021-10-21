package uk.ac.manchester.cs.img.seed.reporting;

import java.io.File;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Random;

public class CopyFiles {
	private File proposedDestination;
	private File proposedDestinationForRunOneTrace;
	private File proposedDestinationForRunTwoTrace;
	private File proposedDestinationForRunThreeTrace;
	private File proposedDestinationForRunFourTrace;
	private File proposedDestinationForRunFiveTrace;
	
	private File proposedDestinationForRun1VsRun2Trace;
	private File proposedDestinationForRun1VsRun3Trace;
	private File proposedDestinationForRun1VsRun4Trace;
	private File proposedDestinationForRun1VsRun5Trace;
	private File proposedDestinationCombined;

	public static void main(String args[]) throws IOException {
		new CopyFiles().handleEssentialFilesCopying();
	}

	public void handleEssentialFilesCopying() throws IOException {
		Path pathForEssentialTraces = FileSystems.getDefault().getPath("traces/essential/individual_scenarios");
		Path pathForEssentialTracesCombined = FileSystems.getDefault().getPath("traces/essential/individual_scenarios_combined");
		Path pathForPairwiseComparisonsTraces = FileSystems.getDefault().getPath("traces/pairwise_comparisons/");
		Path pathForIndividualRunsTraces = FileSystems.getDefault().getPath("traces/individual_runs/");
		Path pathForMergedEssentialTraces = FileSystems.getDefault().getPath("traces/essentials/");

		/*about what follows in the immediately in the first if:
		 * At the moment, just created to make available input required to run the 
		 * xslt file for merging multiple essential traces. Though present, the merged
		 * essential traces are still stored in traces/essential
		 */
		if(Files.notExists(pathForMergedEssentialTraces)) {
			new File("traces/essentials/").mkdirs(); //
		}
		
		
		if(Files.notExists(pathForEssentialTraces)) {
			new File("traces/essential/individual_scenarios/").mkdirs(); 
		}
		
		if(Files.notExists(pathForEssentialTracesCombined)) {
			new File("traces/essential/individual_scenarios_combined/").mkdirs(); 
		}
		
		if(Files.notExists(pathForPairwiseComparisonsTraces)) {
			new File("traces/pairwise_comparisons/").mkdirs(); 
		}

		File from = new File("et_for_five_runs.xml");
		String destFileNameTheBeforeExtensionPart = generateRandomString();
		proposedDestination = new File("traces/essential/individual_scenarios/" + destFileNameTheBeforeExtensionPart + ".xml");

		if(!proposedDestination.exists()) {
			copyFile(from, proposedDestination);

		} else {
			proposedDestination = new File("traces/essential/individual_scenarios/" +destFileNameTheBeforeExtensionPart + 1 + ".xml");
			copyFile(from, proposedDestination);		
		}
		
		File fromCombined = new File("et_for_five_runs_combined.xml");
		String destFileNameTheBeforeExtensionPartCombined = generateRandomString();
		proposedDestinationCombined = new File("traces/essential/individual_scenarios_combined/" + destFileNameTheBeforeExtensionPartCombined + ".xml");

		if(!proposedDestinationCombined.exists()) {
			copyFile(fromCombined, proposedDestinationCombined);

		} else {
			proposedDestinationCombined = new File("traces/essential/individual_scenarios_combined/" +destFileNameTheBeforeExtensionPartCombined + 1 + ".xml");
			copyFile(fromCombined, proposedDestinationCombined);		
		}


		if(Files.notExists(pathForIndividualRunsTraces)) {
			new File("traces/individual_runs/").mkdirs();
		}

		File fromRunOne = new File("trace_run1.xml");
		String destFileNameTheBeforeExtensionPartForCleanFileOne = generateRandomString();
		proposedDestinationForRunOneTrace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileOne + ".xml");

		if(!proposedDestinationForRunOneTrace.exists()) {
			copyFile(fromRunOne, proposedDestinationForRunOneTrace);

		} else {
			proposedDestinationForRunOneTrace = new File("traces/individual_runs/" +destFileNameTheBeforeExtensionPartForCleanFileOne + 1 + ".xml");
			copyFile(fromRunOne, proposedDestinationForRunOneTrace);		
		}


		File fromRunTwo = new File("trace_run2.xml");
		String destFileNameTheBeforeExtensionPartForCleanFileTwo = generateRandomString();
		proposedDestinationForRunTwoTrace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileTwo + ".xml");

		if(!proposedDestinationForRunTwoTrace.exists()) {
			copyFile(fromRunTwo, proposedDestinationForRunTwoTrace);

		} else {
			proposedDestinationForRunTwoTrace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileTwo + 1 + ".xml");
			copyFile(fromRunTwo, proposedDestinationForRunTwoTrace);		
		}
		
		File fromRunThree = new File("trace_run3.xml");
		String destFileNameTheBeforeExtensionPartForCleanFileThree = generateRandomString();
		proposedDestinationForRunThreeTrace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileThree + ".xml");

		if(!proposedDestinationForRunThreeTrace.exists()) {
			copyFile(fromRunThree, proposedDestinationForRunThreeTrace);

		} else {
			proposedDestinationForRunThreeTrace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileThree + 1 + ".xml");
			copyFile(fromRunThree, proposedDestinationForRunThreeTrace);		
		}
		
		File fromRunFour = new File("trace_run4.xml");
		String destFileNameTheBeforeExtensionPartForCleanFileFour = generateRandomString();
		proposedDestinationForRunFourTrace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileFour + ".xml");

		if(!proposedDestinationForRunFourTrace.exists()) {
			copyFile(fromRunFour, proposedDestinationForRunFourTrace);

		} else {
			proposedDestinationForRunFourTrace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileFour + 1 + ".xml");
			copyFile(fromRunFour, proposedDestinationForRunFourTrace);		
		}
		
		File fromRunFive = new File("trace_run5.xml");
		String destFileNameTheBeforeExtensionPartForCleanFileFive = generateRandomString();
		proposedDestinationForRunFiveTrace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileFive + ".xml");

		if(!proposedDestinationForRunFiveTrace.exists()) {
			copyFile(fromRunFive, proposedDestinationForRunFiveTrace);

		} else {
			proposedDestinationForRunFiveTrace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileFive + 1 + ".xml");
			copyFile(fromRunFive, proposedDestinationForRunFiveTrace);		
		}	
		
		File fromRun1VsRun2 = new File("etraces/et_run1_vs_run2.xml");
		String destFileNameTheBeforeExtensionPartForCleanFileOnevsTwo = generateRandomString();
		proposedDestinationForRun1VsRun2Trace = new File("traces/pairwise_comparisons/" + destFileNameTheBeforeExtensionPartForCleanFileOnevsTwo + ".xml");

		if(!proposedDestinationForRun1VsRun2Trace.exists()) {
			copyFile(fromRun1VsRun2, proposedDestinationForRun1VsRun2Trace);

		} else {
			proposedDestinationForRun1VsRun2Trace = new File("traces/individual_runs/" +destFileNameTheBeforeExtensionPartForCleanFileOnevsTwo + 1 + ".xml");
			copyFile(fromRun1VsRun2, proposedDestinationForRun1VsRun2Trace);		
		}


		File fromRun1VsRun3 = new File("etraces/et_run1_vs_run3.xml");
		String destFileNameTheBeforeExtensionPartForCleanFileOnevsThree = generateRandomString();
		proposedDestinationForRun1VsRun3Trace = new File("traces/pairwise_comparisons/" + destFileNameTheBeforeExtensionPartForCleanFileOnevsThree + ".xml");

		if(!proposedDestinationForRun1VsRun3Trace.exists()) {
			copyFile(fromRun1VsRun3, proposedDestinationForRun1VsRun3Trace);

		} else {
			proposedDestinationForRun1VsRun3Trace = new File("traces/individual_runs/" +destFileNameTheBeforeExtensionPartForCleanFileOnevsThree + 1 + ".xml");
			copyFile(fromRun1VsRun3, proposedDestinationForRun1VsRun3Trace);		
		}
		
		File fromRun1VsRun4 = new File("etraces/et_run1_vs_run4.xml");
		String destFileNameTheBeforeExtensionPartForCleanFileOnevsFour = generateRandomString();
		proposedDestinationForRun1VsRun4Trace = new File("traces/pairwise_comparisons/" + destFileNameTheBeforeExtensionPartForCleanFileOnevsFour + ".xml");

		if(!proposedDestinationForRun1VsRun4Trace.exists()) {
			copyFile(fromRun1VsRun4, proposedDestinationForRun1VsRun4Trace);

		} else {
			proposedDestinationForRun1VsRun4Trace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileOnevsFour + 1 + ".xml");
			copyFile(fromRun1VsRun4, proposedDestinationForRun1VsRun4Trace);		
		}
		
		File fromRun1VsRun5 = new File("etraces/et_run1_vs_run5.xml");
		String destFileNameTheBeforeExtensionPartForCleanFileOnevsFive = generateRandomString();
		proposedDestinationForRun1VsRun5Trace = new File("traces/pairwise_comparisons/" + destFileNameTheBeforeExtensionPartForCleanFileOnevsFive + ".xml");

		if(!proposedDestinationForRun1VsRun5Trace.exists()) {
			copyFile(fromRun1VsRun5, proposedDestinationForRun1VsRun5Trace);

		} else {
			proposedDestinationForRun1VsRun5Trace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileOnevsFive + 1 + ".xml");
			copyFile(fromRun1VsRun5, proposedDestinationForRun1VsRun5Trace);		
		}
		
		
//		File fromRunFive = new File("trace_run5.xml");
//		String destFileNameTheBeforeExtensionPartForCleanFileFive = generateRandomString();
//		proposedDestinationForRunFiveTrace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileFive + ".xml");
//
//		if(!proposedDestinationForRunFiveTrace.exists()) {
//			copyFile(fromRunFive, proposedDestinationForRunFiveTrace);
//
//		} else {
//			proposedDestinationForRunFiveTrace = new File("traces/individual_runs/" + destFileNameTheBeforeExtensionPartForCleanFileFive + 1 + ".xml");
//			copyFile(fromRunFive, proposedDestinationForRunFiveTrace);		
//		}

		if(from.exists()) from.delete();
		if(fromCombined.exists()) fromCombined.delete();
		
		if(fromRunOne.exists()) fromRunOne.delete();
		if(fromRunTwo.exists()) fromRunTwo.delete();
		if(fromRunThree.exists()) fromRunThree.delete();
		if(fromRunFour.exists()) fromRunFour.delete();
		if(fromRunFive.exists()) fromRunFive.delete();
		
		if(fromRun1VsRun2.exists()) fromRun1VsRun2.delete();
		if(fromRun1VsRun3.exists()) fromRun1VsRun3.delete();
		if(fromRun1VsRun4.exists()) fromRun1VsRun4.delete();
		if(fromRun1VsRun5.exists()) fromRun1VsRun5.delete();		

	}

	public static void copyFile( File from, File to ) throws IOException {
		Files.copy( from.toPath(), to.toPath() );
	}

	public static String generateRandomString() throws IOException {
		String seedChars = "abcdefghijklmnopqrstuvwxyz1234567890";
		StringBuilder seed = new StringBuilder();
		Random rnd = new Random();
		while (seed.length() < 20) { 
			int index = (int) (rnd.nextFloat() * seedChars.length());
			seed.append(seedChars.charAt(index));
		}
		String seedStringStr = seed.toString();
		return seedStringStr;
	}

}
