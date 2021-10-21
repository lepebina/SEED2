package uk.ac.manchester.cs.img.seed.reporting;

import net.sf.saxon.Transform;
public class ProduceEssentialTraceForManyScenarios {
	public static void main(String[] args) throws Exception {
        String[] arglist = {"-o:traces/essentials", "traces/essential/individual_scenarios", "merge_essential_traces.xslt"};

        Transform.main(arglist);
       
    }

}
