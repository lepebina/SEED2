<duplicates>
{
for $trace1 in doc("traces/essential/unique_essential_traces.xml")//trace,
$trace2 in doc("traces/essential/unique_essential_traces.xml")//trace

let $et1 := $trace1/child::*

let $et2 := $trace2/child::*

where $trace1 << $trace2 and
deep-equal($et1,$et2)
 
return <duplicate>
          <hit> {$trace1/@scenario} </hit>
          <in>{$trace1/@feature} </in>
          <is-duplicate-of/>
          <hit> {$trace2/@scenario} </hit>
          <in> {$trace2/@feature} </in>
       </duplicate>
}
</duplicates>