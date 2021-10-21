<duplicates>
{
for $trace1 in doc("deduped_combined_single_trace.xml")//trace,
$trace2 in doc("deduped_combined_single_trace.xml")//trace

let $et1 := data($trace1/statement)

let $et2 := data($trace2/statement)

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