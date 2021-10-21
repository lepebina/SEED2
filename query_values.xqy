<values>
{
for $duplicate_pair in doc("duplicate-delete.xml")//duplicate
let $scenario1 := $duplicate_pair/hit/@scenario
let $scenario2 := $duplicate_pair/hitd/@scenario

let $steps_scenario1 := doc("scenarios.xml")/scenarios/scenario[@title = $scenario1]                
                                              
let $steps_scenario2 := doc("scenarios.xml")/scenarios/scenario[@title = $scenario2]

return 
    <pair>
       <scenario-1>{$steps_scenario1}</scenario-1>
       <scenario-2>{$steps_scenario2}</scenario-2>
    </pair>
        
}
</values>