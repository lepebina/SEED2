package uk.ac.manchester.cs.img.seed.reporting;

import net.sf.saxon.Transform;


public class DedupCombinedSingleTrace {
    public static void main(String[] args) throws Exception {
        String[] arglist = {"-o:deduped_combined_single_trace.xml","e_full_traces_for_five_runs.xml", "dedup_merged_full_traces.xslt"};

        Transform.main(arglist);
       
    }  

}