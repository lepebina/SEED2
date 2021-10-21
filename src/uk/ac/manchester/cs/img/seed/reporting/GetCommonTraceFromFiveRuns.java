package uk.ac.manchester.cs.img.seed.reporting;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.HashMap;
import java.util.Iterator;

public class GetCommonTraceFromFiveRuns {
	public static void main(String[] args) {
	    String files[] = {"et_run1_vs_run2.xml", "et_run1_vs_run3.xml", "et_run1_vs_run4.xml", "et_run1_vs_run5.xml"};
	    HashMap<Integer, String> customers = new HashMap<Integer, String>();
	    try {
	        String line;
	        for(int i = 0; i < files.length; i++) {
	            BufferedReader reader = new BufferedReader(new FileReader(files[i]));
	            while((line = reader.readLine()) != null) {
	                Integer uuid = Integer.valueOf(line.split("|")[0]);
	                customers.put(uuid, line);
	            }
	            reader.close();
	        }

	        BufferedWriter writer = new BufferedWriter(new FileWriter("essential_trace.xml"));
	        Iterator<String> it = customers.values().iterator();
	        while(it.hasNext()) writer.write(it.next() + "\n");

	        writer.close();
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	}

}
