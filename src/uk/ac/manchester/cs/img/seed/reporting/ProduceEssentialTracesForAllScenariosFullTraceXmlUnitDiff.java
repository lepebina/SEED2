package uk.ac.manchester.cs.img.seed.reporting;
public class ProduceEssentialTracesForAllScenariosFullTraceXmlUnitDiff {
	public static void main(String[] args) throws Exception {
		int i =1;
		while (i<=4) {
			if(i==1) {
				CompareTrace1VsTrace2.main(null);
		}
			else if(i==2) {
				CompareTrace1VsTrace3.main(null);
				}
			else if(i==3) {
				CompareTrace1VsTrace4.main(null);
				}
			else {
				CompareTrace1VsTrace5.main(null);
				}
			i++;
		}
       
    }


}
