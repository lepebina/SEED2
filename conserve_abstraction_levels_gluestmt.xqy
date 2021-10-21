<suggestions>
{
for $duplicate_pair in doc("duplicates-system3.xml")//duplicate
let $scenario1 := $duplicate_pair/hit/@scenario
let $scenario2 := $duplicate_pair/hitd/@scenario

let $steps_scenario1 := doc("trace.xml")/traces/trace[@scenario = $scenario1]    
let $steps_scenario2 := doc("trace.xml")/traces/trace[@scenario = $scenario2] 

let $for_sc1_steps := doc("scenarios.xml")/scenarios/scenario[@title = $scenario1] 
let $for_sc2_steps := doc("scenarios.xml")/scenarios/scenario[@title = $scenario2]       
      
                          
let $all_steps_count := count(doc("scenarios.xml")//step)
let $all_glue_stmts_count := count(doc("trace.xml")//statement)
let $avg_stmts_per_step := $all_glue_stmts_count div $all_steps_count
let $sc1_avg_glue_stmts_per_step := count($steps_scenario1//statement) div count($for_sc1_steps//step)
let $sc2_avg_glue_stmts_per_step := count($steps_scenario2//statement) div count($for_sc2_steps//step)


let $sc1_abstraction_distance := abs($avg_stmts_per_step - $sc1_avg_glue_stmts_per_step)
let $sc2_abstraction_distance := abs($avg_stmts_per_step - $sc2_avg_glue_stmts_per_step) 

 return
     if($sc1_abstraction_distance = $sc2_abstraction_distance) then
      (
        <suggestion>
          <delete-scenario-with>{$steps_scenario1/@scenario}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <all-glue-statements-count>{$all_glue_stmts_count}</all-glue-statements-count>
          <average-statements-per-step>{$avg_stmts_per_step}</average-statements-per-step>
          <scenario1-avg-glue-statements-per-step>{$sc1_avg_glue_stmts_per_step}</scenario1-avg-glue-statements-per-step>
          <scenario2-avg-glue-statements-per-step>{$sc2_avg_glue_stmts_per_step}</scenario2-avg-glue-statements-per-step>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@scenario}</delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
        </suggestion>, '&#xa;'
       )
       else if($sc1_abstraction_distance > $sc2_abstraction_distance) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario1/@scenario}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with>{$steps_scenario2/@scenario}</keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario2/@scenario}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
         <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with> {$steps_scenario1/@scenario} </keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )     


 }
</suggestions>