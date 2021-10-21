<duplicates>
{
for $trace1 in doc("clean_trace.xml")//trace,
$trace2 in doc("clean_trace.xml")//trace
let $sc1 := for $a in $trace1/class union $trace1/method union $trace1/param-types union $trace1/return-type
 return fn:data($a)
let $sc2 := for $b in $trace2/class union $trace2/method union $trace2/param-types union $trace2/return-type
return fn:data($b)
let $sc3 := for $c in $trace1/step
 return fn:data($c)
let $sc4 := for $d in $trace2/step
return fn:data($d)
let $sc5 := for $e in $trace1/step-args
 return fn:data($e)
let $sc6 := for $f in $trace2/step-args
return fn:data($f)
where $trace1 << $trace2
 and  (
    deep-equal($sc1, $sc2)
 or (deep-equal($sc3, $sc4) and deep-equal($sc5, $sc6))
 or deep-equal($sc5, $sc6) 
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