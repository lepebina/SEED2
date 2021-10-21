<duplicates>
{
for $trace1 in doc("etraces/full/et_run1_vs_run2.xml")//trace,
$trace2 in doc("etraces/full/et_run1_vs_run3.xml")//trace,
or $trace3 in doc("etraces/full/et_run1_vs_run4.xml")//trace,
$trace4 in doc("etraces/full/et_run1_vs_run5.xml")//trace

let $et1 := $trace1/child::*
let $et2 := $trace2/child::*
let $et3 := $trace3/child::*
let $et4 := $trace4/child::*

where $trace1 << $trace2 and
deep-equal($et1,$et2) and
deep-equal($et1,$et3)
deep-equal($et1,$et4)
return <duplicate>
          <hit> {$trace1/@scenario} </hit>
          <in>{$trace1/@feature} </in>
          <is-duplicate-of/>
          <hit> {$trace2/@scenario} </hit>
          <in> {$trace2/@feature} </in>
       </duplicate>
}
</duplicates>