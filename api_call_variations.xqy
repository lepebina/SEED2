<duplicates>
{
for $trace1 in doc("deduped_combined_single_trace.xml")//trace,
$trace2 in doc("deduped_combined_single_trace.xml")//trace

let $et1 := for $a in $trace1/event/class union $trace1/event/method union $trace1/event/param-types union $trace1/event/return-type
 union $trace1/event/args union $trace1/event/return-value union $trace1/event/modifier[text()='public']
return fn:data($a) 
let $et2 := for $b in $trace2/event/class union $trace2/event/method union $trace2/event/param-types union $trace2/event/return-type
 union $trace2/event/args union $trace2/event/return-value union $trace2/event/modifier[text()='public']
return fn:data($b)    

where $trace1 << $trace2 and   
(
deep-equal($et1, $et2)  
 or contains(string-join($et1, ''), string-join($et2,''))
 or contains(string-join($et2, ''), string-join($et1,'')) 
  )
 

 
return <duplicate>
          <hit> {$trace1/@scenario} </hit>
          <in>{$trace1/@feature} </in>
          <is-duplicate-of/>
          <hit> {$trace2/@scenario} </hit>
          <in> {$trace2/@feature} </in>
       </duplicate>
}
</duplicates>