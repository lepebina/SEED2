<duplicates>
{
for $trace1 in doc("et-system2.xml")//trace,
$trace2 in doc("et-system2.xml")//trace
let $sc1 := for $a in $trace1/event/class union $trace1/event/method union $trace1/event/param-types
 union $trace1/event/return-type  union $trace1/event/modifier union $trace1/statement
 return fn:data($a)
let $sc2 := for $b in $trace2/event/class union $trace2/event/method union $trace2/event/param-types
 union $trace2/event/return-type  union $trace2/event/modifier union $trace2/statement
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
       </duplicate>, '&#xa;'
}
</duplicates>