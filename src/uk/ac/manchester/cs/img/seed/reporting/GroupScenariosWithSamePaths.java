package uk.ac.manchester.cs.img.seed.reporting;

import net.sf.saxon.Transform;
public class GroupScenariosWithSamePaths {
    public static void main(String[] args) throws Exception {
        String[] arglist = {"-o:merged_scenarios_paths.xml","individual_scenario_path.xml", "merge.xslt"};

        Transform.main(arglist);
       
    }
}
