<duplicates>
{
for $trace1 in doc("clean_trace.xml")//trace,
$trace2 in doc("clean_trace.xml")//trace
let $sc1 := for $a in $trace1/class union $trace1/method union $trace1/param-types union $trace1/return-type union $trace1/return-value
 return fn:data($a)
let $sc2 := for $b in $trace2/class union $trace2/method union $trace2/param-types union $trace2/return-type union $trace2/return-value
return fn:data($b)

where $trace1 << $trace2
 and  (
    deep-equal($sc1, $sc2)  
 or contains(string-join($sc1, ''), string-join($sc2,''))
 or contains(string-join($sc2, ''), string-join($sc1,'')) 
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