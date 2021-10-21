<suggestions>
{
for $duplicate_pair in doc("duplicates-system2.xml")//duplicate
let $scenario1 := $duplicate_pair/hit/@scenario
let $scenario2 := $duplicate_pair/hitd/@scenario

let $steps_scenario1 := doc("scenarios.xml")/scenarios/scenario[@title = $scenario1]                
                                              
let $steps_scenario2 := doc("scenarios.xml")/scenarios/scenario[@title = $scenario2]       
                          
let $all_scenarios_count := count(doc("scenarios.xml")//scenario)
let $all_steps_count := count(doc("scenarios.xml")//step)
let $avg_steps_count := $all_steps_count div $all_scenarios_count
let $sc1_steps_count := count($steps_scenario1//step)
let $sc2_steps_count := count($steps_scenario2//step)
let $sc1_abstraction_distance := abs($avg_steps_count - $sc1_steps_count)
let $sc2_abstraction_distance := abs($avg_steps_count - $sc2_steps_count) 

 return
     if($sc1_abstraction_distance = $sc2_abstraction_distance) then
      (
        <suggestion>
          <delete-scenario-with>{$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <scenarios-count>{$all_scenarios_count}</scenarios-count>
          <all-steps-count>{$all_steps_count}</all-steps-count>
          <average-step-count>{$avg_steps_count}</average-step-count>
          <scenario1-step-count>{$sc1_steps_count}</scenario1-step-count>
          <scenario2-step-count>{$sc2_steps_count}</scenario2-step-count>
          <or/>
          <delete-scenario-with> {$steps_scenario2/@title}</delete-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
        </suggestion>, '&#xa;'
       )
       else if($sc1_abstraction_distance > $sc2_abstraction_distance) then
       (
       <suggestion>
          <delete-scenario-with> {$steps_scenario1/@title}</delete-scenario-with>
          <in>{$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with>{$steps_scenario2/@title}</keep-scenario-with>
          <in> {$steps_scenario2/@feature}</in>
          <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )
       else (
       <suggestion>
          <delete-scenario-with>{$steps_scenario2/@title}</delete-scenario-with>
          <in>{$steps_scenario2/@feature}</in>
         <abstraction-distance>{$sc2_abstraction_distance}</abstraction-distance>
          <and/>
          <keep-scenario-with> {$steps_scenario1/@title} </keep-scenario-with>
          <in> {$steps_scenario1/@feature}</in>
          <abstraction-distance>{$sc1_abstraction_distance}</abstraction-distance>
       </suggestion>, '&#xa;'
       )     


 }
</suggestions>