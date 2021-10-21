package uk.ac.manchester.cs.img.seed.reporting;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;

public class GetFullTracesForFiveRuns {
	public static void main(String args[]) throws IOException {
		new GetFullTracesForFiveRuns().getFullTraceForIndividualRun();
	}

	public void getFullTraceForIndividualRun() throws IOException {
		File from = new File("trace.xml");
		File destination;		

		File run1 = new File("trace1.xml");
		File run2 = new File("trace2.xml");
		File run3 = new File("trace3.xml");
		File run4 = new File("trace4.xml");

		if(!run1.exists()) {
			destination = new File("trace1.xml");
			copyFile(from, destination);
			if(from.exists()) from.delete();
		}
		else if(!run2.exists()) {
			destination = new File("trace2.xml");
			copyFile(from, destination);
			if(from.exists()) from.delete();
		}
		else if(!run3.exists()) {
			destination = new File("trace3.xml");
			copyFile(from, destination);
			if(from.exists()) from.delete();
		}
		else if(!run4.exists()) {
			destination = new File("trace4.xml");
			copyFile(from, destination);
			if(from.exists()) from.delete();
		}
		else {
			destination = new File("trace5.xml");
			copyFile(from, destination);
			if(from.exists()) from.delete();			
		}
	}

	public static void copyFile(File from, File to ) throws IOException {
		Files.copy(from.toPath(), to.toPath());
	}

}
