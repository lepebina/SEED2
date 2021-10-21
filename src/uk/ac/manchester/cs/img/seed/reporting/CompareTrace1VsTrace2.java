package uk.ac.manchester.cs.img.seed.reporting;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;

import javax.xml.transform.stream.StreamSource;

import org.custommonkey.xmlunit.DetailedDiff;
import org.custommonkey.xmlunit.Diff;
import org.custommonkey.xmlunit.Difference;
import org.custommonkey.xmlunit.DifferenceEngine;
import org.custommonkey.xmlunit.XMLUnit;
import org.xml.sax.SAXException;
import org.xmlunit.diff.Comparison;
import org.xmlunit.diff.ComparisonResult;
import org.xmlunit.diff.DOMDifferenceEngine;

import com.ximpleware.AutoPilot;
import com.ximpleware.VTDException;
import com.ximpleware.VTDGen;
import com.ximpleware.VTDNav;
import com.ximpleware.XMLModifier;


public class CompareTrace1VsTrace2 {
	static VTDGen vg = new VTDGen();
	static String inFile = "trace2.xml";
	static XMLModifier xm = new XMLModifier();


	public static void main(String args[]) throws FileNotFoundException, 
	SAXException, IOException, VTDException {

		// reading two xml files to compare in Java program
		FileInputStream firstFile = new FileInputStream("trace1.xml");
		FileInputStream secondFile = new FileInputStream("trace2.xml");

		// using BufferedReader for improved performance
		BufferedReader  versionOne = new BufferedReader(new InputStreamReader(firstFile));
		BufferedReader  versionTwo = new BufferedReader(new InputStreamReader(secondFile));

		//configuring XMLUnit to ignore white spaces
		XMLUnit.setIgnoreWhitespace(true);

		//comparing two XML using XMLUnit in Java
		List differences = computeDiff(versionOne, versionTwo);


		//showing differences found in two xml files
		printDifferences(differences);

		//get nodes with and without differences
		String fileOne = "trace1.xml";
		String fileTwo = "trace2.xml";
		Set<String> difs = getNodesWithandWithoutDifferences(fileOne, fileTwo);
		//changePlaceWithAny(difs);

		//update xml file with 'any' on places of difference
		Iterator<String> it = difs.iterator();

		File ets = new File("etraces/full/");
		if(!ets.exists()) {
			ets.mkdirs();
		}
		FileOutputStream fout = new FileOutputStream("etraces/full/et_run1_vs_run2.xml");

		vg.parseFile(inFile,true);
		VTDNav vn = vg.getNav();
		xm.bind(vn);
		while(it.hasNext()){
			//changePlaceWithAny(it.next());
			int result;
			AutoPilot ap = new AutoPilot();
			ap.selectXPath(it.next());					
			ap.bind(vn);
			while((result = ap.evalXPath())!=-1){

				//System.out.println(vn.getText() + vn.toString(result));
				xm.updateToken(result,"any");						

			}			

		}
		xm.output(fout);

	}

	public static List computeDiff(Reader version1, Reader version2) throws
	SAXException, IOException{

		//creating Diff instance to compare two XML files
		Diff xmlDiff = new Diff(version1, version2);        

		//for getting detailed differences between two xml files
		DetailedDiff detailXmlDiff = new DetailedDiff(xmlDiff); 

		return detailXmlDiff.getAllDifferences();
	}

	public static void printDifferences(List differences){
		int totalDifferences = differences.size();
		System.out.println("===============================");
		System.out.println("Total differences : " + totalDifferences);
		System.out.println("================================");

		for(Object difference : differences){
			System.out.println(difference);
		}
	}


	public static Set<String> getNodesWithandWithoutDifferences(String initialFile, String changedFile) {
		DOMDifferenceEngine engine = new DOMDifferenceEngine();
		final Set<String> noDifferences = new HashSet<>();
		final Set<String> differences = new HashSet<>();
		engine.addComparisonListener((c, o) -> {
			Comparison.Detail control = c.getControlDetails();
			if (control != null) {
				String xpath = control.getXPath();
				if (o == ComparisonResult.EQUAL) {
					if (!differences.contains(xpath)) {
						noDifferences.add(xpath);
					}
				} else {
					noDifferences.remove(xpath);
					differences.add(xpath);
				}
			}
		});
		engine.compare(new StreamSource(new File(initialFile)), new StreamSource(new File(changedFile)));
//		System.err.println("===FURTHER ANALYSIS OF THE COMPARED FILES=== ");
//		System.err.println("no differences: " + noDifferences);
//		System.err.println("differences: " + differences);

		return differences;
	}

}
