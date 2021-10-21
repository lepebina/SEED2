package uk.ac.manchester.cs.img.seed.reporting;
import java.io.File;
import net.sf.saxon.Transform;

public class ProduceEssentialTracesForAllScenariosFullTrace {
	public static void main(String[] args) throws Exception {
		File ets = new File("etraces/full/");
		if(!ets.exists()) {
			ets.mkdirs();
		}
		int i =1;
		while (i<=4) {
			if(i==1) {
        String[] arglist = {"-o:etraces/full/et_run1_vs_run2.xml","trace1.xml", "common_full_trace_12.xslt"};
        Transform.main(arglist);
		}
			else if(i==2) {
		        String[] arglist = {"-o:etraces/full/et_run1_vs_run3.xml","trace1.xml", "common_full_trace_13.xslt"};
		        Transform.main(arglist);
				}
			else if(i==3) {
		        String[] arglist = {"-o:etraces/full/et_run1_vs_run4.xml","trace1.xml", "common_full_trace_14.xslt"};
		        Transform.main(arglist);
				}
			else {
		        String[] arglist = {"-o:etraces/full/et_run1_vs_run5.xml","trace1.xml", "common_full_trace_15.xslt"};
		        Transform.main(arglist);
				}
			i++;
		}
       
    }

}
