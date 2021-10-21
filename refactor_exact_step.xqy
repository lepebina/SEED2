<suggestions>
{
for $trace1 in doc("scenarios.xml")//scenario,
$trace2 in doc("scenarios.xml")//scenario

let $et1 := for $a in $trace1/Given/step union $trace1/When/step union $trace1/Then/step
return $a

let $et2 := for $b in $trace2/Given/step union $trace2/When/step union $trace2/Then/step
return $b 

where $trace1 << $trace2 and
deep-equal($et1,$et2)
 
return (<suggestion>
          <delete-scenario-with> {$trace1/@title} </delete-scenario-with>
          <in>{$trace1/@feature} </in>
          <or/>
          <delete-scenario-with> {$trace2/@title} </delete-scenario-with>
          <in> {$trace2/@feature} </in>
       </suggestion>, '&#xa;')
       }
   </suggestions>
       