<duplicates>
{
for $trace1 in doc("e_full_traces_for_five_runs.xml")//trace,
$trace2 in doc("e_full_traces_for_five_runs.xml")//trace

let $et1 := $trace1/event/child::*

let $et2 := $trace2/event/child::*

let $mod1 := $trace1/event/modifier[text()='public']
let $mod2 := $trace2/event/modifier[text()='public']


where $trace1 << $trace2 and
deep-equal($et1,$et2) and $mod1 = $mod2
 
return <duplicate>
          <hit> {$trace1/@scenario} </hit>
          <in>{$trace1/@feature} </in>
          <is-duplicate-of/>
          <hit> {$trace2/@scenario} </hit>
          <in> {$trace2/@feature} </in>
       </duplicate>
}
</duplicates>